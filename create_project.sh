#!/bin/bash

# Set your module name and GitHub username
MODULE_NAME="k8s-chaos-engineering"
GITHUB_USERNAME="erdenayates"

# Create project directories
mkdir -p ${MODULE_NAME}/api/v1
mkdir -p ${MODULE_NAME}/cmd/${MODULE_NAME}
mkdir -p ${MODULE_NAME}/controllers
mkdir -p ${MODULE_NAME}/actions
mkdir -p ${MODULE_NAME}/pkg/utils
mkdir -p ${MODULE_NAME}/config/crd/v1
mkdir -p ${MODULE_NAME}/config/rbac

# Initialize go.mod
cat << EOF > ${MODULE_NAME}/go.mod
module github.com/${GITHUB_USERNAME}/${MODULE_NAME}

go 1.16

require (
    k8s.io/apimachinery v0.22.2
    k8s.io/client-go v0.22.2
    sigs.k8s.io/controller-runtime v0.10.1
)
EOF

# Create main.go
cat << EOF > ${MODULE_NAME}/cmd/${MODULE_NAME}/main.go
package main

import (
    "os"

    "github.com/${GITHUB_USERNAME}/${MODULE_NAME}/controllers"
    "github.com/${GITHUB_USERNAME}/${MODULE_NAME}/pkg/utils"
    "sigs.k8s.io/controller-runtime/pkg/manager"
)

func main() {
    // Initialize the manager and create the controllers
}
EOF

# Create chaos_experiment_types.go
cat << EOF > ${MODULE_NAME}/api/v1/chaos_experiment_types.go
package v1

import (
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// ChaosExperimentSpec defines the desired state of a ChaosExperiment
type ChaosExperimentSpec struct {
    // Add your custom fields here
}

// ChaosExperimentStatus defines the observed state of a ChaosExperiment
type ChaosExperimentStatus struct {
    // Add your custom fields here
}

// ChaosExperiment is the Schema for the chaosexperiments API
type ChaosExperiment struct {
    metav1.TypeMeta   \`json:",inline"\`
    metav1.ObjectMeta \`json:"metadata,omitempty"\`

    Spec   ChaosExperimentSpec   \`json:"spec,omitempty"\`
    Status ChaosExperimentStatus \`json:"status,omitempty"\`
}

// ChaosExperimentList contains a list of ChaosExperiment
type ChaosExperimentList struct {
    metav1.TypeMeta \`json:",inline"\`
    metav1.ListMeta \`json:"metadata,omitempty"\`
    Items           []ChaosExperiment \`json:"items"\`
}
EOF

# Create chaos_experiment_controller.go
cat << EOF > ${MODULE_NAME}/controllers/chaos_experiment_controller.go
package controllers

import (
    "github.com/${GITHUB_USERNAME}/${MODULE_NAME}/api/v1"
    "sigs.k8s.io/controller-runtime/pkg/controller"
)

// ChaosExperimentController is the controller for managing ChaosExperiment resources
type ChaosExperimentController struct {
    // Add your custom fields here
}

// Reconcile handles the reconciliation loop for ChaosExperiment resources
func (r *ChaosExperimentController) Reconcile() {
    // Implement the reconciliation logic for ChaosExperiment resources
}
EOF

# Create interface.go
cat << EOF > ${MODULE_NAME}/actions/interface.go
package actions

// ChaosAction defines the interface for chaos actions
type ChaosAction interface {
    Apply() error
    Revert() error
}
EOF

# Create an example action file: pod_kill.go
cat << EOF > ${MODULE_NAME}/actions/pod_kill.go
package actions

import (
    "fmt"
)

type PodKill struct {
    // Add your custom fields here
}

func (p *PodKill) Apply() error {
    fmt.Println("Applying pod kill action")
    // Implement pod kill action logic here
    return nil
}

func (p *PodKill) Revert() error {
    fmt.Println("Reverting pod kill action")
    // Implement revert logic for pod kill action here
    return nil
}
# Create k8s.go
cat << EOF > ${MODULE_NAME}/pkg/utils/k8s.go
package utils

import (
    "k8s.io/client-go/kubernetes"
    "k8s.io/client-go/rest"
)

// NewKubernetesClient creates a new Kubernetes client using in-cluster configuration
func NewKubernetesClient() (*kubernetes.Clientset, error) {
    config, err := rest.InClusterConfig()
    if err != nil {
        return nil, err
    }

    clientset, err := kubernetes.NewForConfig(config)
    if err != nil {
        return nil, err
    }

    return clientset, nil
}
EOF

# Create chaos_experiment.yaml
cat << EOF > ${MODULE_NAME}/config/crd/v1/chaos_experiment.yaml
apiVersion: apiextensions.k8s.io/v1
kind: CustomResourceDefinition
metadata:
  name: chaosexperiments.${MODULE_NAME}.${GITHUB_USERNAME}.com
spec:
  group: ${MODULE_NAME}.${GITHUB_USERNAME}.com
  versions:
    - name: v1
      served: true
      storage: true
      schema:
        openAPIV3Schema:
          type: object
          properties:
            spec:
              type: object
              properties:
                # Add your custom fields here
            status:
              type: object
              properties:
                # Add your custom fields here
  names:
    kind: ChaosExperiment
    plural: chaosexperiments
    singular: chaosexperiment
  scope: Namespaced
EOF

# Create role.yaml, role_binding.yaml, and service_account.yaml
touch ${MODULE_NAME}/config/rbac/role.yaml
touch ${MODULE_NAME}/config/rbac/role_binding.yaml
touch ${MODULE_NAME}/config/rbac/service_account.yaml

# Create Dockerfile
cat << EOF > ${MODULE_NAME}/Dockerfile
FROM golang:1.16 as builder

WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o ${MODULE_NAME} ./cmd/${MODULE_NAME}

FROM alpine:3.14
COPY --from=builder /app/${MODULE_NAME} /${MODULE_NAME}
ENTRYPOINT ["/${MODULE_NAME}"]
EOF

# Create Makefile
cat << EOF > ${MODULE_NAME}/Makefile
.PHONY: build
build:
    go build -o bin/${MODULE_NAME} ./cmd/${MODULE_NAME}

.PHONY: test
test:
    go test -v ./...

.PHONY: docker-build
docker-build:
    docker build -t ${GITHUB_USERNAME}/${MODULE_NAME}:latest .

.PHONY: docker-push
docker-push:
    docker push ${GITHUB_USERNAME}/${MODULE_NAME}:latest
EOF

# Create LICENSE and README.md
touch ${MODULE_NAME}/LICENSE
touch ${MODULE_NAME}/README.md
