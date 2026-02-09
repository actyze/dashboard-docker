# Actyze Configuration Guide

Complete configuration reference for Actyze Docker Compose deployment.

---

## Quick Configuration

The \`.env\` file controls all Actyze settings. Copy from template:

\`\`\`bash
cp env.example .env
nano .env
\`\`\`

---

## Required Configuration

### LLM Provider

**Required** - Configure your AI provider:

\`\`\`bash
# API Key
ANTHROPIC_API_KEY=your-api-key-here

# Provider Settings
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
\`\`\`

See [LLM_PROVIDERS.md](LLM_PROVIDERS.md) for all providers.

### Database Password

**Required** - Set a secure password:

\`\`\`bash
POSTGRES_PASSWORD=your-secure-password-here
\`\`\`

---

## Database Configuration

### Local PostgreSQL (Default)

Uses included PostgreSQL database:

\`\`\`bash
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=dashboard
POSTGRES_USER=nexus_service
POSTGRES_PASSWORD=your-password
\`\`\`

### External PostgreSQL

Connect to your existing PostgreSQL:

\`\`\`bash
POSTGRES_HOST=db.yourcompany.com
POSTGRES_PORT=5432
POSTGRES_DB=your-database
POSTGRES_USER=your-username
POSTGRES_PASSWORD=your-password
\`\`\`

---

## Trino Configuration

### Local Trino (Default)

Uses included Trino engine:

\`\`\`bash
TRINO_HOST=trino
TRINO_PORT=8080
TRINO_USER=admin
TRINO_PASSWORD=
TRINO_CATALOG=postgres
TRINO_SCHEMA=public
TRINO_SSL=false
\`\`\`

### External Trino

Connect to your existing Trino cluster:

\`\`\`bash
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_USER=your-username
TRINO_PASSWORD=your-password
TRINO_CATALOG=your-catalog
TRINO_SCHEMA=your-schema
TRINO_SSL=true
\`\`\`

### Trino Connectors

Configure Trino to connect to your data sources. See [trino/README.md](trino/README.md) for:
- PostgreSQL, MySQL, SQL Server
- Snowflake, BigQuery, Redshift
- MongoDB, Cassandra
- And 50+ more connectors

---

## Performance Configuration

### Query Caching

Enable caching to improve performance:

\`\`\`bash
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100      # Cache up to 100 queries
CACHE_QUERY_TTL=1800           # Cache for 30 minutes (seconds)
\`\`\`

### Logging

Control log output:

\`\`\`bash
LOG_LEVEL=INFO  # Options: DEBUG, INFO, WARNING, ERROR
DEBUG=false     # Set to true for detailed debugging logs
\`\`\`

---

## Service Configuration

### Nexus API

\`\`\`bash
NEXUS_PORT=8000
NEXUS_HOST=0.0.0.0
\`\`\`

### Frontend

\`\`\`bash
FRONTEND_PORT=3000
REACT_APP_API_BASE_URL=/api  # NGINX proxies to Nexus
\`\`\`

### Schema Service

\`\`\`bash
SCHEMA_SERVICE_HOST=schema-service
SCHEMA_SERVICE_PORT=8001
SCHEMA_SERVICE_KEY=dev-secret-key-change-in-production
\`\`\`

---

## Network Configuration

### Default Ports

| Service | Port | URL |
|---------|------|-----|
| Frontend | 3000 | http://localhost:3000 |
| Nexus API | 8000 | http://localhost:8000 |
| Schema Service | 8001 | http://localhost:8001 |
| PostgreSQL | 5432 | postgres://localhost:5432 |
| Trino | 8081 | http://localhost:8081 |

### Custom Ports

To change ports, edit \`docker-compose.yml\`:

\`\`\`yaml
services:
  frontend:
    ports:
      - "8080:3000"  # Change 8080 to your desired port
\`\`\`

---

## Security Configuration

### Change Default Credentials

1. **Login** with \`nexus_admin\` / \`admin\`
2. **Go to Settings** → Account
3. **Change password** immediately

### Secure API Keys

- Never commit \`.env\` to version control
- Use strong, unique passwords
- Rotate API keys regularly

### Schema Service Key

Change the default key:

\`\`\`bash
SCHEMA_SERVICE_KEY=your-random-secure-key-here
\`\`\`

---

## Advanced Configuration

### LLM Provider Options

\`\`\`bash
# Provider Configuration
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}

# Response Configuration
EXTERNAL_LLM_MAX_TOKENS=4096       # Maximum response length
EXTERNAL_LLM_TEMPERATURE=0.1        # Response creativity (0-1)
EXTERNAL_LLM_TIMEOUT=60             # Request timeout (seconds)
\`\`\`

### Database Connection Pooling

\`\`\`bash
# Connection pool settings (advanced)
DB_POOL_SIZE=20
DB_MAX_OVERFLOW=10
DB_POOL_TIMEOUT=30
DB_POOL_RECYCLE=3600
\`\`\`

### CORS Configuration

\`\`\`bash
# Allow specific origins (comma-separated)
CORS_ORIGINS=http://localhost:3000,https://yourapp.com

# Or allow all (development only)
CORS_ORIGINS=*
\`\`\`

---

## Sample Data Configuration

### TPC-H Sample Data

Include TPC-H benchmark data for testing:

\`\`\`bash
INCLUDE_TPCH=true  # Set to false to disable
\`\`\`

---

## Environment Variables Reference

### Complete `.env` Template

\`\`\`bash
# =============================================================================
# REQUIRED: LLM CONFIGURATION
# =============================================================================
ANTHROPIC_API_KEY=your-api-key-here
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
EXTERNAL_LLM_TIMEOUT=60

# =============================================================================
# REQUIRED: DATABASE CONFIGURATION
# =============================================================================
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=dashboard
POSTGRES_USER=nexus_service
POSTGRES_PASSWORD=your-secure-password-here

# =============================================================================
# TRINO CONFIGURATION
# =============================================================================
TRINO_HOST=trino
TRINO_PORT=8080
TRINO_USER=admin
TRINO_PASSWORD=
TRINO_CATALOG=postgres
TRINO_SCHEMA=public
TRINO_SSL=false

# =============================================================================
# PERFORMANCE CONFIGURATION
# =============================================================================
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=1800
LOG_LEVEL=INFO
DEBUG=false

# =============================================================================
# SERVICE CONFIGURATION
# =============================================================================
NEXUS_PORT=8000
FRONTEND_PORT=3000
SCHEMA_SERVICE_HOST=schema-service
SCHEMA_SERVICE_PORT=8001
SCHEMA_SERVICE_KEY=dev-secret-key-change-in-production

# =============================================================================
# OPTIONAL: SAMPLE DATA
# =============================================================================
INCLUDE_TPCH=true
\`\`\`

---

## Configuration by Use Case

### Evaluation/Testing

Use defaults with minimal changes:

\`\`\`bash
# Only set these:
ANTHROPIC_API_KEY=your-key
POSTGRES_PASSWORD=secure-password
\`\`\`

### Connect to Your Production Database

\`\`\`bash
# Use external Trino
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_USER=analytics_user
TRINO_PASSWORD=your-password
TRINO_SSL=true

# Keep local PostgreSQL for app data
POSTGRES_HOST=postgres
\`\`\`

### High Performance Setup

\`\`\`bash
# Enable caching
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=200
CACHE_QUERY_TTL=3600

# Use fast LLM
EXTERNAL_LLM_PROVIDER=groq
EXTERNAL_LLM_MODEL=mixtral-8x7b-32768

# Reduce logging
LOG_LEVEL=WARNING
DEBUG=false
\`\`\`

### Development/Debugging

\`\`\`bash
# Enable detailed logging
LOG_LEVEL=DEBUG
DEBUG=true

# Disable caching for testing
CACHE_ENABLED=false
\`\`\`

---

## Applying Configuration Changes

### Update Configuration

1. **Edit \`.env\`:**
   \`\`\`bash
   nano .env
   \`\`\`

2. **Restart Actyze:**
   \`\`\`bash
   ./stop.sh && ./start.sh
   \`\`\`

### Verify Configuration

\`\`\`bash
# Check environment variables
cat .env | grep YOUR_SETTING

# Check service logs
docker-compose logs nexus
docker-compose logs frontend
\`\`\`

---

## Troubleshooting

### Configuration Not Applied

**Solution:**
\`\`\`bash
# Restart services completely
./stop.sh
./start.sh

# Or force recreate
docker-compose up -d --force-recreate
\`\`\`

### Invalid Configuration

**Check logs:**
\`\`\`bash
docker-compose logs nexus | grep -i error
docker-compose logs frontend | grep -i error
\`\`\`

### Environment Variable Not Working

**Verify format:**
- No spaces around \`=\`
- Use quotes for values with spaces: \`KEY="value with spaces"\`
- Escape special characters

**Test:**
\`\`\`bash
# Check if variable is set
docker-compose config | grep YOUR_VARIABLE
\`\`\`

---

## Support

**Documentation:**
- Quick Start: [QUICK_START.md](QUICK_START.md)
- Deployment Guide: [DEPLOYMENT.md](DEPLOYMENT.md)
- LLM Providers: [LLM_PROVIDERS.md](LLM_PROVIDERS.md)
- Trino Connectors: [trino/README.md](trino/README.md)
- Complete Documentation: https://docs.actyze.io

**Support:**
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues
- Documentation Site: https://docs.actyze.io

---

**Configure Actyze your way. Connect to any data source. Use any LLM.**
