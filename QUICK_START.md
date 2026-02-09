# Quick Start Guide

Get Actyze running on your local machine in under 5 minutes!

---

## Prerequisites

- Docker Desktop installed and running
- At least 8GB RAM available for Docker
- LLM API key (Anthropic, OpenAI, Perplexity, or Groq)

---

## Step 1: Get Actyze

\`\`\`bash
git clone https://github.com/actyze/dashboard-docker.git
cd dashboard-docker
\`\`\`

---

## Step 2: Configure

\`\`\`bash
# Copy the example configuration
cp env.example .env

# Edit with your credentials
nano .env  # or use your preferred editor
\`\`\`

**Minimum required changes in \`.env\`:**

\`\`\`bash
# Set your LLM API key (required for SQL generation)
ANTHROPIC_API_KEY=your-api-key-here

# Set a secure database password
POSTGRES_PASSWORD=your-secure-password
\`\`\`

**Get API Keys:**
- **Anthropic Claude**: https://console.anthropic.com/settings/keys
- **OpenAI**: https://platform.openai.com/api-keys
- **Perplexity**: https://www.perplexity.ai/settings/api
- **Groq**: https://console.groq.com/keys (free tier available)

---

## Step 3: Start Actyze

\`\`\`bash
# Start all services
./start.sh
\`\`\`

Wait 30-60 seconds for all services to become healthy.

---

## Step 4: Access Actyze

Open your browser:

- **Dashboard**: http://localhost:3000
- **API Documentation**: http://localhost:8000/docs

**Login:**
- Username: \`nexus_admin\`
- Password: \`admin\`

**Important**: Change the default password after first login!

---

## Step 5: Try Your First Query

1. **Login** to the dashboard
2. **Go to Query Page**
3. **Type a question**:
   - "Show me all data available"
   - "What are the top 10 items?"
   - "List recent transactions"
4. **Click "Generate SQL"** - Actyze will create the SQL for you
5. **Click "Execute"** - See your results instantly

---

## What's Next?

### Connect Your Database

Add your own data source in \`.env\`:

\`\`\`bash
# Trino connection (connects to your databases)
TRINO_HOST=your-trino-server.com
TRINO_PORT=443
TRINO_USER=your-username
TRINO_PASSWORD=your-password
TRINO_SSL=true
\`\`\`

See [CONFIGURATION.md](CONFIGURATION.md) for all Trino connector options.

### Upload CSV/Excel Files

No database? No problem!
- Click "Upload Data" in the dashboard
- Drop your CSV or Excel file
- Start querying immediately

### Explore Features

- **Save Queries** - Bookmark frequently used queries
- **Share Results** - Export as CSV or share with team
- **Multiple Languages** - Ask questions in 50+ languages
- **Smart Suggestions** - AI recommends relevant tables

---

## Common Issues

### Port Already in Use

If port 3000 or 8000 is busy:

\`\`\`bash
# Check what's using the port
lsof -i :3000

# Stop the conflicting service or edit docker-compose.yml
\`\`\`

### Services Won't Start

Check Docker resources:

\`\`\`bash
# Ensure Docker has enough memory
docker info | grep "Total Memory"
# Should show 8GB+ available

# Increase in Docker Desktop: 
# Preferences → Resources → Memory → 8GB+
\`\`\`

### LLM API Error

Verify your API key:

\`\`\`bash
# Check configuration
cat .env | grep API_KEY

# Test the API key (Anthropic example)
curl https://api.anthropic.com/v1/messages \\
  -H "x-api-key: YOUR_KEY" \\
  -H "anthropic-version: 2023-06-01" \\
  -H "content-type: application/json" \\
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
\`\`\`

---

## Need Help?

- **Full Documentation**: [README.md](README.md)
- **Configuration Guide**: [CONFIGURATION.md](CONFIGURATION.md)
- **LLM Setup**: [LLM_PROVIDERS.md](LLM_PROVIDERS.md)
- **Support**: https://docs.actyze.io
- **Issues**: https://github.com/actyze/dashboard-docker/issues

---

**Query your data in minutes. No SQL required.**
