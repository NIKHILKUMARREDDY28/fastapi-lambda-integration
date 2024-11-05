#!/bin/sh

# Change to the specified directory
#cd /home/nikhilkumarreddy/Desktop/skil.ai/fastapi-lambda-integration

# Step 1: Pull the latest code from the master branch
echo "===== Grabbing latest code ====="
git checkout master
git pull origin master

# Step 2: Stop and remove the current Docker container if it exists
echo "===== Stop current container ====="
docker stop fastapi-poetry-lambda || true && docker rm fastapi-poetry-lambda || true

# Step 3: Build a new Docker image
echo "\n\n === Building Docker Image ==="
docker build -t fastapi-poetry-lambda .

# Step 4: Tag the Docker image for ECR
echo "\n\n === Tagging Docker Image for ECR ==="
docker tag fastapi-poetry-lambda:latest 767397958880.dkr.ecr.ap-south-1.amazonaws.com/fastapi-poetry-lambda:latest
# Step 5: Authenticate Docker to ECR
echo "\n\n === Authenticating Docker to ECR ==="
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 767397958880.dkr.ecr.ap-south-1.amazonaws.com
# Step 6: Push the Docker image to ECR
echo "\n\n === Pushing Docker Image to ECR ==="
docker push 767397958880.dkr.ecr.ap-south-1.amazonaws.com/fastapi-poetry-lambda:latest

# Step 7: Run a new Docker container with the specified environment variables and port mappings
echo "\n\n ===== Run docker for ai-core-services ==== "
docker run -v ~/.aws:/root/.aws -e AI_ENV=dev -e PORT=8001 -e PYTHONUNBUFFERED=0 -d -p 5000:5000 -p 5005:5005 -p 6001:6001 -p 8000:8000 -p 11434:11434 --name fastapi-poetry-lambda fastapi-poetry-lambda:latest

# Step 8: Wait for 5 seconds
echo "\n\n === Sleeping for 5 sec(s) ==="
sleep 5

# Step 9: List all Docker containers
echo "\n == Current docker instances ==="
docker ps -a

# Step 10: Display the logs of the new Docker container
echo "\n == Log file ==="
docker logs --tail 3000 fastapi-poetry-lambda