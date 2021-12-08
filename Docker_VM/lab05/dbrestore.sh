#!/usr/bin/env bash
#set -x

function restore {
  echo "Creating new Volume: todo-db"
  docker volume create todo-db
  echo "Creating 3 new containers with todo.db from the backup!!!"
  docker create -p 3001:3000 --name todo1 --mount source=todo-db,target=/etc/todos todo-manager
  docker create -p 3002:3000 --name todo2 --mount source=todo-db,target=/etc/todos todo-manager
  docker create -p 3003:3000 --name todo3 --mount source=todo-db,target=/etc/todos todo-manager
  echo "Copying the db to the containers..."
  docker cp /Users/nikolayninov/Work/TAP/docker/lab02/docker-tap/backup/todos/todo.db todo1:/etc/todos/
  echo "Starting containers..."
  docker start todo1 todo2 todo3
}

# Check if containers are running, and deletes them
is_container=`docker ps | awk '($2=="todo-manager") {print $1}'`
if [[ -n $is_container ]]; then
  docker stop $is_container
  docker rm $is_container
fi


is_volume=`docker volume ls | grep -w "todo-db"`
if [[ -n $is_volume ]]; then
  echo "Deleting volume todo-db."
  docker volume rm todo-db
  restore
else
  restore
fi
