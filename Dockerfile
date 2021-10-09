FROM debian:stable-slim

ARG VERSION=v2.0.9

# set an env var to let the cli know that
# update notification is disabled
ENV HASURA_GRAPHQL_SHOW_UPDATE_NOTIFICATION=false
RUN apt-get update && apt-get install -y \
  curl \
  wget \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /
ADD . .

# download hasura-cli 
RUN wget https://github.com/hasura/graphql-engine/releases/download/${VERSION}/cli-hasura-linux-amd64 \
  -O /usr/bin/hasura

RUN chmod +x /migrate.sh
RUN chmod +x /usr/bin/hasura

ENTRYPOINT ["sh", "/migrate.sh"]
