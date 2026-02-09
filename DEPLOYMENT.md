# Actyze Local Deployment Guide

Complete guide for deploying Actyze on your local machine using Docker Compose.

---

## Architecture

Actyze runs as five containerized services:

\`\`\`
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
            │  Your LLM        │
            │  (Claude/GPT-4)  │
            └──────────────────┘
\`\`\`

**Services:**
- **Frontend** (port 3000): Web interface
- **Nexus** (port 8000): API and AI orchestration
- **Schema Service** (port 8001): Intelligent recommendations
- **PostgreSQL** (port 5432): Application database
- **Trino** (port 8081): Connects to your data

All images are automatically pulled from Docker Hub - no building required.

---

## Prerequisites

**System Requirements:**
- Docker Desktop 20.10+ (or Docker Engine 20.10+)
- Docker Compose 2.0+
- 8GB+ RAM available for Docker
- 10GB+ disk space
- Internet connection

**Required Credentials:**
- LLM API key (Anthropic, OpenAI, Perplexity, or Groq)
- Database passwords (optional if using external databases)

**Verify Docker:**
\`\`\`bash
docker --version  # Should be 20.10.0+
docker-compose --version  # Should be 2.0.0+
docker info | grep "Total Memory"  # Should show 8GB+
\`\`\`

---

## Installation

### Step 1: Get Actyze

\`\`\`bash
git clone https://github.com/actyze/dashboard-docker.git
cd dashboard-docker
\`\`\`

### Step 2: Configure Environment

\`\`\`bash
# Copy example configuration
cp env.example .env

# Edit with your settings
nano .env
\`\`\`

**Required Configuration:**

\`\`\`bash
# LLM API Key (REQUIRED)
ANTHROPIC_API_KEY=your-api-key-here

# LLM Provider Settings
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514

# Database Password (REQUIRED)
POSTGRES_PASSWORD=choose-a-secure-password
\`\`\`

See [CONFIGURATION.md](CONFIGURATION.md) for complete configuration options.

### Step 3: Start Services

\`\`\`bash
# Start all services
./start.sh
\`\`\`

The script will:
1. Pull latest Docker images from Docker Hub
2. Start all services
3. Wait for health checks
4. Display access URLs

**Expected output:**
\`\`\`
Starting Actyze Dashboard...
Creating network...
Starting PostgreSQL...
Starting Trino...
Starting Schema Service...
Starting Nexus API...
Starting Frontend...

All services are healthy!

Access Actyze at:
  Dashboard: http://localhost:3000
  API Docs:  http://localhost:8000/docs
\`\`\`

---

## Deployment Options

Actyze supports different deployment profiles based on your needs:

### Option 1: Local (Default)

All services run locally - best for evaluation and testing.

\`\`\`bash
./start.sh
\`\`\`

**Includes:**
- Local PostgreSQL database
- Local Trino query engine
- All Actyze services

**Use when:** Evaluating Actyze or testing locally

### Option 2: External Databases

Connect to your existing databases - skip local PostgreSQL and Trino.

**Step 1:** Configure external connections in \`.env\`:

\`\`\`bash
# External PostgreSQL
POSTGRES_HOST=your-db-server.com
POSTGRES_PORT=5432
POSTGRES_DB=your-database
POSTGRES_USER=your-username
POSTGRES_PASSWORD=your-password

# External Trino
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_USER=your-username
TRINO_PASSWORD=your-password
TRINO_SSL=true
\`\`\`

**Step 2:** Start with external profile:

\`\`\`bash
./start.sh --profile external
\`\`\`

**Use when:** Connecting Actyze to your existing infrastructure

### Option 3: Mixed

Local PostgreSQL + External Trino (or vice versa).

**Configure in \`.env\`:**
\`\`\`bash
# Use local PostgreSQL (default)
POSTGRES_HOST=postgres

# Use external Trino
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_SSL=true
\`\`\`

**Start normally:**
\`\`\`bash
./start.sh
\`\`\`

**Use when:** Testing queries against production data

---

## Accessing Actyze

### Web Dashboard

Open your browser:
\`\`\`
http://localhost:3000
\`\`\`

**Login:**
- Username: \`nexus_admin\`
- Password: \`admin\`

**Change the default password immediately after first login.**

### API Documentation

Interactive API documentation:
\`\`\`
http://localhost:8000/docs
\`\`\`

### Health Checks

Verify all services are running:

\`\`\`bash
# Frontend
curl http://localhost:3000

# Nexus API
curl http://localhost:8000/health

# Schema Service
curl http://localhost:8001/health

# PostgreSQL
docker exec dashboard-postgres pg_isready
\`\`\`

---

## Managing Services

### View Service Status

\`\`\`bash
# Check all services
docker-compose ps

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f nexus
docker-compose logs -f frontend
\`\`\`

### Stop Services

\`\`\`bash
# Stop (preserves data)
./stop.sh

# Stop and remove all data
./stop.sh --clean
\`\`\`

### Restart Services

\`\`\`bash
# Restart everything
./stop.sh && ./start.sh

# Restart specific service
docker-compose restart nexus
\`\`\`

### Update to Latest Version

\`\`\`bash
# Stop services
./stop.sh

# Pull latest images
docker-compose pull

# Start with updated images
./start.sh
\`\`\`

---

## Performance Tuning

### Resource Allocation

Adjust Docker resource limits:

**Docker Desktop:**
1. Open Docker Desktop
2. Go to Preferences → Resources
3. Increase Memory to 8GB+ (16GB recommended)
4. Increase CPUs to 4+ (8 recommended)
5. Restart Docker

### Enable Query Caching

In \`.env\`:
\`\`\`bash
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=1800  # 30 minutes
\`\`\`

### Choose Faster LLM

For faster responses, use Groq (free):
\`\`\`bash
EXTERNAL_LLM_PROVIDER=groq
EXTERNAL_LLM_MODEL=mixtral-8x7b-32768
\`\`\`

---

## Troubleshooting

### Services Won't Start

**Check Docker is running:**
\`\`\`bash
docker info
\`\`\`

**Check available resources:**
\`\`\`bash
docker info | grep "Total Memory"
docker info | grep "CPUs"
\`\`\`

**Check logs:**
\`\`\`bash
docker-compose logs
\`\`\`

### Port Conflicts

**Error:** "port is already allocated"

**Solution:**
\`\`\`bash
# Find what's using the port
lsof -i :3000
lsof -i :8000

# Stop the conflicting service or change ports in docker-compose.yml
\`\`\`

### Database Connection Failed

**Check PostgreSQL is running:**
\`\`\`bash
docker-compose ps postgres
docker-compose logs postgres
\`\`\`

**Test connection:**
\`\`\`bash
docker exec -it dashboard-postgres psql -U nexus_service -d dashboard
\`\`\`

### LLM API Errors

**Verify API key:**
\`\`\`bash
cat .env | grep API_KEY
\`\`\`

**Test API key manually:**
\`\`\`bash
# For Anthropic
curl https://api.anthropic.com/v1/messages \\
  -H "x-api-key: YOUR_KEY" \\
  -H "anthropic-version: 2023-06-01" \\
  -H "content-type: application/json" \\
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
\`\`\`

### Slow Performance

**Enable caching:**
\`\`\`bash
CACHE_ENABLED=true
\`\`\`

**Increase Docker resources:**
- Memory: 8GB → 16GB
- CPUs: 4 → 8

**Use faster LLM:**
\`\`\`bash
EXTERNAL_LLM_PROVIDER=groq
\`\`\`

### Data Persistence

**Where is my data stored?**

Docker volumes persist data even after stopping services:
- \`dashboard_postgres_data\` - Database data
- \`dashboard_trino_data\` - Trino metadata

**View volumes:**
\`\`\`bash
docker volume ls | grep dashboard
\`\`\`

**Backup data:**
\`\`\`bash
# Backup PostgreSQL
docker exec dashboard-postgres pg_dump -U nexus_service dashboard > backup.sql

# Restore
docker exec -i dashboard-postgres psql -U nexus_service dashboard < backup.sql
\`\`\`

**Remove all data:**
\`\`\`bash
./stop.sh --clean
\`\`\`

---

## Security

### Change Default Password

1. Login with \`nexus_admin\` / \`admin\`
2. Go to Settings → Account
3. Change password immediately

### Secure API Keys

- Never commit \`.env\` to version control
- Use strong, unique passwords
- Rotate API keys regularly

### Network Security

For production use, consider:
- Running behind a reverse proxy (nginx, Caddy)
- Enabling SSL/TLS certificates
- Implementing IP whitelisting
- Using VPN for remote access

---

## Production Deployment

**This Docker Compose setup is designed for local use and evaluation.**

For production deployments, use Kubernetes with Helm:
- **Helm Charts**: https://github.com/actyze/helm-charts
- **Documentation**: https://docs.actyze.io/docs/deployment/helm
- **Features**: Auto-scaling, high availability, production-grade resources

---

## Support

**Documentation:**
- Quick Start: [QUICK_START.md](QUICK_START.md)
- Configuration: [CONFIGURATION.md](CONFIGURATION.md)
- LLM Providers: [LLM_PROVIDERS.md](LLM_PROVIDERS.md)
- Complete Guide: https://docs.actyze.io

**Support:**
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues
- Documentation: https://docs.actyze.io

---

**Deploy Actyze locally. Query your data instantly. No SQL required.**
