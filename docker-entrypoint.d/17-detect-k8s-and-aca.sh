#!/bin/sh

RESOLV_CONF="/etc/resolv.conf"
export DOMAIN_SUFFIX=""

# Check if we're in a Kubernetes environment and set up environment variables
if [ -f "$RESOLV_CONF" ] && grep -q "cluster.local" "$RESOLV_CONF"; then
    # Extract the first search domain that includes cluster.local
    K8S_SEARCH_DOMAIN=$(grep "^search" "$RESOLV_CONF" | head -n1 | awk '{print $2}')

    export DOMAIN_SUFFIX=".${K8S_SEARCH_DOMAIN}"

fi

# Override domain suffix if running in Azure Container Apps
# Set HTTP protocol based on Azure Container Apps (ACA manages internal TLS)
if [ -n "$CONTAINER_APP_ENV_DNS_SUFFIX" ]; then
    export DOMAIN_SUFFIX=".internal.${CONTAINER_APP_ENV_DNS_SUFFIX}"
    export UPSTREAM_PROTOCOL="https"
else
    export UPSTREAM_PROTOCOL="http"
fi

#Monkey patch our dynamically determined env vars into our default template
envsubst '$DOMAIN_SUFFIX $UPSTREAM_PROTOCOL' < /etc/nginx/templates/default.conf.template > /tmp/default.conf.template.tmp
mv /tmp/default.conf.template.tmp /etc/nginx/templates/default.conf.template