FROM golang:alpine as build
LABEL author="Jason Wilder <mail@jasonwilder.com>"
LABEL maintainer="Hugo Haldi <hugo.haldi@gmail.com>"

RUN apk add --no-cache --virtual .run-deps \
    make git

WORKDIR /usr/src/docker-gen

COPY . .

RUN go get -d ./...
RUN make

FROM alpine:latest

RUN apk add --no-cache --virtual .run-deps \
    openssl

ENV DOCKER_HOST unix:///tmp/docker.sock

COPY --from=build /usr/src/docker-gen/docker-gen /usr/local/bin

ENTRYPOINT ["/usr/local/bin/docker-gen"]
