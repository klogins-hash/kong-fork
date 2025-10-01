# Kong Gateway - Railway Deployment

This repository contains Kong Gateway configured for deployment on Railway.

## Prerequisites

1. **Railway Account**: Sign up at [railway.app](https://railway.app)
2. **PostgreSQL Database**: Kong requires a PostgreSQL database

## Deployment Steps

### 1. Deploy to Railway

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/template/new)

Or manually:

1. Fork this repository
2. Connect your Railway account to GitHub
3. Create a new Railway project from this repository

### 2. Add PostgreSQL Database

1. In your Railway project dashboard, click "Add Service"
2. Select "Database" → "PostgreSQL"
3. Railway will automatically create the database and set environment variables

### 3. Environment Variables

Railway will automatically set these PostgreSQL variables:
- `PGHOST`
- `PGPORT` 
- `PGUSER`
- `PGPASSWORD`
- `PGDATABASE`

Additional variables you may want to configure:
- `KONG_LOG_LEVEL` (default: info)
- `KONG_PLUGINS` (default: bundled)

### 4. Access Your Kong Gateway

After deployment:
- **Proxy Port**: `https://your-app.railway.app` (port 8000)
- **Admin API**: `https://your-app.railway.app:8001` (port 8001)

## Configuration

- `Dockerfile`: Container configuration
- `kong.conf`: Kong-specific configuration
- `railway.toml` / `railway.json`: Railway deployment configuration

## Health Checks

Kong includes built-in health checks at `/status` endpoint.

## Scaling

Railway automatically handles scaling based on your plan. Kong is designed to be stateless and scales horizontally.

## Troubleshooting

1. **Database Connection Issues**: Ensure PostgreSQL service is running and environment variables are set
2. **Migration Issues**: Check logs for database migration errors
3. **Port Issues**: Railway automatically assigns ports, ensure Kong is listening on 0.0.0.0

## Logs

View logs in Railway dashboard or use Railway CLI:
```bash
railway logs
```

## Local Development

To run locally with Docker:
```bash
docker build -t kong-railway .
docker run -p 8000:8000 -p 8001:8001 kong-railway
```

## Support

- [Kong Documentation](https://docs.konghq.com)
- [Railway Documentation](https://docs.railway.app)
- [Kong Community](https://github.com/Kong/kong/discussions)
