FROM golang:1.20.2 AS builder

ENV GO111MODULE on
ENV GOPROXY "https://goproxy.cn,direct"
ENV GOFLAGS="-buildvcs=false"

ADD . /code
WORKDIR /code/src/etcdkeeper

RUN go mod tidy && go build -o etcdkeeper main.go

FROM debian:stable-slim
MAINTAINER "leiax00@outlook.com"

ENV HOST="0.0.0.0"
ENV PORT="8080"

WORKDIR /app
COPY --from=builder /code/src/etcdkeeper/etcdkeeper .
COPY --from=builder /code/assets assets

EXPOSE ${PORT}

ENTRYPOINT ./etcdkeeper -h $HOST -p $PORT
