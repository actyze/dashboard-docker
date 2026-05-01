# Release prep commands — actyze/dashboard-docker

Run these after the polish PR is merged. Each is reversible.

```bash
# Set repo description (currently empty on github.com)
gh repo edit actyze/dashboard-docker \
  --description "Docker Compose deployment for Actyze — open-source self-hosted AI analytics. NL→SQL, federated queries via Trino, ML predictions, voice. AGPL v3."

# Set homepage
gh repo edit actyze/dashboard-docker --homepage "https://docs.actyze.io"

# Add GitHub topics (currently empty — kills discovery)
gh repo edit actyze/dashboard-docker \
  --add-topic docker \
  --add-topic docker-compose \
  --add-topic actyze \
  --add-topic ai-analytics \
  --add-topic self-hosted \
  --add-topic trino \
  --add-topic federated-query \
  --add-topic nl2sql \
  --add-topic text-to-sql \
  --add-topic llm \
  --add-topic agpl \
  --add-topic business-intelligence
```

## Notes

- Topics drive GitHub search visibility — empty topics = invisible to anyone browsing Docker or self-hosted analytics tags.
- Coordinate version pinning with `actyze/dashboard` releases. When `dashboard` tags v0.1.0, this repo should tag a compatible version so users can pin their compose file to a known-good combination.
- The Docker Pulls badge in the README assumes `actyze/dashboard-nexus` is published to Docker Hub. If the canonical image name differs, update the shields.io URL accordingly.
