# Actyze Dashboard - Docker Compose Setup

**Build and test Actyze Dashboard locally with Docker Compose**

This repository provides a production-ready Docker Compose environment for running the Actyze Dashboard platform on your local machine. Perfect for development, testing, and evaluation purposes.

---

## 🚀 Quick Start

Get up and running in under 5 minutes:

```bash
# 1. Clone the repository
git clone https://github.com/roman1887/dashboard-docker.git
cd dashboard-docker

# 2. Configure environment
cp env.example .env
# Edit .env with your API keys

# 3. Start the platform
./start.sh

# 4. Access the dashboard
open http://localhost:3000
```

**Default credentials**: `nexus_admin` / `admin`

---

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Architecture](#architecture)
- [Installation](#installation)
- [Configuration](#configuration)
- [Usage](#usage)
- [LLM Providers](#llm-providers)
- [Deployment Profiles](#deployment-profiles)
- [Troubleshooting](#troubleshooting)
- [Development Workflow](#development-workflow)
- [Production Deployment](#production-deployment)

---

## 🎯 Overview

Actyze Dashboard is an AI-powered natural language to SQL platform that enables users to query databases using plain English. This Docker Compose setup provides:

- **Full local environment** with all services
- **Flexible database options** (local or external PostgreSQL/Trino)
- **Multiple LLM provider support** (Anthropic, OpenAI, Perplexity, Groq, and more)
- **Production-like architecture** that mirrors Kubernetes deployment
- **Easy development workflow** with hot reloading

### Key Features

✅ Natural language to SQL conversion using LLMs  
✅ FAISS-based intelligent schema recommendations  
✅ Support for multiple data sources (PostgreSQL, MongoDB, Snowflake)  
✅ Built-in query caching for performance  
✅ Complete REST API with GraphQL support  
✅ Modern React frontend with Material-UI  
✅ Production-ready with health checks and monitoring  

---

## 📦 Prerequisites

Before you begin, ensure you have:

- **Docker Desktop** 20.10+ or Docker Engine 20.10+
- **Docker Compose** 2.0+ (or docker-compose 1.29+)
- **8GB+ RAM** available for Docker
- **10GB+ disk space** for images and data
- **Internet connection** for pulling images and external services
- **LLM API Key** (Anthropic, OpenAI, Perplexity, or others)

### System Requirements

| Component | Minimum | Recommended |
|-----------|---------|-------------|
| CPU | 4 cores | 8+ cores |
| RAM | 8 GB | 16+ GB |
| Disk | 10 GB | 20+ GB |
| Docker Memory | 6 GB | 8+ GB |

### Verify Installation

```bash
# Check Docker version
docker --version
# Docker version 20.10.0 or higher

# Check Docker Compose version
docker-compose --version
# Docker Compose version 2.0.0 or higher

# Check available resources
docker info | grep -E "CPUs|Total Memory"
```

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Actyze Dashboard                          │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────┐     ┌──────────────────┐     ┌─────────────────┐
│   Frontend      │────▶│   Nexus API      │────▶│   PostgreSQL    │
│   (React:3000)  │     │   (FastAPI:8000) │     │   (5432)        │
└─────────────────┘     └──────────────────┘     └─────────────────┘
                               │
                               │
                      ┌────────┴────────┐
                      ▼                 ▼
            ┌──────────────────┐  ┌──────────────────┐
            │  Schema Service  │  │  Trino Engine    │
            │  (FAISS:8001)    │  │  (8081)          │
            └──────────────────┘  └──────────────────┘
                      │
                      ▼
            ┌──────────────────┐
            │  External LLM    │
            │  (Anthropic/etc) │
            └──────────────────┘
```

### Services Overview

| Service | Port | Description | Required |
|---------|------|-------------|----------|
| **Frontend** | 3000 | React UI with nginx | Yes |
| **Nexus** | 8000 | FastAPI backend, main orchestrator | Yes |
| **PostgreSQL** | 5432 | Application database | Yes* |
| **Schema Service** | 8001 | FAISS-based table recommendations | Yes |
| **Trino** | 8081 | Distributed SQL query engine | Yes* |

*Can use external services with appropriate profiles

---

## 📥 Installation

### Step 1: Clone Repository

```bash
git clone https://github.com/roman1887/dashboard-docker.git
cd dashboard-docker
```

### Step 2: Configure Environment

```bash
# Copy environment template
cp env.example .env

# Edit configuration (required)
nano .env  # or vim, code, etc.
```

**Minimum required configuration:**

```bash
# LLM API Key (required for SQL generation)
ANTHROPIC_API_KEY=your-api-key-here

# Database password (required)
POSTGRES_PASSWORD=your-secure-password
```

See [Configuration](#configuration) section for detailed options.

### Step 3: Start Services

```bash
# Start all services (builds images locally)
./start.sh

# Or start without building (uses existing images)
./start.sh --no-build

# Or start and follow logs
./start.sh --logs
```

### Step 4: Verify Installation

```bash
# Check service status
docker-compose ps

# All services should show "healthy" status
# ✓ dashboard-frontend     Up (healthy)
# ✓ dashboard-nexus        Up (healthy)
# ✓ dashboard-postgres     Up (healthy)
# ✓ dashboard-schema       Up (healthy)
# ✓ dashboard-trino        Up (healthy)
```

### Step 5: Access Dashboard

Open your browser to:

- **Dashboard UI**: http://localhost:3000
- **API Documentation**: http://localhost:8000/docs
- **Schema Service**: http://localhost:8001/health

**Login credentials**:
- Username: `nexus_admin`
- Password: `admin`

---

## ⚙️ Configuration

### Environment Variables

The `.env` file controls all aspects of the deployment. Key sections:

#### 1. LLM Configuration (Required)

```bash
# API Key - used by all providers
ANTHROPIC_API_KEY=your-api-key-here

# Provider Selection
EXTERNAL_LLM_PROVIDER=anthropic              # or openai, perplexity, groq
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_AUTH_TYPE=x-api-key             # or bearer, api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
```

See [LLM_PROVIDERS.md](./LLM_PROVIDERS.md) for provider-specific configuration.

#### 2. Database Configuration

```bash
# Local PostgreSQL (default)
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_DB=dashboard
POSTGRES_USER=nexus_service
POSTGRES_PASSWORD=your-secure-password

# For external PostgreSQL (optional)
# POSTGRES_HOST=your-external-host
# POSTGRES_PORT=5432
```

#### 3. Trino Configuration

```bash
# Local Trino (default)
TRINO_HOST=trino
TRINO_PORT=8080
TRINO_USER=admin
TRINO_PASSWORD=
TRINO_CATALOG=postgres
TRINO_SCHEMA=public
TRINO_SSL=false

# For external Trino (optional)
# TRINO_HOST=your-trino-host
# TRINO_PORT=443
# TRINO_SSL=true
```

#### 4. External Data Sources (Optional)

```bash
# MongoDB Atlas
MONGODB_CONNECTION_URL=mongodb+srv://user:pass@cluster.mongodb.net/

# Snowflake Data Warehouse
SNOWFLAKE_CONNECTION_URL=jdbc:snowflake://account.snowflakecomputing.com/
SNOWFLAKE_USER=your-username
SNOWFLAKE_PASSWORD=your-password
```

#### 5. Service Configuration

```bash
# Development mode
DEBUG=true
LOG_LEVEL=INFO

# Schema Service Authentication
SCHEMA_SERVICE_KEY=dev-secret-key-change-in-production

# Query caching
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=1800  # 30 minutes
```

### Configuration Files

| File | Purpose |
|------|---------|
| `env.example` | Template for `.env` configuration |
| `docker-compose.yml` | Main service definitions |
| `trino/` | Trino configuration and catalogs |

---

## 🎮 Usage

### Basic Commands

```bash
# Start services
./start.sh

# Stop services (preserve data)
./stop.sh

# Stop and remove all data
./stop.sh --clean

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f nexus

# Check service status
docker-compose ps

# Restart services
./stop.sh && ./start.sh
```

### Service Management

```bash
# Restart a specific service
docker-compose restart nexus

# Rebuild a service
docker-compose up -d --build nexus

# Scale a service (if supported)
docker-compose up -d --scale nexus=2

# Execute commands in a container
docker-compose exec nexus bash
docker-compose exec postgres psql -U nexus_service -d dashboard
```

### Testing the Platform

#### 1. Test via UI

1. Open http://localhost:3000
2. Login with `nexus_admin` / `admin`
3. Navigate to "Query" tab
4. Enter natural language query: "show me all customers"
5. Click "Generate SQL" and "Execute"

#### 2. Test via API

```bash
# Get authentication token
TOKEN=$(curl -s -X POST http://localhost:8000/auth/login \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=nexus_admin&password=admin" | jq -r '.access_token')

# Generate SQL from natural language
curl -X POST http://localhost:8000/api/generate-sql \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "nl_query": "show me total sales by region",
    "use_external_llm": true
  }' | jq .

# Execute generated SQL
curl -X POST http://localhost:8000/api/execute-query \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $TOKEN" \
  -d '{
    "query": "SELECT region, SUM(amount) FROM sales GROUP BY region"
  }' | jq .
```

#### 3. Test Schema Service

```bash
# Health check
curl http://localhost:8001/health | jq .

# Get table recommendations
curl -X POST http://localhost:8001/recommend \
  -H "Content-Type: application/json" \
  -d '{
    "query": "customer information"
  }' | jq .
```

---

## 🤖 LLM Providers

Actyze Dashboard supports **any LLM provider** with flexible authentication. See [LLM_PROVIDERS.md](./LLM_PROVIDERS.md) for detailed configuration.

### Supported Providers

| Provider | Auth Type | Best For | Cost |
|----------|-----------|----------|------|
| **Anthropic Claude** | `x-api-key` | SQL generation, reasoning | $$ |
| **OpenAI GPT-4** | `bearer` | General purpose | $$ |
| **Perplexity** | `bearer` | Fast responses | $ |
| **Groq** | `bearer` | Ultra-fast, open-source | Free tier |
| **Together AI** | `bearer` | Model variety | $ |
| **Azure OpenAI** | `api-key` | Enterprise | $$$ |
| **Custom** | configurable | Any OpenAI-compatible | - |

### Quick Configuration Examples

#### Anthropic Claude (Recommended)

```bash
ANTHROPIC_API_KEY=sk-ant-xxxxx
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
```

#### OpenAI

```bash
ANTHROPIC_API_KEY=sk-xxxxx  # Yes, same variable name
EXTERNAL_LLM_PROVIDER=openai
EXTERNAL_LLM_BASE_URL=https://api.openai.com/v1/chat/completions
EXTERNAL_LLM_MODEL=gpt-4o
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
```

#### Perplexity

```bash
ANTHROPIC_API_KEY=pplx-xxxxx  # Yes, same variable name
EXTERNAL_LLM_PROVIDER=perplexity
EXTERNAL_LLM_BASE_URL=https://api.perplexity.ai/chat/completions
EXTERNAL_LLM_MODEL=sonar-reasoning-pro
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
```

---

## 🔧 Deployment Profiles

Docker Compose profiles let you choose which services to run.

### Profile: `local` (Default)

**Services**: PostgreSQL + Trino + Schema Service + Nexus + Frontend

**Use case**: Full local development with all services

```bash
./start.sh --profile local
# or simply
./start.sh
```

### Profile: `external`

**Services**: Schema Service + Nexus + Frontend (no databases)

**Use case**: Use external PostgreSQL and Trino

```bash
# Configure external databases in .env
POSTGRES_HOST=your-external-postgres.com
TRINO_HOST=your-external-trino.com
TRINO_SSL=true

# Start with external profile
./start.sh --profile external
```

### Profile: `postgres-only`

**Services**: Local PostgreSQL + Schema Service + Nexus + Frontend (no Trino)

**Use case**: Local PostgreSQL with external Trino

```bash
./start.sh --profile postgres-only
```

### Profile: `trino-only`

**Services**: Local Trino + Schema Service + Nexus + Frontend (no PostgreSQL)

**Use case**: External PostgreSQL with local Trino

```bash
./start.sh --profile trino-only
```

### Custom Combinations

```bash
# Start only specific services
docker-compose up -d postgres nexus frontend

# Start with multiple profiles
docker-compose --profile local --profile trino-only up -d
```

---

## 🔍 Troubleshooting

### Common Issues

#### 1. Port Already in Use

**Error**: `Bind for 0.0.0.0:3000 failed: port is already allocated`

**Solution**:
```bash
# Find what's using the port
lsof -i :3000

# Stop the conflicting service or change port in docker-compose.yml
# Then restart
./stop.sh && ./start.sh
```

#### 2. Services Not Starting

**Error**: Container exits immediately or won't start

**Solution**:
```bash
# Check logs for specific service
docker-compose logs nexus

# Common causes:
# - Missing environment variables in .env
# - Insufficient Docker memory
# - Port conflicts
# - Missing dependencies

# Try clean restart
./stop.sh --clean
./start.sh
```

#### 3. Database Connection Failed

**Error**: `FATAL: password authentication failed for user "nexus_service"`

**Solution**:
```bash
# Verify .env configuration
cat .env | grep POSTGRES

# Reset database
./stop.sh --clean
./start.sh

# Check database logs
docker-compose logs postgres
```

#### 4. LLM API Errors

**Error**: `401 Unauthorized` or `No response from LLM API`

**Solution**:
```bash
# Verify API key in .env
cat .env | grep API_KEY

# Check provider configuration
docker-compose logs nexus | grep -i llm

# Test API key directly
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: $ANTHROPIC_API_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
```

#### 5. Out of Memory

**Error**: Services crash or system becomes unresponsive

**Solution**:
```bash
# Check Docker memory allocation
docker info | grep "Total Memory"

# Increase Docker Desktop memory limit to 8GB+
# Docker Desktop → Preferences → Resources → Memory

# Or reduce service memory limits in docker-compose.yml
```

#### 6. Slow Performance

**Solution**:
```bash
# Check resource usage
docker stats

# Enable caching
CACHE_ENABLED=true  # in .env

# Use smaller LLM models
EXTERNAL_LLM_MODEL=gpt-3.5-turbo  # instead of gpt-4

# Reduce max tokens
EXTERNAL_LLM_MAX_TOKENS=2000  # instead of 4096
```

### Health Check Commands

```bash
# Check all services
docker-compose ps

# Detailed health status
docker inspect dashboard-nexus | grep -A 10 Health

# Test each endpoint
curl http://localhost:3000          # Frontend
curl http://localhost:8000/health   # Nexus API
curl http://localhost:8001/health   # Schema Service
curl http://localhost:8081/v1/info  # Trino (may need auth)
```

### Getting Help

1. **Check logs**: `docker-compose logs -f`
2. **Verify configuration**: `cat .env`
3. **Test connectivity**: Use `curl` commands above
4. **Clean restart**: `./stop.sh --clean && ./start.sh`
5. **Check documentation**: See [DEPLOYMENT.md](./DEPLOYMENT.md)
6. **GitHub Issues**: https://github.com/roman1887/dashboard-docker/issues

---

## 💻 Development Workflow

### Making Code Changes

Since this is a Docker Compose setup, you'll typically modify code in the main dashboard repository, then rebuild here.

#### 1. Frontend Changes

```bash
# If you have frontend code in ../frontend
# Make changes, then:
docker-compose up -d --build frontend

# Or during active development, run frontend locally:
cd ../frontend
npm start  # Runs on port 3001, configure CORS in Nexus
```

#### 2. Backend (Nexus) Changes

```bash
# If you have nexus code in ../nexus
# Make changes, then:
docker-compose up -d --build nexus

# View logs to debug
docker-compose logs -f nexus
```

#### 3. Schema Service Changes

```bash
# If you have schema-service code in ../schema-service
# Make changes, then:
docker-compose up -d --build schema-service
```

#### 4. Database Schema Changes

```bash
# To apply new SQL migrations:
# 1. Add your .sql file to ../helm-charts/dashboard/sql/
# 2. Restart database (will run all init scripts)
./stop.sh --clean
./start.sh
```

### Hot Reloading

For active development, you can mount source code as volumes:

```yaml
# Add to docker-compose.yml
services:
  nexus:
    volumes:
      - ../nexus/app:/app  # Mount source code
    environment:
      - RELOAD=true  # Enable hot reload
```

### Testing Changes

```bash
# Run tests inside containers
docker-compose exec nexus pytest

# Or use test script
./test.sh
```

---

## 🚀 Production Deployment

This Docker Compose setup is designed for **local development and testing**. For production, we recommend:

### Kubernetes/Helm Deployment

See the [helm-charts repository](https://github.com/roman1887/helm-charts) for production-ready Kubernetes deployment with:

- Auto-scaling and load balancing
- Secrets management
- High availability
- Resource optimization
- Monitoring and logging
- Backup and disaster recovery

### Docker Compose Production Considerations

If you must use Docker Compose in production:

1. **Security**
   - Use Docker secrets instead of `.env` files
   - Enable SSL/TLS for all communications
   - Use non-root users in containers
   - Implement network isolation
   - Regular security updates

2. **Performance**
   - Use production-optimized images
   - External managed databases
   - Redis for caching
   - CDN for static assets
   - Load balancer (nginx/HAProxy)

3. **Reliability**
   - Docker Swarm for orchestration
   - Automated backups
   - Health monitoring
   - Log aggregation (ELK Stack)
   - Alerting (Prometheus/Grafana)

4. **Scalability**
   - Multiple service replicas
   - Database read replicas
   - External message queue (RabbitMQ/Kafka)
   - Distributed caching

---

## 📚 Additional Documentation

- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Detailed deployment guide
- **[LLM_PROVIDERS.md](./LLM_PROVIDERS.md)** - LLM provider configuration
- **[CONFIGURATION.md](./CONFIGURATION.md)** - Advanced configuration options
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - System architecture details
- **[API_REFERENCE.md](./API_REFERENCE.md)** - API documentation

---

## 🤝 Contributing

We welcome contributions! Please see [CONTRIBUTING.md](./CONTRIBUTING.md) for guidelines.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

---

## 🆘 Support

- **Documentation**: Check docs in this repository
- **Issues**: https://github.com/roman1887/dashboard-docker/issues
- **Discussions**: https://github.com/roman1887/dashboard-docker/discussions
- **Main Project**: https://github.com/roman1887/dashboard

---

## 🔗 Related Repositories

- **Main Dashboard**: https://github.com/roman1887/dashboard
- **Helm Charts**: https://github.com/roman1887/helm-charts
- **Documentation**: https://github.com/roman1887/dashboard-marketing

---

**Made with ❤️ by the Actyze Team**
