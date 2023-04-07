FROM golang:1.20.2 AS builder

ENV GO111MODULE on
ENV GOPROXY "https://goproxy.cn,direct"
ENV GOFLAGS="-buildvcs=false"

ADD . /code
WORKDIR /code/src/etcdkeeper

RUN go mod tidy && go build -o etcdkeeper main.go

FROM debian:stable-slim
MAINTAINER "leiax00@outlook.com"

ENV EK_HOST="0.0.0.0"
ENV EK_PORT="8080"
ENV EK_AUTH="false"

WORKDIR /app
COPY --from=builder /code/src/etcdkeeper/etcdkeeper .
COPY --from=builder /code/assets assets

EXPOSE ${EK_PORT}

CMD ["sh", "-c", "./etcdkeeper -h $EK_HOST -p $EK_PORT -auth $EK_AUTH"]
