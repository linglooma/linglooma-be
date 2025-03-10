DB_URL=postgresql://root:secret@localhost:5432/linglooma?sslmode=disable

network:
	docker network create linglooma-network

postgres:
	docker run --name postgres --network linglooma-network -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=secret -d postgres:17.3-alpine3.21

mysql:
	docker run --name mysql8 -p 3306:3306  -e MYSQL_ROOT_PASSWORD=secret -d mysql:8

createdb:
	docker exec -it postgres createdb --username=root --owner=root linglooma

dropdb:
	docker exec -it postgres dropdb linglooma

backupdb:
	docker exec -t postgres pg_dump -U root -d linglooma > linglooma_backup.sql

recoverdb:
	cat linglooma_backup.sql | docker exec -i postgres psql -U root -d linglooma

migrateup:
	migrate -path db/migration -database "$(DB_URL)" -verbose up

migrateup1:
	migrate -path db/migration -database "$(DB_URL)" -verbose up 1

migratedown:
	migrate -path db/migration -database "$(DB_URL)" -verbose down

migratedown1:
	migrate -path db/migration -database "$(DB_URL)" -verbose down 1

new_migration:
	migrate create -ext sql -dir db/migration -seq $(name)

db_docs:
	dbdocs build doc/db.dbml

db_schema:
	dbml2sql --postgres -o doc/schema.sql doc/db.dbml

sqlc:
	sqlc generate

test:
	go test -v -cover -short ./...

server:
	go run ./cmd/main.go

mock:
	mockgen -package mockdb -destination db/mock/store.go github.com/linglooma/linglooma-be/db/sqlc Store
	mockgen -package mockwk -destination worker/mock/distributor.go github.com/linglooma/linglooma-be/worker TaskDistributor

proto:
	rm -f pb/*.go
	rm -f doc/swagger/*.swagger.json
	protoc --proto_path=proto --go_out=pb --go_opt=paths=source_relative \
	--go-grpc_out=pb --go-grpc_opt=paths=source_relative \
	--grpc-gateway_out=pb --grpc-gateway_opt=paths=source_relative \
	--openapiv2_out=doc/swagger --openapiv2_opt=allow_merge=true,merge_file_name=linglooma \
	proto/*.proto
	statik -src=./doc/swagger -dest=./doc

evans:
	evans --host localhost --port 9090 -r repl

redis:
	docker run --name redis -p 6379:6379 -d redis:8.0-M03-alpine

build:
	go build -o main cmd/main.go

syncing:
	rsync -avz ./ automl@112.137.129.161:/home/automl/Xuanan/Linglooma/linglooma-be/ && \
	ssh automl@112.137.129.161 "tmux send-keys -t 4 C-c Enter; tmux send-keys -t 4 'make server' Enter;"

.PHONY: network postgres createdb dropdb migrateup migratedown migrateup1 migratedown1 new_migration db_docs db_schema sqlc test server mock proto evans redis
