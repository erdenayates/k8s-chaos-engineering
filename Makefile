.PHONY: build
build:
    go build -o bin/k8s-chaos-engineering ./cmd/k8s-chaos-engineering

.PHONY: test
test:
    go test -v ./...

.PHONY: docker-build
docker-build:
    docker build -t erdenayates/k8s-chaos-engineering:latest .

.PHONY: docker-push
docker-push:
    docker push erdenayates/k8s-chaos-engineering:latest
