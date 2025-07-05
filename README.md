# Nginx Dynamic Runtime Hostnames

A minimal example of dynamic nginx upstream configuration via environment variables working across Docker Compose, Kubernetes, and Azure Container Apps.

See [blog post](https://www.alexdarbyshire.com/2025/07/nginx-dynamic-hostnames-docker-k8s-aca/) for more details.

## Architecture

Custom nginx container which detects runtime environment and configures upstream hostnames:

- **Docker Compose**: Direct container names (`my-rg-local-frontend`, `my-rg-local-api`)
- **Kubernetes**: Service discovery with cluster domain (`my-rg-local-frontend.default.svc.cluster.local`)
- **Azure Container Apps**: Internal DNS with environment suffix (`my-rg-local-frontend.internal.{env-suffix}`)

## Components

- [`Dockerfile`](Dockerfile): Custom nginx image with environment detection
- [`docker-entrypoint.d/17-detect-k8s-and-aca.sh`](docker-entrypoint.d/17-detect-k8s-and-aca.sh): Runtime environment detection script
- [`templates/default.conf.template`](templates/default.conf.template): Dynamic nginx configuration template
- [`docker-compose.yml`](docker-compose.yml): Local development setup
- [`k8s/`](k8s/): Kubernetes manifests for cluster deployment
- [`Tiltfile`](Tiltfile): Development workflow automation

## Quick Start

### Docker Compose
```bash
docker compose up
```
Access: http://localhost

### Kubernetes
```bash
# Install KIND
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.29.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# Create cluster and deploy
kind create cluster
tilt up
```
Access: http://localhost:8080

### Azure Container Apps
Batteries not included for ACA deployment. To see it in action deploy a container app environment with three containers matching the examples.

## Requirements

- **Docker**: Engine with Compose support
- **Kubernetes**: KIND, minikube, or any cluster
- **Tilt**: Development workflow tool ([install](https://docs.tilt.dev/install.html))

## How It Works

1. **Environment Detection**: The entrypoint script [`17-detect-k8s-and-aca.sh`](docker-entrypoint.d/17-detect-k8s-and-aca.sh) examines `/etc/resolv.conf` and environment variables
2. **Dynamic Configuration**: Sets `DOMAIN_SUFFIX` and `UPSTREAM_PROTOCOL` based on detected environment
3. **Template Processing**: nginx processes the template with environment-specific values
4. **Service Discovery**: nginx resolves upstreams using the appropriate naming convention

## License

This project is licensed under the MIT License - see the [`LICENSE`](LICENSE) file for details.