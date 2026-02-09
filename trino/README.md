# Trino Configuration Guide

Configure Trino to connect to your databases. Trino is the query engine that connects Actyze to your data sources.

---

## What is Trino?

Trino is a distributed SQL query engine that connects to multiple data sources. It allows Actyze to query:
- Relational databases (PostgreSQL, MySQL, SQL Server)
- Cloud warehouses (Snowflake, BigQuery, Redshift)
- NoSQL databases (MongoDB, Cassandra)
- Data lakes (Iceberg, Delta Lake, Hive)

---

## Default Catalogs

Actyze comes with these catalogs enabled by default:

- **postgres** - Connects to local PostgreSQL database
- **memory** - Temporary in-memory tables for testing
- **tpch** - Sample dataset for testing queries

No additional configuration needed to get started!

---

## Adding Your Data Sources

### Step 1: Choose Your Connector

Trino supports 50+ data sources. Common examples:

**Relational Databases:**
- PostgreSQL
- MySQL
- SQL Server
- Oracle
- MariaDB

**Cloud Data Warehouses:**
- Snowflake
- Google BigQuery
- Amazon Redshift
- Databricks

**NoSQL:**
- MongoDB
- Cassandra
- Elasticsearch

**Data Lakes:**
- Apache Iceberg
- Delta Lake
- Apache Hudi
- Hive

### Step 2: Create Catalog Template

Copy the example template for your data source:

\`\`\`bash
# Example: Add MySQL
cp trino/catalog-templates/examples/mysql.properties.tpl.example \\
   trino/catalog-templates/mysql.properties.tpl
\`\`\`

### Step 3: Configure in \`.env\`

Add connection details to your \`.env\` file:

**PostgreSQL Example:**
\`\`\`bash
# PostgreSQL catalog name: production_db
POSTGRES_PRODUCTION_HOST=db.yourcompany.com
POSTGRES_PRODUCTION_PORT=5432
POSTGRES_PRODUCTION_DB=production
POSTGRES_PRODUCTION_USER=analytics_user
POSTGRES_PRODUCTION_PASSWORD=your-password
\`\`\`

**MySQL Example:**
\`\`\`bash
# MySQL catalog name: sales_db
MYSQL_HOST=mysql.yourcompany.com
MYSQL_PORT=3306
MYSQL_DB=sales
MYSQL_USER=analytics_user
MYSQL_PASSWORD=your-password
\`\`\`

**Snowflake Example:**
\`\`\`bash
# Snowflake catalog name: warehouse
SNOWFLAKE_ACCOUNT=your-account.snowflakecomputing.com
SNOWFLAKE_USER=analytics_user
SNOWFLAKE_PASSWORD=your-password
SNOWFLAKE_DATABASE=ANALYTICS
SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_ROLE=ANALYTICS_ROLE
\`\`\`

**MongoDB Example:**
\`\`\`bash
# MongoDB catalog name: events
MONGODB_CONNECTION_URL=mongodb://mongo.yourcompany.com:27017
MONGODB_USER=analytics_user
MONGODB_PASSWORD=your-password
MONGODB_DATABASE=events
\`\`\`

### Step 4: Restart Trino

\`\`\`bash
docker-compose restart trino
\`\`\`

---

## Catalog Templates

### File Structure

\`\`\`
trino/
├── catalog-templates/          # Active catalogs
│   ├── postgres.properties.tpl # Local PostgreSQL
│   ├── memory.properties.tpl   # Memory catalog
│   ├── tpch.properties.tpl     # Sample data
│   └── examples/               # Template examples
│       ├── mysql.properties.tpl.example
│       ├── snowflake.properties.tpl.example
│       ├── mongodb.properties.tpl.example
│       └── ... (50+ connectors)
\`\`\`

### How It Works

1. **Templates** (\`.tpl\` files) use environment variable placeholders
2. **Docker** automatically substitutes variables from \`.env\`
3. **Trino** loads the final catalog configurations on startup

Example template:
\`\`\`properties
connector.name=postgresql
connection-url=jdbc:postgresql://\${POSTGRES_HOST}:\${POSTGRES_PORT}/\${POSTGRES_DB}
connection-user=\${POSTGRES_USER}
connection-password=\${POSTGRES_PASSWORD}
\`\`\`

---

## Complete Configuration Examples

### PostgreSQL

**1. Create template:**
\`\`\`bash
cat > trino/catalog-templates/production.properties.tpl << 'EOF'
connector.name=postgresql
connection-url=jdbc:postgresql://\${POSTGRES_PRODUCTION_HOST}:\${POSTGRES_PRODUCTION_PORT}/\${POSTGRES_PRODUCTION_DB}
connection-user=\${POSTGRES_PRODUCTION_USER}
connection-password=\${POSTGRES_PRODUCTION_PASSWORD}
EOF
\`\`\`

**2. Add to \`.env\`:**
\`\`\`bash
POSTGRES_PRODUCTION_HOST=db.yourcompany.com
POSTGRES_PRODUCTION_PORT=5432
POSTGRES_PRODUCTION_DB=production
POSTGRES_PRODUCTION_USER=analytics
POSTGRES_PRODUCTION_PASSWORD=secure-password
\`\`\`

**3. Restart:**
\`\`\`bash
docker-compose restart trino
\`\`\`

**4. Query:**
\`\`\`sql
SELECT * FROM production.public.customers LIMIT 10;
\`\`\`

### MySQL

**1. Copy example:**
\`\`\`bash
cp trino/catalog-templates/examples/mysql.properties.tpl.example \\
   trino/catalog-templates/mysql.properties.tpl
\`\`\`

**2. Add to \`.env\`:**
\`\`\`bash
MYSQL_HOST=mysql.yourcompany.com
MYSQL_PORT=3306
MYSQL_DB=sales
MYSQL_USER=analytics
MYSQL_PASSWORD=secure-password
\`\`\`

**3. Restart:**
\`\`\`bash
docker-compose restart trino
\`\`\`

**4. Query:**
\`\`\`sql
SELECT * FROM mysql.sales.orders LIMIT 10;
\`\`\`

### Snowflake

**1. Copy example:**
\`\`\`bash
cp trino/catalog-templates/examples/snowflake.properties.tpl.example \\
   trino/catalog-templates/snowflake.properties.tpl
\`\`\`

**2. Add to \`.env\`:**
\`\`\`bash
SNOWFLAKE_ACCOUNT=your-account
SNOWFLAKE_USER=analytics_user
SNOWFLAKE_PASSWORD=secure-password
SNOWFLAKE_DATABASE=ANALYTICS
SNOWFLAKE_WAREHOUSE=COMPUTE_WH
SNOWFLAKE_ROLE=ANALYTICS_ROLE
\`\`\`

**3. Restart:**
\`\`\`bash
docker-compose restart trino
\`\`\`

**4. Query:**
\`\`\`sql
SELECT * FROM snowflake.analytics.sales LIMIT 10;
\`\`\`

### MongoDB

**1. Copy example:**
\`\`\`bash
cp trino/catalog-templates/examples/mongodb.properties.tpl.example \\
   trino/catalog-templates/mongodb.properties.tpl
\`\`\`

**2. Add to \`.env\`:**
\`\`\`bash
MONGODB_CONNECTION_URL=mongodb://mongo.yourcompany.com:27017
MONGODB_USER=analytics
MONGODB_PASSWORD=secure-password
MONGODB_DATABASE=events
\`\`\`

**3. Restart:**
\`\`\`bash
docker-compose restart trino
\`\`\`

**4. Query:**
\`\`\`sql
SELECT * FROM mongodb.events.user_events LIMIT 10;
\`\`\`

---

## Testing Your Connection

### Verify Catalog is Loaded

\`\`\`bash
# List all catalogs
docker exec dashboard-trino trino --execute "SHOW CATALOGS;"
\`\`\`

### List Schemas

\`\`\`bash
# Replace 'production' with your catalog name
docker exec dashboard-trino trino --execute "SHOW SCHEMAS IN production;"
\`\`\`

### List Tables

\`\`\`bash
# Replace catalog and schema
docker exec dashboard-trino trino --execute "SHOW TABLES IN production.public;"
\`\`\`

### Run Test Query

\`\`\`bash
# Test query
docker exec dashboard-trino trino --execute "SELECT COUNT(*) FROM production.public.customers;"
\`\`\`

---

## Troubleshooting

### Catalog Not Showing

**Check configuration:**
\`\`\`bash
# View generated catalog files
docker exec dashboard-trino ls -la /etc/trino/catalog/

# View catalog content
docker exec dashboard-trino cat /etc/trino/catalog/your-catalog.properties
\`\`\`

**Check Trino logs:**
\`\`\`bash
docker-compose logs trino
\`\`\`

### Connection Failed

**Verify credentials:**
\`\`\`bash
# Check environment variables
cat .env | grep YOUR_CATALOG
\`\`\`

**Test network connectivity:**
\`\`\`bash
# Test from Trino container
docker exec dashboard-trino ping your-database-host
\`\`\`

### Authentication Errors

**PostgreSQL:** Verify user has access from Trino's IP
**MySQL:** Check \`GRANT\` permissions for remote access
**Snowflake:** Verify role has warehouse access
**MongoDB:** Check user has \`read\` role on database

---

## Available Connectors

Trino supports 50+ data sources. See the \`trino/catalog-templates/examples/\` directory for templates:

**Relational:**
- PostgreSQL, MySQL, SQL Server, Oracle, MariaDB

**Cloud Warehouses:**
- Snowflake, BigQuery, Redshift, Databricks, Synapse

**NoSQL:**
- MongoDB, Cassandra, Elasticsearch, Redis

**Data Lakes:**
- Iceberg, Delta Lake, Hudi, Hive

**SaaS:**
- Salesforce, Google Sheets, Airtable

**Object Storage:**
- S3, Google Cloud Storage, Azure Blob Storage

**And many more...**

---

## Best Practices

1. **Use read-only users** - Create dedicated analytics users with read-only access
2. **Secure passwords** - Never commit \`.env\` with credentials
3. **Test connectivity** - Verify connection before adding to Actyze
4. **Monitor performance** - Check query performance in Trino logs
5. **Use connection pooling** - Enabled by default in Trino connectors

---

## Support

**Documentation:**
- Complete Connector List: https://trino.io/docs/current/connector.html
- Actyze Documentation: https://docs.actyze.io
- Configuration Guide: [../CONFIGURATION.md](../CONFIGURATION.md)

**Support:**
- GitHub Issues: https://github.com/actyze/dashboard-docker/issues

---

**Connect Actyze to any data source. Query everything in one place.**
