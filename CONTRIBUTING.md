# Contributing to Actyze Dashboard Docker

Thank you for your interest in contributing to the Actyze Dashboard Docker Compose setup! This document provides guidelines for contributing.

---

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)

---

## Code of Conduct

We are committed to providing a welcoming and inspiring community for all. Please read and follow our Code of Conduct:

- **Be respectful** of differing viewpoints and experiences
- **Accept constructive criticism** gracefully
- **Focus on what is best** for the community
- **Show empathy** towards other community members

---

## Getting Started

### Prerequisites

- Docker Desktop 20.10+ or Docker Engine 20.10+
- Docker Compose 2.0+
- Git
- Basic understanding of Docker, Docker Compose, and microservices

### Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR-USERNAME/dashboard-docker.git
cd dashboard-docker

# Add upstream remote
git remote add upstream https://github.com/roman1887/dashboard-docker.git
```

### Set Up Development Environment

```bash
# Copy environment template
cp env.example .env

# Edit with your configuration
nano .env

# Start services
./start.sh

# Verify everything works
docker-compose ps
```

---

## How to Contribute

### Types of Contributions

We welcome various types of contributions:

1. **Bug Reports**: Found a bug? Open an issue!
2. **Feature Requests**: Have an idea? Suggest it!
3. **Documentation**: Improve or add documentation
4. **Code**: Fix bugs or implement features
5. **Testing**: Add or improve tests
6. **Examples**: Add configuration examples

### Reporting Bugs

When reporting bugs, please include:

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce the behavior:
1. Run command '...'
2. Access '....'
3. See error

**Expected behavior**
What you expected to happen.

**Environment**
- OS: [e.g., macOS 12.0]
- Docker version: [e.g., 20.10.12]
- Docker Compose version: [e.g., 2.2.3]

**Logs**
```
Paste relevant logs here
```

**Additional context**
Any other relevant information.
```

### Suggesting Features

When suggesting features, please include:

- **Use case**: What problem does this solve?
- **Proposed solution**: How should it work?
- **Alternatives**: What alternatives have you considered?
- **Impact**: Who would benefit from this?

---

## Development Workflow

### 1. Create a Branch

```bash
# Update your fork
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

### 2. Make Changes

```bash
# Edit files
# Test your changes
./start.sh

# Check logs
docker-compose logs -f

# Run tests (if applicable)
./test.sh
```

### 3. Commit Changes

```bash
# Stage changes
git add .

# Commit with descriptive message
git commit -m "feat: add support for X"
# or
git commit -m "fix: resolve issue with Y"
```

**Commit Message Format**:
```
<type>: <subject>

<body>

<footer>
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples**:
```
feat: add Redis caching support

Implements Redis as an optional caching layer for query results.
Configuration via REDIS_HOST and REDIS_PORT environment variables.

Closes #123
```

```
fix: correct PostgreSQL connection string

The POSTGRES_HOST variable was not being interpolated correctly
in the Trino catalog configuration.

Fixes #456
```

### 4. Push Changes

```bash
# Push to your fork
git push origin feature/your-feature-name
```

---

## Pull Request Process

### Before Submitting

- [ ] Test your changes locally
- [ ] Update documentation if needed
- [ ] Add/update tests if applicable
- [ ] Ensure all services start successfully
- [ ] Check logs for errors
- [ ] Update CHANGELOG.md if significant change

### Submitting PR

1. Go to GitHub and create a Pull Request
2. Fill out the PR template:

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update
- [ ] Configuration change

## Testing
How to test these changes:
1. Step 1
2. Step 2

## Checklist
- [ ] Tested locally
- [ ] Documentation updated
- [ ] No breaking changes
- [ ] Services start successfully
```

3. Wait for review
4. Address feedback if any
5. Wait for approval and merge

### PR Review Process

- Maintainers will review your PR
- May request changes or improvements
- Once approved, will be merged
- Your contribution will be credited!

---

## Coding Standards

### Docker Compose

```yaml
# Use consistent formatting
services:
  service-name:
    image: image:tag
    container_name: dashboard-service-name
    environment:
      - VAR_NAME=${VAR_NAME:-default}
    ports:
      - "host:container"
    volumes:
      - volume:/path
    networks:
      - dashboard
    restart: unless-stopped
```

### Environment Variables

```bash
# Use clear, descriptive names
# Group related variables
# Provide defaults where sensible
# Document in env.example

# Good
POSTGRES_HOST=postgres
POSTGRES_PORT=5432

# Bad
PH=postgres
PP=5432
```

### Shell Scripts

```bash
#!/bin/bash

# Use strict mode
set -e

# Clear comments
# Descriptive variable names
# Error handling

# Good
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    exit 1
fi

# Bad
sd=$(dirname $0)
[ -f .env ] || exit 1
```

### Documentation

- Use clear, concise language
- Provide examples
- Include command outputs
- Use proper markdown formatting
- Keep README.md updated

---

## Testing Guidelines

### Manual Testing

```bash
# Start services
./start.sh

# Check service health
docker-compose ps

# Test frontend
open http://localhost:3000

# Test API
curl http://localhost:8000/health

# Check logs
docker-compose logs -f
```

### Testing Checklist

- [ ] All services start successfully
- [ ] Health checks pass
- [ ] Frontend loads correctly
- [ ] API endpoints respond
- [ ] Authentication works
- [ ] Query generation works (if LLM key configured)
- [ ] Database connection works
- [ ] Logs show no errors
- [ ] Stop/start cycle works
- [ ] Clean restart works (`./stop.sh --clean && ./start.sh`)

### Configuration Testing

Test different configurations:

```bash
# Test with local databases
./start.sh --profile local

# Test with external databases
# (configure external DBs in .env first)
./start.sh --profile external

# Test without building
./start.sh --no-build
```

---

## Documentation Contributions

### Documentation Structure

```
dashboard-docker/
├── README.md              # Main documentation
├── DEPLOYMENT.md          # Deployment guide
├── CONFIGURATION.md       # Advanced configuration
├── ARCHITECTURE.md        # Architecture overview
├── LLM_PROVIDERS.md       # LLM provider setup
├── CONTRIBUTING.md        # This file
└── examples/              # Configuration examples
```

### Writing Documentation

1. **Be clear and concise**
   - Use simple language
   - Avoid jargon
   - Explain acronyms

2. **Provide examples**
   - Show command outputs
   - Include code snippets
   - Demonstrate use cases

3. **Keep it updated**
   - Update when making changes
   - Remove outdated information
   - Add deprecation notices

4. **Use proper formatting**
   ```markdown
   # H1 for main title
   ## H2 for sections
   ### H3 for subsections
   
   `code` for inline code
   
   ```bash
   # Code blocks for commands
   ```
   
   **bold** for emphasis
   *italic* for terms
   [links](url) for references
   ```

---

## Questions?

- **Issues**: https://github.com/roman1887/dashboard-docker/issues
- **Discussions**: https://github.com/roman1887/dashboard-docker/discussions
- **Email**: support@actyze.com (for private concerns)

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (MIT License).

---

**Thank you for contributing to Actyze Dashboard!** 🎉
