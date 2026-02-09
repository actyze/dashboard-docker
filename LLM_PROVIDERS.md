# LLM Provider Configuration

Configure Actyze to use your preferred AI provider for natural language to SQL generation.

---

## Quick Start

1. Get an API key from your chosen provider
2. Update \`.env\` with provider settings
3. Restart Actyze: \`./stop.sh && ./start.sh\`

---

## Supported Providers

Actyze works with any LLM provider. Below are configuration examples for popular providers.

---

## Anthropic Claude (Recommended)

Claude Sonnet 4 offers excellent SQL generation with strong reasoning capabilities.

**Get API Key:** https://console.anthropic.com/settings/keys

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=sk-ant-xxxxx

# Provider Settings
EXTERNAL_LLM_PROVIDER=anthropic
EXTERNAL_LLM_BASE_URL=https://api.anthropic.com/v1/messages
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
EXTERNAL_LLM_AUTH_TYPE=x-api-key
EXTERNAL_LLM_EXTRA_HEADERS={"anthropic-version": "2023-06-01"}
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Available Models:**
- \`claude-sonnet-4-20250514\` (recommended - best balance)
- \`claude-3-5-sonnet-20241022\` (fast and capable)
- \`claude-opus-4-20250514\` (most powerful, slower)

---

## OpenAI

Industry-standard models with excellent performance.

**Get API Key:** https://platform.openai.com/api-keys

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=sk-xxxxx

# Provider Settings
EXTERNAL_LLM_PROVIDER=openai
EXTERNAL_LLM_BASE_URL=https://api.openai.com/v1/chat/completions
EXTERNAL_LLM_MODEL=gpt-4o
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Available Models:**
- \`gpt-4o\` (recommended - fast and capable)
- \`gpt-4-turbo\` (balanced performance)
- \`gpt-4\` (most capable, slower)
- \`gpt-3.5-turbo\` (fast, budget-friendly)

---

## Perplexity AI

Advanced reasoning models optimized for complex queries.

**Get API Key:** https://www.perplexity.ai/settings/api

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=pplx-xxxxx

# Provider Settings
EXTERNAL_LLM_PROVIDER=perplexity
EXTERNAL_LLM_BASE_URL=https://api.perplexity.ai/chat/completions
EXTERNAL_LLM_MODEL=sonar-reasoning-pro
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Available Models:**
- \`sonar-reasoning-pro\` (best for complex SQL)
- \`sonar-pro\` (general purpose)
- \`sonar\` (fast, cost-effective)

---

## Groq (Free Tier Available)

Ultra-fast inference with free tier - perfect for testing.

**Get API Key:** https://console.groq.com/keys

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=gsk_xxxxx

# Provider Settings
EXTERNAL_LLM_PROVIDER=groq
EXTERNAL_LLM_BASE_URL=https://api.groq.com/openai/v1/chat/completions
EXTERNAL_LLM_MODEL=mixtral-8x7b-32768
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Available Models:**
- \`mixtral-8x7b-32768\` (recommended - fast and capable)
- \`llama-3.3-70b-versatile\` (powerful, slower)
- \`gemma2-9b-it\` (lightweight, fast)

**Free Tier:** 14,400 requests/day with generous rate limits.

---

## Azure OpenAI

Enterprise-grade OpenAI models with Azure security and compliance.

**Get API Key:** Azure Portal → Your OpenAI Resource → Keys

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=your-azure-key

# Provider Settings
EXTERNAL_LLM_PROVIDER=azure
EXTERNAL_LLM_BASE_URL=https://YOUR-RESOURCE.openai.azure.com/openai/deployments/YOUR-DEPLOYMENT/chat/completions?api-version=2024-02-15-preview
EXTERNAL_LLM_MODEL=gpt-4
EXTERNAL_LLM_AUTH_TYPE=api-key
EXTERNAL_LLM_EXTRA_HEADERS=
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Replace:**
- \`YOUR-RESOURCE\` with your Azure OpenAI resource name
- \`YOUR-DEPLOYMENT\` with your deployment name

---

## Together AI

Access to 100+ open-source models.

**Get API Key:** https://api.together.xyz/settings/api-keys

**Configuration in \`.env\`:**
\`\`\`bash
# API Key
ANTHROPIC_API_KEY=xxxxx

# Provider Settings
EXTERNAL_LLM_PROVIDER=together
EXTERNAL_LLM_BASE_URL=https://api.together.xyz/v1/chat/completions
EXTERNAL_LLM_MODEL=meta-llama/Llama-3.3-70B-Instruct-Turbo
EXTERNAL_LLM_AUTH_TYPE=bearer
EXTERNAL_LLM_EXTRA_HEADERS=
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Popular Models:**
- \`meta-llama/Llama-3.3-70B-Instruct-Turbo\`
- \`mistralai/Mixtral-8x7B-Instruct-v0.1\`
- \`Qwen/Qwen2.5-72B-Instruct-Turbo\`

---

## Custom Provider

Actyze works with any OpenAI-compatible API:

\`\`\`bash
# API Key
ANTHROPIC_API_KEY=your-api-key

# Provider Settings
EXTERNAL_LLM_PROVIDER=custom
EXTERNAL_LLM_BASE_URL=https://your-custom-api.com/v1/chat/completions
EXTERNAL_LLM_MODEL=your-model-name
EXTERNAL_LLM_AUTH_TYPE=bearer  # or x-api-key, or api-key
EXTERNAL_LLM_EXTRA_HEADERS={}  # Optional JSON headers
EXTERNAL_LLM_MAX_TOKENS=4096
EXTERNAL_LLM_TEMPERATURE=0.1
\`\`\`

**Supported Authentication:**
- \`bearer\` - Authorization: Bearer TOKEN
- \`x-api-key\` - x-api-key: TOKEN
- \`api-key\` - api-key: TOKEN

---

## Configuration Parameters

### Required Parameters

| Parameter | Description | Example |
|-----------|-------------|---------|
| \`ANTHROPIC_API_KEY\` | Your LLM API key | \`sk-ant-xxxxx\` |
| \`EXTERNAL_LLM_PROVIDER\` | Provider name | \`anthropic\`, \`openai\`, \`perplexity\` |
| \`EXTERNAL_LLM_BASE_URL\` | API endpoint | \`https://api.anthropic.com/v1/messages\` |
| \`EXTERNAL_LLM_MODEL\` | Model identifier | \`claude-sonnet-4-20250514\` |
| \`EXTERNAL_LLM_AUTH_TYPE\` | Authentication method | \`bearer\`, \`x-api-key\`, \`api-key\` |

### Optional Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| \`EXTERNAL_LLM_EXTRA_HEADERS\` | Additional HTTP headers (JSON) | \`{}\` |
| \`EXTERNAL_LLM_MAX_TOKENS\` | Maximum response length | \`4096\` |
| \`EXTERNAL_LLM_TEMPERATURE\` | Response creativity (0-1) | \`0.1\` |
| \`EXTERNAL_LLM_TIMEOUT\` | Request timeout (seconds) | \`60\` |

---

## Testing Your Configuration

### Verify Configuration

\`\`\`bash
# Check environment variables
cat .env | grep EXTERNAL_LLM

# Restart Actyze
./stop.sh && ./start.sh
\`\`\`

### Test API Key

**Anthropic:**
\`\`\`bash
curl https://api.anthropic.com/v1/messages \\
  -H "x-api-key: YOUR_KEY" \\
  -H "anthropic-version: 2023-06-01" \\
  -H "content-type: application/json" \\
  -d '{"model":"claude-sonnet-4-20250514","max_tokens":100,"messages":[{"role":"user","content":"test"}]}'
\`\`\`

**OpenAI:**
\`\`\`bash
curl https://api.openai.com/v1/chat/completions \\
  -H "Authorization: Bearer YOUR_KEY" \\
  -H "Content-Type: application/json" \\
  -d '{"model":"gpt-4o","messages":[{"role":"user","content":"test"}],"max_tokens":100}'
\`\`\`

**Groq:**
\`\`\`bash
curl https://api.groq.com/openai/v1/chat/completions \\
  -H "Authorization: Bearer YOUR_KEY" \\
  -H "Content-Type: application/json" \\
  -d '{"model":"mixtral-8x7b-32768","messages":[{"role":"user","content":"test"}],"max_tokens":100}'
\`\`\`

### Test in Actyze

1. Login to Actyze (http://localhost:3000)
2. Go to Query page
3. Type: "Show me all tables"
4. Click "Generate SQL"
5. Check if SQL is generated successfully

---

## Troubleshooting

### Invalid API Key

**Symptom:** "Authentication failed" or "Invalid API key"

**Solution:**
\`\`\`bash
# Verify API key
cat .env | grep ANTHROPIC_API_KEY

# Test key manually (see Testing section above)

# Restart Actyze
./stop.sh && ./start.sh
\`\`\`

### Connection Timeout

**Symptom:** "Request timed out" or "Connection failed"

**Solution:**
\`\`\`bash
# Increase timeout in .env
EXTERNAL_LLM_TIMEOUT=120

# Check network connectivity
ping api.anthropic.com
\`\`\`

### Rate Limit Exceeded

**Symptom:** "Rate limit exceeded" or "Too many requests"

**Solutions:**
- Wait a few minutes
- Upgrade your API plan
- Switch to a provider with higher limits (e.g., Groq)
- Enable caching to reduce API calls

### Model Not Found

**Symptom:** "Model not found" or "Invalid model"

**Solution:**
\`\`\`bash
# Verify model name matches provider documentation
# Common errors:
# - Wrong model name spelling
# - Model not available in your region
# - Model requires higher API tier
\`\`\`

### Slow Responses

**Solutions:**
1. Use faster models (e.g., Groq, GPT-3.5-turbo)
2. Reduce \`EXTERNAL_LLM_MAX_TOKENS\`
3. Enable query caching

---

## Cost Optimization

### Enable Caching

In \`.env\`:
\`\`\`bash
CACHE_ENABLED=true
CACHE_QUERY_MAX_SIZE=100
CACHE_QUERY_TTL=3600  # 1 hour
\`\`\`

### Choose Budget-Friendly Models

- **Free:** Groq (14,400 requests/day)
- **Low Cost:** GPT-3.5-turbo, Claude Haiku
- **Balanced:** GPT-4o, Claude Sonnet
- **Premium:** GPT-4, Claude Opus

### Monitor Usage

Check your provider's dashboard:
- Anthropic: https://console.anthropic.com/usage
- OpenAI: https://platform.openai.com/usage
- Perplexity: https://www.perplexity.ai/settings/api
- Groq: https://console.groq.com/usage

---

## Switching Providers

To switch providers, just update your \`.env\` file and restart:

\`\`\`bash
# 1. Update provider settings in .env
nano .env

# 2. Restart Actyze
./stop.sh && ./start.sh
\`\`\`

No code changes or rebuilds required!

---

## Support

**Provider Documentation:**
- Anthropic: https://docs.anthropic.com
- OpenAI: https://platform.openai.com/docs
- Perplexity: https://docs.perplexity.ai
- Groq: https://console.groq.com/docs

**Actyze Support:**
- Documentation: https://docs.actyze.io
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues

---

**Use any LLM provider. Switch anytime. No vendor lock-in.**
