## 1. This is the Dockerfile:
```
FROM python:3.10.1-alpine3.15

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

RUN apk add --no-cache gcc musl-dev linux-headers

WORKDIR /code
COPY . .

RUN pip install -r requirements.txt

EXPOSE 5000
CMD ["flask", "run"]
```

## 2. This is the compose file:
```
version: "3.9"

volumes:
  redis-app:

services:
  redis:
    image: redis:alpine
  flask-app:
    build: .
    ports:
      - "5000:5000"
    volumes:
      - redis-app:/code
    environment:
      - FLASK_ENV=development
    depends_on:
      - redis
```
![App](https://github.com/ilnikolay/TAP/blob/main/Docker_VM/lab06/task2/Screenshot%202021-12-09%20at%2017.15.06.png)
