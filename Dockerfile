FROM nginx:alpine

COPY ./templates/default.conf.template /etc/nginx/templates/
COPY ./docker-entrypoint.d/17-detect-k8s-and-aca.sh /docker-entrypoint.d/

# Enable local DNS resolver (makes DNS IP from resolv.conf available as env var)
ENV NGINX_ENTRYPOINT_LOCAL_RESOLVERS=1

# Document our intended local port
EXPOSE 80