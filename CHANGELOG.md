# Changelog

All notable changes to the Actyze Dashboard Docker Compose setup will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2026-02-03

### Added

#### Core Features
- Complete Docker Compose setup for local development
- Support for all major LLM providers (Anthropic, OpenAI, Perplexity, Groq, Together AI, Azure OpenAI)
- Flexible deployment profiles (local, external, postgres-only, trino-only)
- FAISS-based schema service for intelligent table recommendations
- PostgreSQL database with demo data and TPC-H sample datasets
- Trino query engine with multi-source support
- Modern React frontend with Material-UI and dark mode

#### Documentation
- Comprehensive README.md with getting started guide
- DEPLOYMENT.md with detailed deployment instructions
- CONFIGURATION.md for advanced configuration options
- ARCHITECTURE.md explaining system design
- LLM_PROVIDERS.md with provider-specific configuration
- CONTRIBUTING.md with contribution guidelines
- QUICK_START.md for 5-minute setup
- CHANGELOG.md (this file)

#### Scripts
- `start.sh` - Start services with flexible options
- `stop.sh` - Stop services with optional cleanup
- `test.sh` - Automated testing script
- Helper scripts for service management

#### Configuration
- Environment variable template (env.example)
- Docker Compose configuration with profiles
- Trino catalogs for PostgreSQL, MongoDB, Snowflake
- Health checks for all services
- Resource limits and reservations

#### Infrastructure
- Docker network isolation
- Volume management for data persistence
- Service discovery via Docker DNS
- Health monitoring endpoints

### Security
- Environment-based secret management
- JWT authentication in Nexus API
- Password hashing with bcrypt
- SQL injection prevention
- Network isolation between services

### Performance
- Query result caching
- Connection pooling for databases
- Resource limits per service
- Optimized Docker image builds

---

## [1.1.0] - 2026-03-03

### Added

#### Preferred Tables Feature
- Users can mark individual tables as **preferred** to guide the AI during SQL generation
- Preferred tables are sent to the LLM with full column metadata and descriptions (★ starred in prompt)
- Bulk preferred mode: select and mark/unmark multiple tables at once in Schema Optimize UI
- Preferred tables display with ⭐ star icon in the Query page schema sidebar
- `MAX_PREFERRED_TABLES` environment variable controls per-user limit (default: **25**, configurable in `docker-compose.yml`)
- **Token budget awareness**: increasing `MAX_PREFERRED_TABLES` injects more context into the LLM prompt; adjust `EXTERNAL_LLM_MAX_TOKENS` accordingly (see CONFIGURATION.md)
- Hidden tables cannot be marked as preferred; hiding a preferred table automatically removes its preferred status

#### Performance Improvements
- Schema service `/table/metadata` endpoint now reads from in-memory cache instead of querying Trino live — marking tables as preferred is now near-instant
- Bulk preferred operations use a single API call instead of one call per table

### Changed

- Replaced "boost" (weight-based table scoring) with "preferred tables" (explicit user-curated table list)
- Database migration V029 automatically runs on startup: migrates any existing boost entries to preferred, removes deprecated `boost_weight` and `preferred_columns` columns
- LLM prompt updated: preferred tables section appears before schema recommendations with full column context

### Removed

- Removed `boost_weight` and `preferred_columns` concepts — replaced entirely by preferred tables

---

## [Unreleased]

### Planned Features
- Redis integration for distributed caching
- Prometheus metrics collection
- Grafana dashboards for monitoring
- Alert manager configuration
- Automated backup scripts
- CI/CD pipeline examples
- Multi-stage Docker builds for smaller images
- ARM64 support for Apple Silicon

---

## Release Notes

### Version 1.0.0

This is the initial release of the Actyze Dashboard Docker Compose setup.

**Key Highlights:**
- Production-ready local development environment
- Support for any LLM provider
- Flexible deployment options
- Comprehensive documentation
- Automated testing

**Known Limitations:**
- Single-host deployment only (no clustering)
- No automatic service scaling
- Manual secret management (use Kubernetes for production)

**Migration Path:**
For production deployments, migrate to Kubernetes using our Helm charts:
https://github.com/roman1887/helm-charts

---

## Versioning

We use [Semantic Versioning](https://semver.org/) for version numbers:

- **MAJOR** version: Incompatible API changes or breaking changes
- **MINOR** version: New features in a backwards-compatible manner
- **PATCH** version: Backwards-compatible bug fixes

---

## Support

For questions or issues:
- GitHub Issues: https://github.com/roman1887/dashboard-docker/issues
- Discussions: https://github.com/roman1887/dashboard-docker/discussions
