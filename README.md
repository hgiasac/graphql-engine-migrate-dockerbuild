# graphql-engine-migrate-dockerfile

GraphQL Engine migration Dockerfile template for Hasura v2

## How to use

Copy `migrate.sh` and `Dockerfile` to your Hasura migration folder. Edit the graphql-engine version and build.

## Environment variables

| Name | Description | Required | Example |
| ---- | ----------- | -------- | ------- |
| ENDPOINT | Endpoint of the graphql-engine service | Yes | http://localhost:8080 |
| HASURA_GRAPHQL_ADMIN_SECRET | Admin secret of the graphql-engine service | Yes | hasura |
| MIGRATIONS_TIMEOUT | The process waits until the service online, with timeout (default 30s) | No | 30 |