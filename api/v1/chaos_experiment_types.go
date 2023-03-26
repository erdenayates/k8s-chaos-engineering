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
    metav1.TypeMeta   `json:",inline"`
    metav1.ObjectMeta `json:"metadata,omitempty"`

    Spec   ChaosExperimentSpec   `json:"spec,omitempty"`
    Status ChaosExperimentStatus `json:"status,omitempty"`
}

// ChaosExperimentList contains a list of ChaosExperiment
type ChaosExperimentList struct {
    metav1.TypeMeta `json:",inline"`
    metav1.ListMeta `json:"metadata,omitempty"`
    Items           []ChaosExperiment `json:"items"`
}
