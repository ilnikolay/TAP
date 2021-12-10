### 1. Here is the Dockerfile
```
FROM golang AS build

WORKDIR /app

COPY ./app .

WORKDIR /app/hello

RUN go build -o hello

FROM scratch
COPY --from=build /app/hello /bin
ENTRYPOINT ["/bin/hello"]
CMD ["hello"]
```

### 2. Build multi architecture image and push to docker hub. We could've pushed directly to private registry, but I created it later.
```
docker buildx build --push --platform linux/arm/v7,linux/arm64,linux/amd64 -t ilniko/multiarch-hello .
```
### 3. Create our private registry in docker-reg
### 4. Tag with our private registry prefix
```
docker tag ilniko/multiarch-hello localhost:5005/multiarch-hello:latest
```
### 5. Push to our private repo
```
docker push localhost:5005/multiarch-hello:latest
The push refers to repository [localhost:5005/multiarch-hello]
5cbf15f4a29c: Pushed 
latest: digest: sha256:b3dc4c65c7e29da7d46d87a7fde2c456b498d4c8a36374eaeb4f021e7dacae90 size: 527
```
