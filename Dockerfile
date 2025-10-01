# Use the official Kong image as base
FROM kong:3.8.0-ubuntu

# Set working directory
WORKDIR /kong

# Copy Kong configuration
COPY kong.conf.default /etc/kong/kong.conf

# Copy custom plugins if any
COPY kong/ /usr/local/share/lua/5.1/kong/

# Set environment variables for Railway deployment
ENV KONG_DATABASE=postgres
ENV KONG_PG_HOST=$PGHOST
ENV KONG_PG_PORT=$PGPORT
ENV KONG_PG_USER=$PGUSER
ENV KONG_PG_PASSWORD=$PGPASSWORD
ENV KONG_PG_DATABASE=$PGDATABASE
ENV KONG_PROXY_ACCESS_LOG=/dev/stdout
ENV KONG_ADMIN_ACCESS_LOG=/dev/stdout
ENV KONG_PROXY_ERROR_LOG=/dev/stderr
ENV KONG_ADMIN_ERROR_LOG=/dev/stderr
ENV KONG_ADMIN_LISTEN=0.0.0.0:8001
ENV KONG_PROXY_LISTEN=0.0.0.0:8000

# Expose ports
EXPOSE 8000 8001 8443 8444

# Health check
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 \
  CMD kong health

# Start Kong
CMD ["sh", "-c", "kong migrations bootstrap && kong start --run-migrations"]
