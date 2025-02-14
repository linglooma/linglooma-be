## Setup local development

### Install tools

- [Docker desktop](https://www.docker.com/products/docker-desktop)
- [TablePlus](https://tableplus.com/)
- [Golang](https://golang.org/)
- [Homebrew](https://brew.sh/)
- [Migrate](https://github.com/golang-migrate/migrate/tree/master/cmd/migrate)

    ```bash
    brew install golang-migrate
    ```

- [DB Docs](https://dbdocs.io/docs)

    ```bash
    npm install -g dbdocs
    dbdocs login
    ```

- [DBML CLI](https://www.dbml.org/cli/#installation)

    ```bash
    npm install -g @dbml/cli
    dbml2sql --version
    ```

- [Sqlc](https://github.com/kyleconroy/sqlc#installation)

    ```bash
    brew install sqlc
    ```

- [Gomock](https://github.com/golang/mock)

    ``` bash
    go install github.com/golang/mock/mockgen@v1.6.0
    ```

### Setup infrastructure

- Create the bank-network

    ``` bash
    make network
    ```

- Start postgres container:

    ```bash
    make postgres
    ```

- Create simple_bank database:

    ```bash
    make createdb
    ```

- Run db migration up all versions:

    ```bash
    make migrateup
    ```

- Run db migration up 1 version:

    ```bash
    make migrateup1
    ```

- Run db migration down all versions:

    ```bash
    make migratedown
    ```

- Run db migration down 1 version:

    ```bash
    make migratedown1
    ```

### Documentation

- Generate DB documentation:

    ```bash
    make db_docs
    ```

- Access the DB documentation at [this address](https://dbdocs.io/techschool.guru/simple_bank). Password: `secret`

### How to generate code

- Generate schema SQL file with DBML:

    ```bash
    make db_schema
    ```

- Generate SQL CRUD with sqlc:

    ```bash
    make sqlc
    ```

- Generate DB mock with gomock:

    ```bash
    make mock
    ```

- Create a new db migration:

    ```bash
    make new_migration name=<migration_name>
    ```

### How to run

- Run server:

    ```bash
    make server
    ```

- Run test:

    ```bash
    make test
    ```

## Deploy to kubernetes cluster

- [Install nginx ingress controller](https://kubernetes.github.io/ingress-nginx/deploy/#aws):

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.48.1/deploy/static/provider/aws/deploy.yaml
    ```

- [Install cert-manager](https://cert-manager.io/docs/installation/kubernetes/):

    ```bash
    kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
    ```

## 📂 Project Structure


| **Folder/File**          | **Purpose** |
|--------------------------|------------|
| **`cmd/`**              | Entry point of the application. The `main.go` file initializes dependencies and starts the app. |
| **`doc/`**              | Documentation files for the project. |
| **`doc/db.dbml`**       | Database schema definition using DBML (for tools like [DBML](https://dbml.org/)). |
| **`doc/swagger/`**      | Swagger (OpenAPI) documentation for API specifications. |
| **`Docker-compose.yaml`** | Defines services and dependencies for running the app in Docker containers. |
| **`Dockerfile`**        | Instructions to build a Docker image for the application. |
| **`go.mod` & `go.sum`** | Go module dependencies and checksum files. |
| **`internal/`**         | Core business logic following **Domain-Driven Design (DDD)** principles. Everything here is private to the module. |
| **`Makefile`**         | Defines useful commands for building, testing, running, and deploying the project. |
| **`pb/`**              | Generated **Protobuf (gRPC)** files for inter-service communication. |
| **`pkg/`**             | Reusable, shareable libraries and utilities (e.g., logging, middleware). Unlike `internal/`, these can be imported from outside the module. |
| **`proto/`**           | Contains `.proto` files defining the gRPC service and message structures. |
| **`README.md`**        | Documentation for the project, setup instructions, and usage guidelines. |
| **`sqlc.yaml`**        | Configuration file for [SQLC](https://sqlc.dev/), which generates Go code for SQL queries. |
| **`start.sh`**         | Shell script to start the application with necessary environment setups. |
| **`utils/`**           | Utility functions such as configuration loading, logging, or helper methods. |
| **`utils/config.go`**  | Loads environment variables and application configurations. |
| **`val/`**             | Input validation logic (e.g., request validation, struct validation). |
| **`val/validator.go`** | Defines validation rules using a library like [`validator.v10`](https://github.com/go-playground/validator). |
| **`wait-for.sh`**      | A script used to wait for dependencies (like databases) before starting the app. |
| **`worker/`**          | Background tasks, cron jobs, and async workers. |
| **`worker/logger.go`** | Worker-specific logging utilities. |

---