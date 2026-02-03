# Advanced Configuration Guide

This guide covers advanced configuration options for the Actyze Dashboard Docker Compose deployment.

---

## Table of Contents

- [Environment Variables Reference](#environment-variables-reference)
- [Service Configuration](#service-configuration)
- [Network Configuration](#network-configuration)
- [Volume Management](#volume-management)
- [Resource Limits](#resource-limits)
- [Security Configuration](#security-configuration)
- [Performance Tuning](#performance-tuning)
- [External Integrations](#external-integrations)

---

## Environment Variables Reference

### Complete `.env` File Structure

```bash
# =============================================================================
# EXTERNAL LLM CONFIGURATION
# =============================================================================
# Provider API Key (required)
ANTHROPIC_API_KEY=your-api-key-here

# Provider Settings
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1

# =============================================================================
# DATABASE CONFIGURATION
# =============================================================================
# PostgreSQL Connection
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=dashboard
POSTGRES_USER=nexus_service
POSTGRES_PASSWORD=your-secure-password-here

# =============================================================================
# TRINO CONFIGURATION
# =============================================================================
# Trino Connection
TRINO_HOST=trino
TRINO_PORT=8080
TRINO_USER=admin
TRINO_PASSWORD=
TRINO_CATALOG=postgres
TRINO_SCHEMA=public
TRINO_SSL=false

# Include TPC-H sample data for testing
INCLUDE_TPCH=true

# =============================================================================
# EXTERNAL DATA SOURCES
# =============================================================================
# MongoDB Atlas
MONGODB_CONNECTION_URL=

# Snowflake Data Warehouse
SNOWFLAKE_CONNECTION_URL=
SNOWFLAKE_USER=
SNOWFLAKE_PASSWORD=

# =============================================================================
# SERVICE CONFIGURATION
# =============================================================================
# Nexus Service
NEXUS_PORT=8000
DEBUG=true
LOG_LEVEL=INFO

# Schema Service
SCHEMA_SERVICE_HOST=schema-service
SCHEMA_SERVICE_PORT=8000
SCHEMA_SERVICE_KEY=dev-secret-key-change-in-production

# =============================================================================
# CACHE CONFIGURATION
# =============================================================================
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=1800  # 30 minutes in seconds

# =============================================================================
# FRONTEND CONFIGURATION
# =============================================================================
REACT_APP_API_BASE_URL=/api  # Relative path - NGINX proxies to nexus
```

---

## Service Configuration

### Nexus Service (FastAPI Backend)

#### Environment Variables

```bash
# Service Port
NEXUS_PORT=8000

# Logging Configuration
LOG_LEVEL=DEBUG          # DEBUG, INFO, WARNING, ERROR, CRITICAL
DEBUG=true               # Enable debug mode

# Database Connection Pool
DB_POOL_SIZE=20          # Maximum connections
DB_MAX_OVERFLOW=0        # Additional connections beyond pool_size

# API Configuration
API_TITLE="Actyze Dashboard API"
API_VERSION="1.0.0"
API_DOCS_URL=/docs       # Swagger UI path
API_REDOC_URL=/redoc     # ReDoc path

# CORS Configuration
CORS_ORIGINS=*           # Comma-separated list of allowed origins
CORS_CREDENTIALS=true
CORS_METHODS=*
CORS_HEADERS=*
```

#### Resource Limits

```yaml
# In docker-compose.yml
nexus:
  deploy:
    resources:
      limits:
        cpus: '2.0'      # Maximum 2 CPU cores
        memory: 768M     # Maximum 768MB RAM
      reservations:
        cpus: '0.5'      # Minimum 0.5 CPU cores
        memory: 512M     # Minimum 512MB RAM
```

### Schema Service (FAISS)

#### Environment Variables

```bash
# Service Port
PORT=8000

# Model Configuration
MODEL_CACHE_DIR=/app/model_cache
MODEL_NAME=sentence-transformers/all-MiniLM-L6-v2

# FAISS Index Settings
FAISS_INDEX_TYPE=Flat    # Flat, IVF, HNSW
FAISS_NLIST=100          # For IVF indexes
FAISS_NPROBE=10          # For IVF searches

# Intent Examples
LOAD_INTENT_EXAMPLES=true
INTENT_EXAMPLES_TABLE=intent_examples

# Schema Exclusion
EXCLUDE_SCHEMAS=information_schema,pg_catalog,pg_toast
```

#### Resource Limits

```yaml
# In docker-compose.yml
schema-service:
  deploy:
    resources:
      limits:
        memory: 2G       # Hard limit for FAISS models
      reservations:
        memory: 1G       # Minimum for startup
```

### Frontend Service

#### Build Arguments

```yaml
# In docker-compose.yml
frontend:
  build:
    args:
      # API endpoint (relative for nginx proxy)
      REACT_APP_API_BASE_URL: /api
      
      # Build optimization
      NODE_ENV: production
      GENERATE_SOURCEMAP: false
```

#### Nginx Configuration

```nginx
# Custom nginx.conf location: ./frontend/nginx.conf
server {
    listen 80;
    
    # Frontend static files
    location / {
        root /usr/share/nginx/html;
        try_files $uri $uri/ /index.html;
    }
    
    # API proxy to Nexus
    location /api {
        proxy_pass http://nexus:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### PostgreSQL

#### Configuration

```bash
# PostgreSQL Server Settings
POSTGRES_HOST_AUTH_METHOD=md5    # or scram-sha-256, trust
POSTGRES_INITDB_ARGS=--encoding=UTF8 --locale=en_US.UTF-8

# Connection Limits
POSTGRES_MAX_CONNECTIONS=200

# Memory Settings
POSTGRES_SHARED_BUFFERS=256MB
POSTGRES_EFFECTIVE_CACHE_SIZE=1GB
POSTGRES_WORK_MEM=4MB
```

#### Custom postgresql.conf

```conf
# Create custom postgresql.conf and mount as volume
max_connections = 200
shared_buffers = 256MB
effective_cache_size = 1GB
maintenance_work_mem = 64MB
checkpoint_completion_target = 0.9
wal_buffers = 16MB
default_statistics_target = 100
random_page_cost = 1.1
effective_io_concurrency = 200
work_mem = 4MB
min_wal_size = 1GB
max_wal_size = 4GB
```

### Trino

#### Configuration Files

**config.properties**:
```properties
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
discovery.uri=http://localhost:8080

# Memory Configuration
query.max-memory=512MB
query.max-memory-per-node=256MB
query.max-total-memory-per-node=384MB

# Spill Configuration
spill-enabled=true
spill-order-by=true
spill-window-operator=true
```

**jvm.config**:
```
-server
-Xmx512M
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:+ExitOnOutOfMemoryError
```

#### Catalog Configuration

**postgres.properties**:
```properties
connector.name=postgresql
connection-url=jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}
connection-user=${POSTGRES_USER}
connection-password=${POSTGRES_PASSWORD}
```

**mongodb.properties**:
```properties
connector.name=mongodb
mongodb.connection-url=${MONGODB_CONNECTION_URL}
mongodb.read-preference=secondaryPreferred
```

**snowflake.properties**:
```properties
connector.name=snowflake
connection-url=${SNOWFLAKE_CONNECTION_URL}
connection-user=${SNOWFLAKE_USER}
connection-password=${SNOWFLAKE_PASSWORD}
```

---

## Network Configuration

### Default Network

```yaml
networks:
  dashboard:
    driver: bridge
    name: dashboard-local
```

### Custom Network

```yaml
networks:
  dashboard:
    driver: bridge
    name: dashboard-local
    ipam:
      driver: default
      config:
        - subnet: 172.28.0.0/16
          gateway: 172.28.0.1
```

### External Network

```yaml
# Use existing network
networks:
  dashboard:
    external: true
    name: existing-network
```

### Service Discovery

Services communicate using service names as hostnames:

```bash
# Nexus connects to PostgreSQL
POSTGRES_HOST=postgres  # resolves to postgres container

# Nexus connects to Schema Service
SCHEMA_SERVICE_HOST=schema-service  # resolves to schema-service container
```

---

## Volume Management

### Default Volumes

```yaml
volumes:
  postgres_data:
    driver: local
  schema_models:
    driver: local
```

### Named Volumes with Options

```yaml
volumes:
  postgres_data:
    driver: local
    driver_opts:
      type: none
      device: /path/to/custom/location
      o: bind
```

### External Volumes

```yaml
volumes:
  postgres_data:
    external: true
    name: existing-postgres-volume
```

### Backup and Restore

#### Backup Volumes

```bash
# Backup PostgreSQL data
docker run --rm \
  -v dashboard-docker_postgres_data:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/postgres-$(date +%Y%m%d).tar.gz /data

# Backup FAISS models
docker run --rm \
  -v dashboard-docker_schema_models:/data \
  -v $(pwd)/backups:/backup \
  alpine tar czf /backup/schema-models-$(date +%Y%m%d).tar.gz /data
```

#### Restore Volumes

```bash
# Restore PostgreSQL data
docker run --rm \
  -v dashboard-docker_postgres_data:/data \
  -v $(pwd)/backups:/backup \
  alpine sh -c "cd /data && tar xzf /backup/postgres-20260203.tar.gz --strip 1"
```

---

## Resource Limits

### Global Resource Configuration

```yaml
# docker-compose.yml
version: '3.8'

x-resource-defaults: &resource-defaults
  deploy:
    resources:
      limits:
        cpus: '1.0'
        memory: 512M
      reservations:
        cpus: '0.25'
        memory: 256M

services:
  nexus:
    <<: *resource-defaults
    # service config...
```

### Per-Service Limits

```yaml
services:
  nexus:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 768M
        reservations:
          cpus: '0.5'
          memory: 512M
  
  postgres:
    deploy:
      resources:
        limits:
          cpus: '2.0'
          memory: 1G
        reservations:
          cpus: '0.5'
          memory: 512M
```

### System-Wide Limits

```bash
# Check Docker daemon limits
docker info | grep -E "CPUs|Total Memory"

# Set limits in Docker Desktop
# Preferences → Resources → Advanced
# - CPUs: 4+
# - Memory: 8GB+
# - Swap: 2GB+
# - Disk: 20GB+
```

---

## Security Configuration

### Environment Variable Security

```bash
# Use Docker secrets instead of plain .env
docker secret create postgres_password /path/to/password.txt

# Reference in docker-compose.yml
services:
  postgres:
    secrets:
      - postgres_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/postgres_password

secrets:
  postgres_password:
    external: true
```

### Network Security

```yaml
# Internal network with no external access
networks:
  backend:
    driver: bridge
    internal: true  # No external connectivity
  
  frontend:
    driver: bridge

services:
  postgres:
    networks:
      - backend  # Only accessible from other services
  
  nexus:
    networks:
      - backend
      - frontend
  
  frontend:
    networks:
      - frontend
```

### Container Security

```yaml
services:
  nexus:
    # Run as non-root user
    user: "1000:1000"
    
    # Read-only root filesystem
    read_only: true
    tmpfs:
      - /tmp
      - /app/temp
    
    # Drop capabilities
    cap_drop:
      - ALL
    cap_add:
      - NET_BIND_SERVICE
    
    # Security options
    security_opt:
      - no-new-privileges:true
```

### SSL/TLS Configuration

```yaml
services:
  postgres:
    environment:
      POSTGRES_SSL_MODE=require
    volumes:
      - ./certs/server.crt:/var/lib/postgresql/server.crt:ro
      - ./certs/server.key:/var/lib/postgresql/server.key:ro
```

---

## Performance Tuning

### Database Optimization

```sql
-- PostgreSQL optimization
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET work_mem = '4MB';
ALTER SYSTEM SET max_connections = 200;

-- Vacuum and analyze
VACUUM ANALYZE;

-- Create indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_queries_created_at ON queries(created_at DESC);
```

### Caching Strategy

```bash
# Enable query caching
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=1800

# Enable result caching
RESULT_CACHE_ENABLED=true
RESULT_CACHE_MAX_SIZE=50
RESULT_CACHE_TTL=3600
```

### Connection Pooling

```python
# Nexus database configuration
DB_POOL_SIZE=20          # Number of persistent connections
DB_MAX_OVERFLOW=10       # Additional connections when needed
DB_POOL_TIMEOUT=30       # Timeout for getting connection
DB_POOL_RECYCLE=3600     # Recycle connections after 1 hour
```

### LLM Request Optimization

```bash
# Reduce token usage
EXTERNAL_LLM_MAX_TOKENS=2000  # Lower for simple queries

# Increase temperature for variety
EXTERNAL_LLM_TEMPERATURE=0.2  # Higher = more creative

# Use cheaper models for simple queries
EXTERNAL_LLM_MODEL=gpt-3.5-turbo  # vs gpt-4
```

---

## External Integrations

### MongoDB Atlas

```bash
# Connection string format
MONGODB_CONNECTION_URL=mongodb+srv://username:password@cluster.mongodb.net/dbname?retryWrites=true&w=majority

# Additional options
MONGODB_READ_PREFERENCE=secondaryPreferred
MONGODB_MAX_POOL_SIZE=50
MONGODB_MIN_POOL_SIZE=10
```

### Snowflake

```bash
# Connection string
SNOWFLAKE_CONNECTION_URL=jdbc:snowflake://account.snowflakecomputing.com/?warehouse=COMPUTE_WH&db=PROD_DB&role=ANALYST

# Credentials
SNOWFLAKE_USER=your-username
SNOWFLAKE_PASSWORD=your-password

# Additional settings
SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_DATABASE=PROD_DB
SNOWFLAKE_SCHEMA=PUBLIC
SNOWFLAKE_ROLE=ANALYST
```

### AWS S3 (for data sources)

```bash
# S3 credentials for Trino
AWS_ACCESS_KEY_ID=your-access-key
AWS_SECRET_ACCESS_KEY=your-secret-key
AWS_REGION=us-east-1
S3_ENDPOINT=https://s3.amazonaws.com
```

### Redis (optional caching)

```yaml
services:
  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    command: redis-server --appendonly yes

volumes:
  redis_data:
```

```bash
# Nexus Redis configuration
REDIS_HOST=redis
REDIS_PORT=6379
REDIS_DB=0
REDIS_PASSWORD=
USE_REDIS_CACHE=true
```

---

## Monitoring and Logging

### Log Configuration

```yaml
services:
  nexus:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### Health Checks

```yaml
services:
  nexus:
    healthcheck:
      test: ["CMD-SHELL", "curl -f http://localhost:8000/health || exit 1"]
      interval: 30s
      timeout: 10s
      retries: 5
      start_period: 60s
```

### Prometheus Metrics (Optional)

```yaml
services:
  prometheus:
    image: prom/prometheus:latest
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus_data:/prometheus
```

---

## Troubleshooting

### Debug Mode

```bash
# Enable verbose logging
LOG_LEVEL=DEBUG
DEBUG=true

# View detailed logs
docker-compose logs -f --tail=100 nexus
```

### Performance Profiling

```bash
# Monitor resource usage
docker stats

# CPU profiling
docker exec nexus py-spy top --pid 1

# Memory profiling
docker exec nexus py-spy dump --pid 1
```

---

For more information, see:
- [README.md](./README.md) - Getting started
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment guide
- [LLM_PROVIDERS.md](./LLM_PROVIDERS.md) - LLM configuration
