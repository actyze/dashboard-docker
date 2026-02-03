# Actyze Dashboard Architecture

This document provides a detailed overview of the Actyze Dashboard architecture when deployed using Docker Compose.

---

## Table of Contents

- [System Overview](#system-overview)
- [Service Components](#service-components)
- [Data Flow](#data-flow)
- [Network Architecture](#network-architecture)
- [Security Architecture](#security-architecture)
- [Scalability Considerations](#scalability-considerations)

---

## System Overview

Actyze Dashboard is a microservices-based platform that converts natural language queries into SQL using AI/ML technologies.

### High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     Actyze Dashboard Platform                    │
└─────────────────────────────────────────────────────────────────┘

                    User (Web Browser)
                           │
                           ▼
                  ┌─────────────────┐
                  │    Frontend     │  React + Material-UI
                  │   (nginx:3000)  │  - Authentication UI
                  │                 │  - Query Interface
                  └────────┬────────┘  - Result Visualization
                           │
                           ▼ HTTP/REST
                  ┌─────────────────┐
                  │   Nexus API     │  FastAPI (Python)
                  │    (8000)       │  - Main Orchestrator
                  │                 │  - LLM Integration
                  └────┬────────┬───┘  - Query Execution
                       │        │
          ┌────────────┘        └────────────┐
          ▼                                  ▼
┌──────────────────┐              ┌──────────────────┐
│ Schema Service   │              │   PostgreSQL     │
│  (FAISS:8001)    │              │    Database      │
│                  │              │     (5432)       │
│ - Table Search   │              │ - App Data       │
│ - Recommendations│              │ - User Data      │
│ - Intent Matching│              │ - Query History  │
└──────────────────┘              └──────────────────┘
          │                                  │
          ▼                                  ▼
┌──────────────────┐              ┌──────────────────┐
│  External LLM    │              │   Trino Engine   │
│  (Anthropic/etc) │              │     (8081)       │
│                  │              │                  │
│ - SQL Generation │              │ - Query Executor │
│ - Query Refine   │              │ - Multi-Source   │
└──────────────────┘              │ - Distributed    │
                                  └──────────────────┘
```

---

## Service Components

### 1. Frontend Service

**Technology**: React 18, Material-UI, Tailwind CSS, nginx

**Port**: 3000

**Responsibilities**:
- User authentication interface
- Natural language query input
- SQL display and editing
- Query result visualization
- User preference management
- Theme management (light/dark mode)

**Architecture**:
```
┌─────────────────────────────────────────┐
│          Frontend Container              │
├─────────────────────────────────────────┤
│  nginx (Reverse Proxy)                  │
│    ├── Static Files (/usr/share/nginx)  │
│    ├── API Proxy → Nexus:8000           │
│    └── SPA Routing → index.html         │
├─────────────────────────────────────────┤
│  React Application (Built)              │
│    ├── Components                       │
│    ├── Services (API clients)           │
│    ├── Contexts (State management)      │
│    └── Utilities                        │
└─────────────────────────────────────────┘
```

**Key Features**:
- Single Page Application (SPA)
- Client-side routing
- JWT token management
- API request batching
- Error boundary handling
- Responsive design

---

### 2. Nexus Service

**Technology**: FastAPI (Python), SQLAlchemy, asyncio

**Port**: 8000

**Responsibilities**:
- Main API orchestration
- Authentication and authorization
- LLM API integration
- Query generation and refinement
- Query execution via Trino
- Result formatting and caching
- User and query management

**Architecture**:
```
┌─────────────────────────────────────────┐
│          Nexus Container                 │
├─────────────────────────────────────────┤
│  FastAPI Application                    │
│    ├── Routers                          │
│    │   ├── /auth (Authentication)       │
│    │   ├── /api/generate-sql            │
│    │   ├── /api/execute-query           │
│    │   ├── /api/users                   │
│    │   └── /health                      │
│    ├── Services                         │
│    │   ├── LLM Service                  │
│    │   ├── Schema Service Client        │
│    │   ├── Trino Service                │
│    │   └── Cache Service                │
│    ├── Models (SQLAlchemy ORM)          │
│    ├── Database (PostgreSQL)            │
│    └── Middleware                       │
│        ├── CORS                         │
│        ├── Authentication               │
│        └── Error Handler                │
└─────────────────────────────────────────┘
```

**Key Components**:

1. **LLM Integration Layer**
   - Provider-agnostic interface
   - Request/response formatting
   - Error handling and retries
   - Token usage tracking

2. **Query Engine**
   - SQL generation from NL
   - Query validation
   - Execution via Trino
   - Result caching

3. **Schema Service Client**
   - Table recommendation requests
   - Intent matching
   - Schema metadata caching

4. **Authentication**
   - JWT token generation
   - Role-based access control
   - Session management

---

### 3. Schema Service

**Technology**: FastAPI (Python), FAISS, spaCy, sentence-transformers

**Port**: 8001

**Responsibilities**:
- Semantic search for tables/columns
- Natural language intent matching
- Table recommendations
- Schema metadata indexing

**Architecture**:
```
┌─────────────────────────────────────────┐
│       Schema Service Container           │
├─────────────────────────────────────────┤
│  FastAPI Application                    │
│    ├── /recommend (Table search)        │
│    ├── /intent (Intent matching)        │
│    └── /health                          │
├─────────────────────────────────────────┤
│  FAISS Vector Index                     │
│    ├── Table embeddings                 │
│    ├── Column embeddings                │
│    └── Intent embeddings                │
├─────────────────────────────────────────┤
│  ML Models                              │
│    ├── Sentence Transformer             │
│    │   (all-MiniLM-L6-v2)              │
│    ├── spaCy NLP Pipeline               │
│    └── FAISS Index (Flat/IVF)           │
├─────────────────────────────────────────┤
│  Schema Metadata                        │
│    ├── From Trino (runtime)             │
│    ├── From PostgreSQL (intent table)   │
│    └── Cache (in-memory)                │
└─────────────────────────────────────────┘
```

**Data Flow**:
1. Natural language query received
2. Query embedded using sentence-transformers
3. FAISS similarity search against indexed tables
4. Top-K tables returned with confidence scores
5. Results cached for performance

**Model Loading**:
- Models downloaded on first run
- Cached in volume (`schema_models`)
- Approximately 80MB download size

---

### 4. PostgreSQL Database

**Technology**: PostgreSQL 15

**Port**: 5432

**Responsibilities**:
- Application data storage
- User accounts and authentication
- Query history and caching
- Intent examples for Schema Service
- Demo datasets (optional)

**Schema Structure**:
```sql
-- Users and Authentication
users
  - id (PK)
  - username
  - email
  - password_hash
  - role
  - created_at

user_sessions
  - id (PK)
  - user_id (FK)
  - token
  - expires_at

-- Query Management
queries
  - id (PK)
  - user_id (FK)
  - nl_query
  - generated_sql
  - executed
  - result_count
  - execution_time
  - created_at

query_cache
  - id (PK)
  - query_hash
  - result
  - cached_at
  - expires_at

-- Schema Service
intent_examples
  - id (PK)
  - intent
  - example_query
  - table_names
  - created_at

-- Demo Data (Optional)
customers
orders
products
sales
-- ... TPC-H schema ...
```

**Initialization**:
- SQL scripts run on first startup
- Located in mounted volume
- Creates schema + demo data

---

### 5. Trino Query Engine

**Technology**: Trino (formerly PrestoSQL)

**Port**: 8081

**Responsibilities**:
- Distributed SQL query execution
- Multi-source data federation
- Query optimization and planning
- Data source connectors

**Architecture**:
```
┌─────────────────────────────────────────┐
│          Trino Container                 │
├─────────────────────────────────────────┤
│  Trino Coordinator + Worker             │
│    ├── Query Parser                     │
│    ├── Query Planner                    │
│    ├── Query Optimizer                  │
│    └── Query Executor                   │
├─────────────────────────────────────────┤
│  Connectors (Catalogs)                  │
│    ├── postgres (PostgreSQL)            │
│    ├── tpch (Sample data)               │
│    ├── mongodb (Optional)               │
│    └── snowflake (Optional)             │
├─────────────────────────────────────────┤
│  Configuration                          │
│    ├── config.properties                │
│    ├── jvm.config                       │
│    └── catalog/*.properties             │
└─────────────────────────────────────────┘
```

**Connector Configuration**:
- **postgres**: Main application database
- **tpch**: Built-in sample data for testing
- **mongodb**: Optional MongoDB Atlas
- **snowflake**: Optional Snowflake DW

**Resource Configuration**:
- Memory: 512MB-1GB (local dev)
- Query memory: 256MB per node
- Suitable for small-medium queries

---

## Data Flow

### Query Execution Flow

```
1. User Input
   │
   ├─► [Frontend] User enters: "show me top customers"
   │
2. API Request
   │
   ├─► [Nexus API] POST /api/generate-sql
   │   └─► Authentication check (JWT)
   │
3. Schema Recommendation
   │
   ├─► [Nexus] → [Schema Service] POST /recommend
   │   └─► FAISS similarity search
   │   └─► Returns: [customers, orders] tables
   │
4. LLM SQL Generation
   │
   ├─► [Nexus] → [External LLM API]
   │   ├─► Prompt: User query + Schema context
   │   └─► Response: Generated SQL
   │
5. SQL Validation & Execution
   │
   ├─► [Nexus] Validate SQL syntax
   │   └─► Check cache (optional)
   │
   ├─► [Nexus] → [Trino] Execute SQL
   │   ├─► [Trino] → [PostgreSQL] Fetch data
   │   └─► Returns: Query results
   │
6. Result Processing
   │
   ├─► [Nexus] Format results
   │   ├─► Cache results (optional)
   │   ├─► Log query to database
   │   └─► Return to frontend
   │
7. Display Results
   │
   └─► [Frontend] Display table + SQL
```

### Authentication Flow

```
1. Login Request
   │
   ├─► [Frontend] POST /auth/login
   │   └─► {username, password}
   │
2. Credential Verification
   │
   ├─► [Nexus] Check PostgreSQL
   │   └─► Verify password hash
   │
3. Token Generation
   │
   ├─► [Nexus] Generate JWT token
   │   └─► Store session in database
   │
4. Token Response
   │
   ├─► [Frontend] Receive access_token
   │   └─► Store in memory (not localStorage)
   │
5. Authenticated Requests
   │
   └─► [Frontend] → [Nexus]
       └─► Header: Authorization: Bearer <token>
```

---

## Network Architecture

### Docker Network

```
┌─────────────────────────────────────────────────────────┐
│         Docker Network: dashboard-local (bridge)         │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  ┌──────────┐   ┌──────────┐   ┌──────────┐            │
│  │ Frontend │   │  Nexus   │   │ Schema   │            │
│  │  :3000   │   │  :8000   │   │  :8001   │            │
│  └────┬─────┘   └────┬─────┘   └────┬─────┘            │
│       │              │              │                   │
│       └──────────────┴──────────────┘                   │
│                      │                                  │
│       ┌──────────────┴──────────────┐                   │
│       │                             │                   │
│  ┌────▼─────┐                 ┌────▼─────┐             │
│  │PostgreSQL│                 │  Trino   │             │
│  │  :5432   │                 │  :8081   │             │
│  └──────────┘                 └──────────┘             │
│                                                          │
└─────────────────────────────────────────────────────────┘

External Access:
  Host:3000 → Frontend:80
  Host:8000 → Nexus:8000
  Host:8001 → Schema:8000
  Host:5432 → PostgreSQL:5432
  Host:8081 → Trino:8080
```

### Service Communication

| From → To | Protocol | Purpose |
|-----------|----------|---------|
| Frontend → Nexus | HTTP/REST | API requests |
| Nexus → Schema Service | HTTP/REST | Table recommendations |
| Nexus → PostgreSQL | PostgreSQL | Database queries |
| Nexus → Trino | HTTP/REST | Query execution |
| Nexus → External LLM | HTTPS/REST | SQL generation |
| Schema Service → Trino | HTTP/REST | Metadata fetch |
| Schema Service → PostgreSQL | PostgreSQL | Intent examples |
| Trino → PostgreSQL | JDBC | Data queries |
| Trino → External DBs | Various | Data federation |

---

## Security Architecture

### Authentication & Authorization

```
┌─────────────────────────────────────────┐
│         Security Layers                  │
├─────────────────────────────────────────┤
│                                          │
│  1. Frontend Security                   │
│     ├── JWT token validation            │
│     ├── Token refresh mechanism         │
│     ├── XSS protection                  │
│     └── CSRF protection                 │
│                                          │
│  2. API Security (Nexus)                │
│     ├── JWT verification                │
│     ├── Role-based access control       │
│     ├── Rate limiting                   │
│     ├── SQL injection prevention        │
│     └── Input validation                │
│                                          │
│  3. Database Security                   │
│     ├── Password hashing (bcrypt)       │
│     ├── Connection encryption (TLS)     │
│     ├── Prepared statements             │
│     └── Least privilege access          │
│                                          │
│  4. Network Security                    │
│     ├── Internal Docker network         │
│     ├── Port exposure control           │
│     └── Service isolation               │
│                                          │
│  5. Secret Management                   │
│     ├── Environment variables           │
│     ├── .env file (gitignored)          │
│     └── Docker secrets (production)     │
│                                          │
└─────────────────────────────────────────┘
```

### Data Flow Security

```
[User Browser]
      │
      │ HTTPS (production)
      ▼
[Frontend nginx]
      │
      │ JWT in Authorization header
      ▼
[Nexus API]
      │
      ├──► Verify JWT signature
      ├──► Check token expiration
      ├──► Validate user permissions
      └──► Process request
            │
            ├──► [PostgreSQL] (encrypted connection)
            ├──► [Schema Service] (internal network)
            ├──► [Trino] (internal network)
            └──► [External LLM] (HTTPS + API key)
```

---

## Scalability Considerations

### Current Limitations (Docker Compose)

1. **Single Host**: All services on one machine
2. **No Auto-scaling**: Fixed container count
3. **No Load Balancing**: Single instance per service
4. **Limited HA**: No automatic failover
5. **Resource Constraints**: Shared host resources

### Scaling Strategies

#### Vertical Scaling (Easier)

```yaml
# Increase resources per service
services:
  nexus:
    deploy:
      resources:
        limits:
          cpus: '4.0'      # Increase from 2.0
          memory: 2G       # Increase from 768M
```

#### Horizontal Scaling (Limited in Docker Compose)

```bash
# Scale stateless services
docker-compose up -d --scale nexus=3

# Requires:
# - Load balancer (nginx/HAProxy)
# - Shared cache (Redis)
# - External database
```

### Migration to Production (Kubernetes)

For production scale, migrate to Kubernetes/Helm:

```
Docker Compose → Kubernetes Migration
─────────────────────────────────────
✓ Same container images
✓ Same environment variables
✓ Same service architecture
+ Auto-scaling (HPA)
+ Load balancing (Service/Ingress)
+ Health monitoring
+ Rolling updates
+ Resource quotas
+ Persistent volumes (PVC)
```

See: https://github.com/roman1887/helm-charts

---

## Monitoring and Observability

### Health Checks

```yaml
# All services include health checks
healthcheck:
  test: ["CMD-SHELL", "curl -f http://localhost:8000/health"]
  interval: 30s
  timeout: 10s
  retries: 5
  start_period: 60s
```

### Log Aggregation

```bash
# View all logs
docker-compose logs -f

# View specific service
docker-compose logs -f nexus

# Search logs
docker-compose logs | grep ERROR
```

### Metrics (Future)

- Prometheus for metrics collection
- Grafana for visualization
- Alert Manager for notifications

---

## Deployment Models

### Local Development

```
[Developer Laptop]
  └── Docker Desktop
      └── Docker Compose
          ├── All services local
          ├── Hot reloading enabled
          ├── Debug mode on
          └── Sample data included
```

### Staging/Testing

```
[Cloud VM / Dedicated Server]
  └── Docker Engine
      └── Docker Compose
          ├── Production-like config
          ├── External LLM
          ├── External databases (optional)
          └── SSL/TLS enabled
```

### Production

```
[Kubernetes Cluster]
  └── Helm Charts
      ├── Multiple replicas
      ├── Auto-scaling
      ├── Load balancing
      ├── Managed databases
      ├── Monitoring stack
      └── Backup solutions
```

---

For more information, see:
- [README.md](./README.md) - Getting started
- [CONFIGURATION.md](./CONFIGURATION.md) - Advanced configuration
- [DEPLOYMENT.md](./DEPLOYMENT.md) - Deployment guide
