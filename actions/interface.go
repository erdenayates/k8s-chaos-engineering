package actions

// ChaosAction defines the interface for chaos actions
type ChaosAction interface {
    Apply() error
    Revert() error
}
