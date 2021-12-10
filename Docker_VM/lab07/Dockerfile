FROM golang AS build

WORKDIR /app

COPY ./app .

WORKDIR /app/hello

RUN go build -o hello

FROM scratch
COPY --from=build /app/hello /bin
ENTRYPOINT ["/bin/hello"]
CMD ["hello"]
