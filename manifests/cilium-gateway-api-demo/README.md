# Cilium Gateway API Demo

This project demonstrates the use of the Cilium Gateway API with a simple application running two versions of a service. The setup includes two namespaces, deployments for each version of the application, a service to route traffic, a gateway to manage incoming requests, and routing rules to control traffic distribution.

## Project Structure

# Cilium Gateway API Demo

This project demonstrates the use of the Cilium Gateway API with a simple application running two versions of a service. The setup includes a namespace for the demo applications, deployments for each version of the application, services to route traffic, a gateway to manage incoming requests, and routing rules to control traffic distribution with canary deployment capabilities.

## Project Structure

```
cilium-gateway-api-demo
├── manifests
│   ├── 01-namespaces.yaml         # Defines the demo-app namespace
│   ├── 02-app-deployments.yaml     # Deployment configurations for app-v1 and app-v2
│   ├── 03-app-service.yaml         # Services for app-service-v1 and app-service-v2
│   ├── 04-gateway.yaml             # Sets up the cilium gateway in default namespace
│   ├── 05-httproute.yaml           # HTTPRoute configuration for traffic routing with canary support
│   └── 06-echo-service.yaml        # Echo server pod and service for testing
├── test
│   └── curl-commands.sh            # Curl commands for testing the setup
└── README.md                       # Project documentation
```

## Setup Instructions

1. **Install Kubernetes**: Ensure you have a Kubernetes cluster running. You can use Minikube, Kind, or any cloud provider.

2. **Install Cilium**: Follow the [Cilium installation guide](https://docs.cilium.io/en/stable/gettingstarted/k8s/) to set up Cilium in your cluster with Gateway API support enabled.

3. **Apply Manifests**: Navigate to the `manifests` directory and apply the Kubernetes manifests in order:

   ```bash
   kubectl apply -f 01-namespaces.yaml
   kubectl apply -f 02-app-deployments.yaml
   kubectl apply -f 03-app-service.yaml
   kubectl apply -f 04-gateway.yaml
   kubectl apply -f 05-httproute.yaml
   kubectl apply -f 06-echo-service.yaml
   ```

4. **Test the Setup**: Use the provided curl commands in `test/curl-commands.sh` to verify the traffic routing and canary deployment functionality.

## Usage Details

- The application consists of two versions (`app-v1` and `app-v2`) using the `hashicorp/http-echo` image that respond with different messages ("Hello from App-V1" and "Hello from App-V2").
- The `cilium` gateway in the `default` namespace manages incoming traffic on port 30080 and routes it based on defined rules.
- Traffic routing includes:
  - **Default behavior**: 80% of traffic goes to `app-v1`, 20% to `app-v2`
  - **Canary deployment**: When `X-Canary: true` header is present, 100% of traffic goes to `app-v2`
  - **Echo service**: When `X-Echo: true` header is present, traffic is routed to the echo server with additional request headers
- The HTTPRoute adds response headers (`x-demo-header`) and can modify request headers for testing purposes.

## Testing

The `test/curl-commands.sh` script provides examples for:
- Testing the default traffic split (80/20 between v1 and v2)
- Testing canary header routing (commented out examples)
- Testing echo header routing (commented out examples)

To test the setup:

```bash
# Make the script executable
chmod +x test/curl-commands.sh

# Run the test script
./test/curl-commands.sh

# Or test manually with curl
curl -H "Host: demo.example.com" http://localhost:30080
curl -H "Host: demo.example.com" -H "X-Canary: true" http://localhost:30080
curl -H "Host: demo.example.com" -H "X-Echo: true" http://localhost:30080 | jq
```

## Components

### Deployments
- **app-v1**: Runs `hashicorp/http-echo` with message "Hello from App-V1"
- **app-v2**: Runs `hashicorp/http-echo` with message "Hello from App-V2"
- **echo-server**: Runs `ealen/echo-server:0.9.2` for request/response inspection

### Services
- **app-service-v1**: ClusterIP service for app-v1 deployment
- **app-service-v2**: ClusterIP service for app-v2 deployment  
- **echo-server**: ClusterIP service for echo-server pod

### Gateway API Resources
- **Gateway**: Named `cilium`, listens on port 30080, allows routes from all namespaces
- **HTTPRoute**: Named `demo-httproute`, defines traffic splitting and canary routing rules