# Quick Start Guide

Get Actyze Dashboard running on your local machine in under 5 minutes!

---

## Prerequisites

- Docker Desktop installed and running
- At least 8GB RAM available for Docker
- LLM API key (Anthropic, OpenAI, Perplexity, or Groq)

---

## Step 1: Get the Code

```bash
git clone https://github.com/roman1887/dashboard-docker.git
cd dashboard-docker
```

---

## Step 2: Configure Environment

```bash
# Copy the example environment file
cp env.example .env

# Edit the file with your API key
nano .env  # or use your preferred editor
```

**Minimum required changes in `.env`:**

```bash
# Set your LLM API key (required for SQL generation)
ANTHROPIC_API_KEY=your-api-key-here

# Set a secure database password
POSTGRES_PASSWORD=your-secure-password
```

**Get API Keys:**
- **Anthropic Claude**: https://console.anthropic.com/settings/keys
- **OpenAI**: https://platform.openai.com/api-keys
- **Perplexity**: https://www.perplexity.ai/settings/api
- **Groq**: https://console.groq.com/keys (free tier available!)

---

## Step 3: Start Services

```bash
./start.sh
```

This will:
- ✓ Build all Docker images (first time: ~5-10 minutes)
- ✓ Start all services
- ✓ Initialize the database with demo data
- ✓ Wait for services to be healthy

---

## Step 4: Access the Dashboard

Once started, open your browser to:

🌐 **http://localhost:3000**

**Login with:**
- Username: `nexus_admin`
- Password: `admin`

---

## Step 5: Try Your First Query

1. Navigate to the **"Query"** tab
2. Enter a natural language query, for example:
   ```
   show me top 10 customers by total sales
   ```
3. Click **"Generate SQL"**
4. Review the generated SQL
5. Click **"Execute"** to see results

---

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Check service status
docker-compose ps

# Stop services (preserve data)
./stop.sh

# Stop and clean everything
./stop.sh --clean

# Run tests
./test.sh

# Restart services
./stop.sh && ./start.sh
```

---

## Troubleshooting

### Port Already in Use

```bash
# Find what's using the port
lsof -i :3000

# Kill the process or change ports in docker-compose.yml
```

### Services Won't Start

```bash
# Check Docker has enough memory (8GB recommended)
docker info | grep "Total Memory"

# Try clean restart
./stop.sh --clean
./start.sh
```

### Authentication Fails

```bash
# Check Nexus logs
docker-compose logs nexus

# Verify database is running
docker-compose ps postgres
```

### LLM API Errors

```bash
# Verify your API key in .env
cat .env | grep API_KEY

# Check Nexus logs for LLM errors
docker-compose logs nexus | grep -i llm
```

---

## Next Steps

- **[README.md](./README.md)** - Full documentation
- **[LLM_PROVIDERS.md](./LLM_PROVIDERS.md)** - Configure different LLM providers
- **[CONFIGURATION.md](./CONFIGURATION.md)** - Advanced configuration
- **[DEPLOYMENT.md](./DEPLOYMENT.md)** - Deployment options

---

## Getting Help

- **GitHub Issues**: https://github.com/roman1887/dashboard-docker/issues
- **Documentation**: See the docs in this repository
- **Discussions**: https://github.com/roman1887/dashboard-docker/discussions

---

**That's it! You're ready to start using Actyze Dashboard.** 🚀
