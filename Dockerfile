FROM golang:1.17 AS builder
WORKDIR $GOPATH/nfs-tester
COPY . . 
RUN go mod download
# cross compilation enabled (by default it is built for native system only)
RUN CGO_ENABLED=0 go build -o nfs-tester . 

FROM ubuntu
RUN apt-get update && apt-get install -y fio
COPY --from=builder /go/nfs-tester/nfs-tester /
CMD ["/bin/bash", "-c", "echo 'Define run command first'; while true; do echo 'Hit CTRL+C'; sleep 1; done"]