# Gateway API Meetup Demo

## Setup Instructions

### 1. Start Kind Cluster

```bash
kind create cluster --config kind.yaml
```

### 2. Install Gateway API CRDs

```bash
# Install Gateway API CRDs
kubectl apply -k https://github.com/kubernetes-sigs/gateway-api/config/crd
```


### 3. Install Cilium

```bash
cilium install --version 1.18.2 --values manifests/cilium/values.yaml
```

### 4. Deploy Demo Application

Navigate to the `manifests/cilium-gateway-api-demo` directory and deploy the demo or explore the Gateway API features.

## Next Steps

- Go to [`manifests/cilium-gateway-api-demo`](./manifests/cilium-gateway-api-demo/) for the complete demo
- Explore Gateway API routing, traffic splitting, and canary deployments
- Experiment with different Gateway API configurations