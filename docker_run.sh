#!/bin/sh

echo "===== Grabbing latest code ====="
git checkout  master
git pull origin master

echo "===== stop current container ====="
docker stop fastapi-poetry-lambda || true && docker rm fastapi-poetry-lambda || true

echo "\n\n === Building Docker Image ==="
docker build -t fastapi-poetry-lambda:latest .

echo "\n\n ===== Run docker for ai-core-services ==== "
docker run -e PORT=8000 -e PYTHONUNBUFFERED=0 -d -p 8000:8000 --name fastapi-poetry-lambda fastapi-poetry-lambda
echo "\n\n === Sleeping for 5 sec(s) ==="
sleep 5

echo "\n == Current docker instances ==="
docker ps -a

echo "\n == Log file ==="
docker logs  --tail 3000 fastapi-poetry-lambda

