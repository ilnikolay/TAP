### Task 1 Dockerfile:
```
FROM python:3

WORKDIR /usr/src/app

COPY . .

ENTRYPOINT ["python"]

CMD ["hello.py"]
```

### Task 2 and 4 Dockerfile:

#### docker build --build-arg username=niki --build-arg group=test -t test_arg:niki.test .
```
FROM alpine:3

ARG username
ARG group

RUN adduser -D $username && addgroup $group

WORKDIR /app

COPY --chown=${username}:${group}  hello.py .

ENTRYPOINT ["/bin/sh", "-c"]
CMD ["ls -l", "hello.py"]
```

### Task 3
```
https://hub.docker.com/repository/docker/ilniko/hello
```

### Task 5
```
#!/usr/bin/env bash
#set -x

`docker run -d alpine:3 > /dev/null`
if [[ $? -eq 0 ]]; then
  dockid=`docker ps -a | grep alpine | awk '{print $1}'`
  echo "Container ID is: $dockid"
  echo "Removing cointainer with ID: $dockid"
  `docker rm $dockid > /dev/null`
fi
```
