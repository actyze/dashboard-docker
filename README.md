# Actyze - Local Deployment with Docker Compose

Run Actyze on your local machine using Docker Compose. Perfect for evaluation, testing, and local deployments.

---

## Quick Start

Get Actyze running in 5 minutes:

```bash
# 1. Clone this repository
git clone https://github.com/actyze/dashboard-docker.git
cd dashboard-docker

# 2. Configure your environment
cp env.example .env
nano .env  # Add your LLM API key

# 3. Start Actyze
./start.sh

# 4. Access Actyze
open http://localhost:3000
```

**Default Login**: `nexus_admin` / `admin`

---

## What is Actyze?

Actyze is an AI-powered analytics platform that lets you query databases using natural language. No SQL knowledge required.

**Key Capabilities:**
- Ask questions in plain English (supports 50+ languages)
- Automatic SQL generation powered by AI
- Connect to multiple data sources (PostgreSQL, MySQL, MongoDB, Snowflake, BigQuery, and more)
- Upload CSV/Excel files for instant analysis
- Role-based access control
- Query caching for fast performance

---

## Prerequisites

**System Requirements:**
- Docker Desktop 20.10+ (or Docker Engine 20.10+)
- Docker Compose 2.0+
- 8GB+ RAM available for Docker
- 10GB+ disk space

**Required Credentials:**
- LLM API key (Anthropic Claude, OpenAI, Perplexity, or Groq)
- Optional: Your database connection details

**Verify Docker is ready:**
```bash
docker --version  # Should be 20.10.0+
docker-compose --version  # Should be 2.0.0+
```

---

## Architecture

Actyze runs as five containerized services, all pulled from Docker Hub:

```
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
```

**Services:**
- **Frontend** (port 3000): Web interface
- **Nexus** (port 8000): API and AI orchestration
- **Schema Service** (port 8001): Intelligent table recommendations
- **PostgreSQL** (port 5432): Application database
- **Trino** (port 8081): Connects to your data sources

---

## Installation

### Step 1: Clone Repository

```bash
git clone https://github.com/actyze/dashboard-docker.git
cd dashboard-docker
```

### Step 2: Configure Environment

```bash
# Copy the example configuration
cp env.example .env

# Edit with your settings
nano .env
```

**Required Configuration:**

```bash
# LLM API Key (REQUIRED)
ANTHROPIC_API_KEY=your-api-key-here

# Database Password (REQUIRED)
POSTGRES_PASSWORD=choose-a-secure-password

# LLM Provider Settings
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
```

**Optional - Connect Your Database:**

```bash
# If you want to use external Trino
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_SSL=true
```

See [Configuration Guide](#configuration) for all options.

### Step 3: Start Actyze

```bash
# Start all services
./start.sh

# Wait for all services to become healthy (30-60 seconds)
# You'll see: "All services are healthy!"
```

### Step 4: Access Actyze

**Open your browser:**
- Dashboard: http://localhost:3000
- API Docs: http://localhost:8000/docs

**Login with default credentials:**
- Username: `nexus_admin`
- Password: `admin`

**Change the default password immediately after first login.**

---

## Configuration

### LLM Providers

Actyze supports multiple AI providers. Configure in `.env`:

**Anthropic Claude (Recommended):**
```bash
ANTHROPIC_API_KEY=sk-ant-xxxxx
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
```

**OpenAI:**
```bash
ANTHROPIC_API_KEY=sk-xxxxx  # Yes, same variable for all providers
EXTERNAL_LLM_PROVIDER=openai
EXTERNAL_LLM_MODEL=gpt-4o
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
```

**Perplexity:**
```bash
ANTHROPIC_API_KEY=pplx-xxxxx
EXTERNAL_LLM_PROVIDER=perplexity
EXTERNAL_LLM_MODEL=sonar-reasoning-pro
EXTERNAL_LLM_AUTH_TYPE=bearer
```

**Groq (Free):**
```bash
ANTHROPIC_API_KEY=gsk_xxxxx
EXTERNAL_LLM_PROVIDER=groq
EXTERNAL_LLM_MODEL=mixtral-8x7b-32768
EXTERNAL_LLM_AUTH_TYPE=bearer
```

See full provider list: [LLM_PROVIDERS.md](./LLM_PROVIDERS.md)

### Database Connections

**Use Local PostgreSQL (Default):**
- Included with Actyze
- No additional configuration needed
- Starts automatically with `./start.sh`

**Use External Trino:**
```bash
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_USER=your-username
TRINO_PASSWORD=your-password
TRINO_SSL=true
TRINO_CATALOG=your-catalog
TRINO_SCHEMA=your-schema
```

**Configure Trino to connect to your databases:**
See `trino/` directory for connector configurations (PostgreSQL, MySQL, MongoDB, Snowflake, etc.)

### Performance Settings

```bash
# Query caching (recommended)
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100      # Cache up to 100 queries
CACHE_QUERY_TTL=1800           # Cache for 30 minutes

# Logging
LOG_LEVEL=INFO  # Options: DEBUG, INFO, WARNING, ERROR
DEBUG=false     # Set to true for detailed logs
```

---

## Usage

### Basic Commands

```bash
# Start Actyze
./start.sh

# Stop Actyze (preserves data)
./stop.sh

# Stop and remove all data
./stop.sh --clean

# View logs
docker-compose logs -f

# View logs for specific service
docker-compose logs -f nexus

# Check service status
docker-compose ps
```

### Deployment Profiles

Choose which services to run:

**Local (Default) - All services:**
```bash
./start.sh
# Runs: PostgreSQL, Trino, Schema Service, Nexus, Frontend
```

**External Databases - Connect to your existing infrastructure:**
```bash
# Configure external databases in .env first
./start.sh --profile external
# Runs: Schema Service, Nexus, Frontend
# Connects to: Your external PostgreSQL and Trino
```

**Mixed - Local PostgreSQL + External Trino:**
```bash
./start.sh --profile postgres-only
```

### Using Actyze

**1. Login**
- Go to http://localhost:3000
- Login with: `nexus_admin` / `admin`
- Change password in Settings

**2. Connect Your Data**
- Click "Data Sources"
- Add Trino connection or upload CSV/Excel files

**3. Ask Questions**
- Type your question in natural language
- Examples:
  - "What were our total sales last quarter?"
  - "Show top 10 customers by revenue"
  - "List all orders from this week"
- Click "Generate SQL" and "Execute"

**4. Save and Share**
- Save queries for later
- Create dashboards
- Share with team members (configure RBAC in Settings)

---

## Troubleshooting

### Services Won't Start

**Check Docker resources:**
```bash
docker info | grep "Total Memory"
# Should show 8GB+ available

# Increase in Docker Desktop: Preferences → Resources → Memory
```

**Check logs:**
```bash
docker-compose logs nexus
docker-compose logs schema-service
```

### Port Conflicts

**Error**: "port is already allocated"

**Solution:**
```bash
# Find what's using the port
lsof -i :3000

# Stop the conflicting service or change ports in docker-compose.yml
```

### Database Connection Failed

```bash
# Verify configuration
cat .env | grep POSTGRES

# Reset and restart
./stop.sh --clean
./start.sh
```

### LLM API Errors

**Check your API key:**
```bash
cat .env | grep API_KEY
```

**Test the API key directly:**
```bash
# For Anthropic
curl https://api.anthropic.com/v1/messages \
  -H "x-api-key: YOUR_KEY" \
  -H "anthropic-version: 2023-06-01" \
  -H "content-type: application/json" \
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
```

### Slow Performance

**Enable caching:**
```bash
# In .env
CACHE_ENABLED=true
```

**Use faster LLM models:**
```bash
# Groq is very fast (and free)
EXTERNAL_LLM_PROVIDER=groq
EXTERNAL_LLM_MODEL=mixtral-8x7b-32768
```

### Get Help

**Check service health:**
```bash
curl http://localhost:3000          # Frontend
curl http://localhost:8000/health   # Nexus
curl http://localhost:8001/health   # Schema Service
```

**Review logs:**
```bash
docker-compose logs -f
```

**Documentation:**
- Full documentation: https://docs.actyze.io
- LLM providers: [LLM_PROVIDERS.md](./LLM_PROVIDERS.md)
- Architecture: [ARCHITECTURE.md](./ARCHITECTURE.md)

**Support:**
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues
- Documentation: https://docs.actyze.io

---

## Updating Actyze

```bash
# Stop current version
./stop.sh

# Pull latest images
docker-compose pull

# Start updated version
./start.sh
```

Docker Compose automatically pulls the latest images from Docker Hub when you restart.

---

## Production Deployment

**This Docker Compose setup is designed for local use, evaluation, and testing.**

**For production deployments**, use Kubernetes with Helm charts:
- Helm Charts: https://github.com/actyze/helm-charts
- Documentation: https://docs.actyze.io/docs/deployment/helm
- Features: Auto-scaling, high availability, production-grade resources

---

## Additional Documentation

- **[LLM_PROVIDERS.md](./LLM_PROVIDERS.md)** - Complete LLM configuration guide
- **[ARCHITECTURE.md](./ARCHITECTURE.md)** - System architecture details
- **[CONFIGURATION.md](./CONFIGURATION.md)** - Advanced configuration options
- **[CHANGELOG.md](./CHANGELOG.md)** - Version history

---

## Related Resources

- **Documentation Site**: https://docs.actyze.io
- **Helm Charts** (Production): https://github.com/actyze/helm-charts
- **Docker Hub**: https://hub.docker.com/u/actyze

---

**Run Actyze locally. Query your data with natural language. Get insights instantly.**
