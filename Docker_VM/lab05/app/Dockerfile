# syntax=docker/dockerfile:1
FROM node:12-alpine

RUN apk add --update --no-cache python2 g++ make


WORKDIR /app


COPY package.json  ./

RUN yarn install --production

COPY . .


CMD ["node", "src/index.js"]
