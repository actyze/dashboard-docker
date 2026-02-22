# AI Provider Configuration

Choose your preferred AI provider for natural language to SQL queries. Actyze works with all major AI services, giving you the flexibility to use what works best for your organization.

---

## 🚀 Quick Start

Connect Actyze to any of 100+ AI providers with just a few lines of configuration.

**Simple Setup:**
1. Get an API key from your chosen AI provider
2. Add 2-3 lines to your `.env` file
3. Restart Actyze: `./stop.sh && ./start.sh`

**That's it!** Actyze automatically works with any provider you choose.

---

## 📖 Integration Options

Actyze offers two ways to connect to AI services:

### **Direct Connection (Recommended)**
Connect directly to any major AI provider like OpenAI, Anthropic, Google, or AWS.

**Best for:** Most organizations

**Setup:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=<provider-model>
<PROVIDER>_API_KEY=<your-key>
```

### **Enterprise Gateway**
Connect through your company's internal AI gateway or proxy.

**Best for:** Large enterprises with IT-managed AI

**Setup:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODE=openai-compatible
EXTERNAL_LLM_BASE_URL=https://your-gateway.company.com/v1/chat/completions
EXTERNAL_LLM_MODEL=your-model-name
EXTERNAL_LLM_API_KEY=your-enterprise-token
```

---

## 🎯 Popular AI Providers

### **Anthropic Claude (Recommended)**

**Best for:** Most users - excellent SQL accuracy and complex query understanding.

**Why choose Claude:**
- Industry-leading SQL generation quality
- Understands complex business questions
- Reliable and consistent results

**Get API Key:** https://console.anthropic.com/settings/keys

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=claude-sonnet-4-20250514
ANTHROPIC_API_KEY=sk-ant-xxxxx
```

**Available Models:**
- `claude-sonnet-4-20250514` (recommended - best balance)
- `claude-opus-4-20250514` (most powerful, slower)
- `claude-3-5-sonnet-20241022` (fast and capable)

**Pricing:** https://www.anthropic.com/pricing

---

### **OpenAI**

**Best for:** Enterprises already using OpenAI services.

**Why choose OpenAI:**
- Widely adopted and trusted
- Excellent performance across all query types
- Strong enterprise support

**Get API Key:** https://platform.openai.com/api-keys

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=gpt-4
OPENAI_API_KEY=sk-xxxxx
```

**Available Models:**
- `gpt-4` (recommended - most capable)
- `gpt-4o` (optimized - fast and capable)
- `gpt-4-turbo` (balanced performance)
- `gpt-3.5-turbo` (fast, budget-friendly)

**Pricing:** https://openai.com/pricing

---

### **Google Gemini**

**Best for:** Cost-conscious users who need fast responses.

**Why choose Gemini:**
- Lower cost than comparable providers
- Fast query generation
- Good balance of quality and price

**Get API Key:** https://aistudio.google.com/app/apikey

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=gemini/gemini-2.0-flash-exp
GEMINI_API_KEY=your-gemini-key
```

**Available Models:**
- `gemini/gemini-2.0-flash-exp` (latest, fastest)
- `gemini/gemini-1.5-pro` (most capable)
- `gemini/gemini-1.5-flash` (fast, cost-effective)

**Note:** Model name must include `gemini/` prefix.

**Pricing:** https://ai.google.dev/pricing

---

### **AWS Bedrock**

**Best for:** Organizations already using AWS infrastructure.

**Why choose Bedrock:**
- Seamless integration with your AWS environment
- Enterprise-grade security and compliance
- No data leaves your AWS account
- Use your existing AWS billing and cost controls

**Requirements:**
- AWS account with Bedrock access
- Bedrock model access enabled in your AWS console

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0
AWS_REGION_NAME=us-east-2
# AWS credentials via standard env vars (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
# Or use IAM role if running on EC2/ECS
```

**Available Models:**
- `bedrock/anthropic.claude-sonnet-4-5-20250929-v1:0` (recommended)
- `bedrock/anthropic.claude-opus-4-20250514-v1:0` (most powerful)
- `bedrock/anthropic.claude-3-5-sonnet-20241022-v2:0` (fast)
- `bedrock/meta.llama3-70b-instruct-v1:0` (open source)

**Note:** Model name must include `bedrock/` prefix.

**Pricing:** https://aws.amazon.com/bedrock/pricing/

---

### **Perplexity AI**

**Best for:** Complex analytical queries requiring advanced reasoning.

**Why choose Perplexity:**
- Specialized in analytical thinking
- Good for multi-step queries
- Competitive pricing

**Get API Key:** https://www.perplexity.ai/settings/api

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=perplexity/sonar-reasoning-pro
PERPLEXITYAI_API_KEY=pplx-xxxxx
```

**Available Models:**
- `perplexity/sonar-reasoning-pro` (best for complex SQL)
- `perplexity/sonar-pro` (general purpose)
- `perplexity/sonar` (fast, cost-effective)

**Note:** Model name must include `perplexity/` prefix.

**Pricing:** https://docs.perplexity.ai/docs/pricing

---

### **Groq**

**Best for:** Testing and development, or users on a budget.

**Why choose Groq:**
- Free tier available (14,400 requests/day)
- Fastest response times
- Great for getting started with Actyze at no cost

**Get API Key:** https://console.groq.com/keys

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=groq/llama-3.3-70b-versatile
GROQ_API_KEY=gsk_xxxxx
```

**Available Models:**
- `groq/llama-3.3-70b-versatile` (recommended - fast and capable)
- `groq/llama-3.1-70b-versatile` (fast)
- `groq/mixtral-8x7b-32768` (large context)

**Note:** Model name must include `groq/` prefix.

**Free Tier:** 14,400 requests/day with generous rate limits.

**Pricing:** https://groq.com/pricing/

---

### **Azure OpenAI**

**Best for:** Microsoft Azure customers with compliance requirements.

**Why choose Azure OpenAI:**
- Use OpenAI models within your Azure environment
- Enterprise compliance and security controls
- Integration with your Azure billing and governance

**Get API Key:** Azure Portal → Your OpenAI Resource → Keys

**Configuration in `.env`:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=azure/your-deployment-name
AZURE_API_KEY=your-azure-key
AZURE_API_BASE=https://YOUR-RESOURCE.openai.azure.com
AZURE_API_VERSION=2023-05-15
```

**Replace:**
- `your-deployment-name` with your Azure deployment name
- `YOUR-RESOURCE` with your Azure OpenAI resource name

**Pricing:** https://azure.microsoft.com/en-us/pricing/details/cognitive-services/openai-service/

---

### **Other Providers (100+ supported)**

LiteLLM supports 100+ providers including:
- Mistral AI
- Cohere
- Together AI
- Replicate
- Anyscale
- DeepInfra
- Fireworks AI
- Ollama (self-hosted)
- And many more!

**Full list:** https://docs.litellm.ai/docs/providers

**General Configuration:**
```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODEL=<provider>/<model>  # e.g., mistral/mistral-large-latest
<PROVIDER>_API_KEY=your-key
```

---

## 🏢 Enterprise Gateway Integration

**For organizations with centralized AI management.**

### **When Your IT Department Manages AI Access:**

Many organizations route all AI services through a central gateway for:
- **Security & Compliance** - Meet regulatory requirements
- **Cost Control** - Track and allocate AI spending by team or project
- **Access Management** - Control who can use AI services
- **Audit Logging** - Monitor all AI usage for compliance

### **How It Works:**

Actyze connects to your company's AI gateway instead of directly to providers. Your IT team maintains control over security, costs, and compliance while your users get seamless access to AI-powered queries.

### **What Your IT Team Needs to Know:**

Your AI gateway should:
1. Accept standard OpenAI-compatible requests
2. Return standard OpenAI-compatible responses
3. Support your organization's authentication method (token, API key, SSO, etc.)

### **Configuration:**

```bash
EXTERNAL_LLM_ENABLED=true
EXTERNAL_LLM_MODE=openai-compatible

# Your enterprise endpoint
EXTERNAL_LLM_BASE_URL=https://llm-gateway.yourcompany.com/v1/chat/completions

# Your internal model identifier
EXTERNAL_LLM_MODEL=your-internal-model-name

# Authentication
EXTERNAL_LLM_AUTH_TYPE=bearer  # or api-key, x-api-key
EXTERNAL_LLM_API_KEY=your-enterprise-token

# Optional: Custom headers for your enterprise
EXTERNAL_LLM_EXTRA_HEADERS={"X-Department": "engineering", "X-Cost-Center": "ai-team"}
```

### **Enterprise Gateway Benefits:**

- 🔒 **Centralized Security** - Single point of authentication
- 💰 **Cost Management** - Track usage per department/team
- 📊 **Audit Logging** - Complete visibility into LLM usage
- 🚦 **Rate Limiting** - Prevent abuse and control costs
- 🔄 **Model Routing** - A/B test different models transparently
- 🛡️ **Compliance** - PII filtering, data governance

### **Example Enterprise Architecture:**

```
Actyze → Your LLM Gateway → Actual LLM (OpenAI/Bedrock/etc.)
         ↑
         ├─ Authentication (SSO, OAuth, JWT)
         ├─ Cost Tracking (per team/project)
         ├─ Audit Logging (SIEM integration)
         ├─ PII Filtering (compliance)
         ├─ Rate Limiting (cost control)
         └─ Model Routing (A/B testing)
```

### **Sample Enterprise Gateway (Python/FastAPI):**

```python
from fastapi import FastAPI, Header
import httpx

app = FastAPI()

@app.post("/v1/chat/completions")
async def chat_completions(request: dict, authorization: str = Header(None)):
    # 1. Validate enterprise authentication
    user = validate_enterprise_token(authorization)
    
    # 2. Check budget and permissions
    check_team_budget(user.team)
    
    # 3. Apply PII filtering
    request = filter_sensitive_data(request)
    
    # 4. Log for audit
    audit_log(user, request)
    
    # 5. Route to actual LLM (OpenAI, Bedrock, etc.)
    response = await call_llm(request)
    
    # 6. Track costs
    track_usage(user.team, response.usage)
    
    # 7. Return OpenAI-compatible format
    return response
```

**For detailed enterprise integration guide, see:** [ENTERPRISE_INTEGRATION_GUIDE.md](../dashboard/ENTERPRISE_INTEGRATION_GUIDE.md)

---

## 🔧 Configuration Reference

### **Direct Connection Configuration**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `EXTERNAL_LLM_ENABLED` | Enable external LLM | `true` |
| `EXTERNAL_LLM_MODEL` | Provider and model name | `gpt-4`, `claude-sonnet-4`, `gemini/gemini-pro` |
| `<PROVIDER>_API_KEY` | Provider-specific API key | `OPENAI_API_KEY`, `ANTHROPIC_API_KEY`, etc. |

**Optional:**
| Parameter | Description | Default |
|-----------|-------------|---------|
| `EXTERNAL_LLM_MAX_TOKENS` | Maximum response length | `4096` |
| `EXTERNAL_LLM_TEMPERATURE` | Response creativity (0-1) | `0.1` |
| `EXTERNAL_LLM_TIMEOUT` | Request timeout (seconds) | `30` |

### **Enterprise Gateway Configuration**

| Parameter | Description | Example |
|-----------|-------------|---------|
| `EXTERNAL_LLM_ENABLED` | Enable external LLM | `true` |
| `EXTERNAL_LLM_MODE` | Integration mode | `openai-compatible` |
| `EXTERNAL_LLM_BASE_URL` | Your gateway endpoint | `https://gateway.company.com/v1/chat/completions` |
| `EXTERNAL_LLM_MODEL` | Your model identifier | `company-gpt-4` |
| `EXTERNAL_LLM_API_KEY` | Your enterprise token | `your-token` |
| `EXTERNAL_LLM_AUTH_TYPE` | Authentication method | `bearer`, `api-key`, `x-api-key` |
| `EXTERNAL_LLM_EXTRA_HEADERS` | Custom headers (JSON) | `{"X-Department": "eng"}` |

---

## 🧪 Testing Your Configuration

### **Verify Configuration**

```bash
# Check environment variables
cat .env | grep EXTERNAL_LLM

# Restart Actyze
./stop.sh && ./start.sh

# Check logs for successful LLM initialization
docker-compose logs nexus | grep -i "litellm\|llm"
```

### **Test in Actyze**

1. Login to Actyze: http://localhost:3000
2. Go to Query page
3. Type: "Show me all tables"
4. Click "Generate SQL"
5. ✅ SQL should be generated successfully

### **Check Token Usage**

```bash
# View Nexus logs for token tracking
docker-compose logs nexus | grep "Token Usage"

# You should see: "Token Usage | prompt_tokens=X | completion_tokens=Y"
```

---

## 🛠️ Troubleshooting

### **Invalid API Key**

**Symptom:** "Authentication failed" or "Invalid API key"

**Solution:**
```bash
# Verify API key is set
cat .env | grep API_KEY

# Test key manually (varies by provider)
# OpenAI example:
curl https://api.openai.com/v1/models -H "Authorization: Bearer $OPENAI_API_KEY"

# Restart Actyze
./stop.sh && ./start.sh
```

### **Model Not Found**

**Symptom:** "Model not found" or "Invalid model"

**Common Issues:**
- **Missing prefix:** Gemini requires `gemini/`, Bedrock requires `bedrock/`, Groq requires `groq/`, etc.
- **Wrong model name:** Check provider documentation for exact model names
- **Region restriction:** Some models only available in specific regions (Bedrock)

**Solution:**
```bash
# Verify model name format
# Correct: gemini/gemini-2.0-flash-exp
# Wrong: gemini-2.0-flash-exp (missing prefix)

# Correct: bedrock/anthropic.claude-sonnet-4-5-v1:0
# Wrong: claude-sonnet-4-5 (missing bedrock prefix and full model ID)
```

### **LiteLLM Not Available**

**Symptom:** "LiteLLM feature enabled but library not installed"

**Solution:**
```bash
# This shouldn't happen with Docker images, but if it does:
# 1. Check Docker image version
docker-compose ps

# 2. Pull latest images
docker-compose pull

# 3. Restart
./stop.sh && ./start.sh
```

### **Slow Responses**

**Solutions:**
1. **Use faster models:**
   - Groq (ultra-fast inference)
   - `gemini/gemini-2.0-flash-exp` (Google's fastest)
   - `gpt-3.5-turbo` (OpenAI's fastest)

2. **Reduce token limit:**
   ```bash
   EXTERNAL_LLM_MAX_TOKENS=2000  # Default: 4096
   ```

3. **Enable caching:**
   ```bash
   CACHE_ENABLED=true
   CACHE_LLM_TTL=7200  # 2 hours
   ```

### **Rate Limit Exceeded**

**Symptom:** "Rate limit exceeded" or "Too many requests"

**Solutions:**
- **Wait:** Most rate limits reset within minutes
- **Upgrade plan:** Check your provider's tier limits
- **Switch provider:** Groq has generous free tier (14,400 req/day)
- **Enable caching:** Reduce redundant API calls

---

## 💰 Cost Optimization

### **1. Enable Caching**

Significantly reduce API calls by caching LLM responses:

```bash
# In .env
CACHE_ENABLED=true
CACHE_LLM_MAX_SIZE=200        # Cache up to 200 responses
CACHE_LLM_TTL=7200            # Keep cache for 2 hours
```

### **2. Choose Budget-Friendly Models**

| Tier | Providers | Use Case |
|------|-----------|----------|
| **Free** | Groq (14.4k req/day) | Testing, development |
| **Low Cost** | Gemini Flash, GPT-3.5-turbo | High volume, simple queries |
| **Balanced** | Claude Sonnet, GPT-4o | Production, most queries |
| **Premium** | Claude Opus, GPT-4 | Complex queries, highest quality |

### **3. Monitor Usage**

**Provider Dashboards:**
- **Anthropic:** https://console.anthropic.com/usage
- **OpenAI:** https://platform.openai.com/usage
- **Gemini:** https://aistudio.google.com/app/apikey
- **Perplexity:** https://www.perplexity.ai/settings/api
- **Groq:** https://console.groq.com/usage
- **Bedrock:** AWS Cost Explorer

**Actyze Logs:**
```bash
# View token usage in logs
docker-compose logs nexus | grep "Token Usage"
```

---

## 🔄 Switching Providers

Switching is easy - just update `.env` and restart:

```bash
# 1. Edit .env file
nano .env

# Example: Switch from OpenAI to Gemini
# Before:
# EXTERNAL_LLM_MODEL=gpt-4
# OPENAI_API_KEY=sk-xxx

# After:
# EXTERNAL_LLM_MODEL=gemini/gemini-2.0-flash-exp
# GEMINI_API_KEY=your-key

# 2. Restart Actyze
./stop.sh && ./start.sh
```

**No code changes or rebuilds required!**

---

## 📚 Additional Resources

**LiteLLM Documentation:**
- Official Docs: https://docs.litellm.ai/
- Supported Providers (100+): https://docs.litellm.ai/docs/providers
- Cost Tracking: https://docs.litellm.ai/docs/proxy/cost_tracking

**Provider Documentation:**
- **Anthropic:** https://docs.anthropic.com
- **OpenAI:** https://platform.openai.com/docs
- **Gemini:** https://ai.google.dev/docs
- **Bedrock:** https://docs.aws.amazon.com/bedrock/
- **Perplexity:** https://docs.perplexity.ai
- **Groq:** https://console.groq.com/docs

**Actyze Documentation:**
- Main Docs: https://docs.actyze.io
- Enterprise Integration: [ENTERPRISE_INTEGRATION_GUIDE.md](../dashboard/ENTERPRISE_INTEGRATION_GUIDE.md)
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues

---

## 🎉 Flexible AI Provider Support

Actyze works with 100+ AI providers, giving you the freedom to choose what works best for your organization.

```bash
# Simple setup - just 2 lines for any provider:
EXTERNAL_LLM_MODEL=<provider-model>
<PROVIDER>_API_KEY=<your-key>
```

**Benefits for Your Organization:**
- ✅ **No Vendor Lock-in** - Switch providers anytime without code changes
- ✅ **Use What You Have** - Works with your existing AI provider accounts
- ✅ **Cost Control** - Choose providers that fit your budget
- ✅ **Enterprise Ready** - Connect through your company's AI gateway
- ✅ **Simple Setup** - Just 2-3 lines of configuration
- ✅ **Peace of Mind** - Track usage and costs transparently

---

**Choose the AI provider that's right for you. Change your mind anytime.**
