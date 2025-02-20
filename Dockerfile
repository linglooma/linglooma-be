# Build stage
FROM golang:1.24.0-alpine AS builder
WORKDIR /app
COPY . .
RUN go build -o main ./cmd/main.go

# Run stage
FROM alpine:latest
WORKDIR /app
COPY --from=builder /app/main .
COPY .env .
COPY start.sh .
COPY wait-for.sh .
COPY db/migration ./db/migration

EXPOSE 8080 9090
RUN ["chmod", "777", "./app/start.sh"]
RUN ["chmod", "777", "./app/wait-for.sh"]
CMD [ "/app/main" ]
ENTRYPOINT [ "/app/start.sh" ]
