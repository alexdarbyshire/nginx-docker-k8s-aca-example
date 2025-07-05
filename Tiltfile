# Build the custom nginx image
docker_build('nginx-example:latest', '.')

# Deploy all Kubernetes resources
k8s_yaml(['k8s/nginx-deployment.yaml', 'k8s/frontend-deployment.yaml', 'k8s/api-deployment.yaml'])

# Create port forwards
k8s_resource('nginx', port_forwards='8080:80')