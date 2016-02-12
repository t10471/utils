#!/bin/bash

# 下記URLのイメージ
# https://registry.hub.docker.com/_/rabbitmq/
# 起動
docker run -d -e RABBITMQ_NODENAME=my-rabbit --name rabbit rabbitmq:3
