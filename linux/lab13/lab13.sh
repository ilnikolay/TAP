#!/usr/bin/env bash

curl -s https://jsonplaceholder.typicode.com/comments | grep -A4 '"postId": 66' | grep -E -A3 -e '"id": 3[2-9][8-9]|3[3-9][0-9]' | grep -e '"email"' -e '"body"' | cut -d: -f2 | sed 's/,$//'
