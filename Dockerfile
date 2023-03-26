FROM golang:1.16 as builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o k8s-chaos-engineering ./cmd/k8s-chaos-engineering

FROM alpine:3.14
COPY --from=builder /app/k8s-chaos-engineering /k8s-chaos-engineering
ENTRYPOINT ["/k8s-chaos-engineering"]
