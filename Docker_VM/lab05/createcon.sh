#!/usr/bin/env bash
image_name="todo-manager"
volume_name="todo-db"
build_dir="/Users/nikolayninov/Work/TAP/docker/lab02/docker-tap/app/"
backup="/Users/nikolayninov/Work/TAP/docker/lab02/docker-tap/backup/todos"

# Creating volume
docker volume create $volume_name

# Build the image
docker build -t $image_name $build_dir

# Run containers
docker run -dp 3001:3000 --name todo1 --mount source=$volume_name,target=/etc/todos $image_name
docker run -dp 3002:3000 --name todo2 --mount source=$volume_name,target=/etc/todos $image_name
docker run -dp 3003:3000 --name todo3 --mount source=$volume_name,target=/etc/todos $image_name

# Create cronjob
(crontab -l; echo "0 * * * * /usr/local/bin/docker cp todo1:/etc/todos/todo.db $backup") | sort -u | crontab -
