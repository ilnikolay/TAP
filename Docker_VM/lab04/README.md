### Task 1 Dockerfile:
```bash
FROM python:3

WORKDIR /usr/src/app

COPY . .

ENTRYPOINT ["python"]

CMD ["hello.py"]
```

### Task 2 and 4 Dockerfile:

#### docker build --build-arg username=niki --build-arg group=test -t test_arg:niki.test .
```bash
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
```bash
#!/usr/bin/env bash
#set -x

docker run --name alpine_lab -d alpine:3
dockid=`docker ps -aqf "name=alpine_lab"`
echo "Container ID is: $dockid"
echo "Removing cointainer with ID: $dockid"
docker rm $dockid
```
