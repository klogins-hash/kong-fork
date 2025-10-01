# Use the official Kong image with OpenResty included
FROM kong:3.8.0

# Set working directory
WORKDIR /kong

# Copy Kong configuration
COPY kong.conf /etc/kong/kong.conf

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

# Create startup script
RUN echo '#!/bin/sh\n\
echo "Waiting for database..."\n\
until kong migrations list 2>/dev/null; do\n\
  echo "Database not ready, waiting..."\n\
  sleep 2\n\
done\n\
echo "Running migrations..."\n\
kong migrations bootstrap || kong migrations up\n\
echo "Starting Kong..."\n\
exec kong start --run-migrations' > /usr/local/bin/start-kong.sh && \
    chmod +x /usr/local/bin/start-kong.sh

# Start Kong
CMD ["/usr/local/bin/start-kong.sh"]
