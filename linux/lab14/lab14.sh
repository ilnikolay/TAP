#!/usr/bin/env bash

curl -s https://jsonplaceholder.typicode.com/comments | jq '.[] | select(.postId==66 and .id>327) | .email, .body'

#for further testing the jq capabilities
#curl -s https://jsonplaceholder.typicode.com/comments | jq '.[] | select(.postId==66 and .id>327) | { email, body} | join(" ")'
