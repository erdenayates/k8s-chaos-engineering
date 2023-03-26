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
cat << EOF > k8s-chaos-engineering/pkg/utils/k8s.go
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
