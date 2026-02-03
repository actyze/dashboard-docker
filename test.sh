#!/bin/bash

# Dashboard Testing Script
# Tests the Docker Compose deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🧪 Testing Actyze Dashboard Docker Deployment"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counter
TESTS_PASSED=0
TESTS_FAILED=0

# Helper functions
test_passed() {
    echo -e "${GREEN}✓${NC} $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_failed() {
    echo -e "${RED}✗${NC} $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

test_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

# Test 1: Check if services are running
echo "1. Checking if services are running..."
if docker-compose ps | grep -q "Up"; then
    test_passed "Services are running"
else
    test_failed "Services are not running"
    echo "   Run './start.sh' to start services"
    exit 1
fi

# Test 2: Check service health
echo ""
echo "2. Checking service health..."

# Check Frontend
if curl -f -s http://localhost:3000 > /dev/null; then
    test_passed "Frontend is accessible (port 3000)"
else
    test_failed "Frontend is not accessible"
fi

# Check Nexus API
if curl -f -s http://localhost:8000/health > /dev/null; then
    test_passed "Nexus API is healthy (port 8000)"
else
    test_failed "Nexus API is not healthy"
fi

# Check Schema Service
if curl -f -s http://localhost:8001/health > /dev/null; then
    test_passed "Schema Service is healthy (port 8001)"
else
    test_warning "Schema Service is not accessible (may not be running)"
fi

# Check Trino
if curl -f -s http://localhost:8081/v1/info > /dev/null 2>&1; then
    test_passed "Trino is accessible (port 8081)"
else
    test_warning "Trino is not accessible (may not be running)"
fi

# Test 3: Check PostgreSQL connection
echo ""
echo "3. Checking PostgreSQL connection..."
if docker-compose exec -T postgres pg_isready > /dev/null 2>&1; then
    test_passed "PostgreSQL is ready"
else
    test_failed "PostgreSQL is not ready"
fi

# Test 4: Check authentication
echo ""
echo "4. Testing authentication..."
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8000/auth/login \
    -H "Content-Type: application/x-www-form-urlencoded" \
    -d "username=nexus_admin&password=admin")

if echo "$LOGIN_RESPONSE" | grep -q "access_token"; then
    test_passed "Authentication successful"
    TOKEN=$(echo "$LOGIN_RESPONSE" | grep -o '"access_token":"[^"]*' | cut -d'"' -f4)
else
    test_failed "Authentication failed"
    TOKEN=""
fi

# Test 5: Check API endpoints (if authenticated)
if [ -n "$TOKEN" ]; then
    echo ""
    echo "5. Testing API endpoints..."
    
    # Test health endpoint
    if curl -f -s -H "Authorization: Bearer $TOKEN" http://localhost:8000/health > /dev/null; then
        test_passed "Health endpoint accessible"
    else
        test_failed "Health endpoint not accessible"
    fi
    
    # Test user info endpoint
    if curl -f -s -H "Authorization: Bearer $TOKEN" http://localhost:8000/api/user/info > /dev/null; then
        test_passed "User info endpoint accessible"
    else
        test_warning "User info endpoint not accessible"
    fi
else
    test_warning "Skipping API endpoint tests (authentication failed)"
fi

# Test 6: Check logs for errors
echo ""
echo "6. Checking logs for critical errors..."
CRITICAL_ERRORS=$(docker-compose logs --tail=100 2>&1 | grep -i "error\|fatal\|exception" | grep -v "DEBUG" || true)

if [ -z "$CRITICAL_ERRORS" ]; then
    test_passed "No critical errors in logs"
else
    test_warning "Found potential errors in logs:"
    echo "$CRITICAL_ERRORS" | head -5
fi

# Test 7: Check resource usage
echo ""
echo "7. Checking resource usage..."
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}" | grep dashboard

# Test 8: Check volumes
echo ""
echo "8. Checking volumes..."
if docker volume ls | grep -q "dashboard-docker_postgres_data"; then
    test_passed "PostgreSQL volume exists"
else
    test_warning "PostgreSQL volume not found"
fi

if docker volume ls | grep -q "dashboard-docker_schema_models"; then
    test_passed "Schema models volume exists"
else
    test_warning "Schema models volume not found"
fi

# Summary
echo ""
echo "═══════════════════════════════════════"
echo "Test Summary"
echo "═══════════════════════════════════════"
echo -e "${GREEN}Passed:${NC} $TESTS_PASSED"
echo -e "${RED}Failed:${NC} $TESTS_FAILED"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}✓ All tests passed!${NC}"
    echo ""
    echo "🎉 Your deployment is working correctly!"
    echo ""
    echo "Access URLs:"
    echo "  Frontend:      http://localhost:3000"
    echo "  Nexus API:     http://localhost:8000"
    echo "  API Docs:      http://localhost:8000/docs"
    echo "  Schema Service: http://localhost:8001"
    exit 0
else
    echo -e "${RED}✗ Some tests failed${NC}"
    echo ""
    echo "Troubleshooting tips:"
    echo "1. Check service logs: docker-compose logs -f"
    echo "2. Verify .env configuration"
    echo "3. Try restarting: ./stop.sh && ./start.sh"
    echo "4. See DEPLOYMENT.md for detailed troubleshooting"
    exit 1
fi
