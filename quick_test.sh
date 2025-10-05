#!/bin/bash

# Quick API Endpoint Finder
# Simplified version that just tests the most common endpoints

if [ -z "$1" ]; then
    echo "Usage: ./quick_test.sh YOUR_API_KEY"
    exit 1
fi

API_KEY="$1"

echo "🔍 Testing Adsterra API Endpoints (v3 API)..."
echo ""

# Test most likely endpoints based on docs.adsterratools.com/public/v3/publishers-api
echo "1. Testing v3 endpoint with version path..."
curl -s -o /tmp/response1.txt -w "%{http_code}" \
    "https://api3.adsterratools.com/v3/publisher/profile.json" \
    -H "X-API-Key: $API_KEY" \
    -H "Accept: application/json" > /tmp/status1.txt

status1=$(cat /tmp/status1.txt)
if [ "$status1" = "200" ]; then
    echo "   ✅ v3 endpoint works!"
    echo ""
    echo "   📝 Update line 14 in AdsterraAPIService.swift to:"
    echo "   private let baseURL = \"https://api3.adsterratools.com/v3/publisher\""
    echo ""
    cat /tmp/response1.txt | jq '.' 2>/dev/null || cat /tmp/response1.txt
    exit 0
else
    echo "   ❌ Failed with status: $status1"
fi

echo ""
echo "2. Testing original endpoint (without version path)..."
curl -s -o /tmp/response2.txt -w "%{http_code}" \
    "https://api3.adsterratools.com/publisher/profile.json" \
    -H "X-API-Key: $API_KEY" \
    -H "Accept: application/json" > /tmp/status2.txt

status2=$(cat /tmp/status2.txt)
if [ "$status2" = "200" ]; then
    echo "   ✅ This endpoint works!"
    echo ""
    echo "   📝 Update line 14 in AdsterraAPIService.swift to:"
    echo "   private let baseURL = \"https://publishers.adsterra.com/api/v2/publisher\""
    echo ""
    cat /tmp/response2.txt | jq '.' 2>/dev/null || cat /tmp/response2.txt
    exit 0
else
    echo "   ❌ Failed with status: $status2"
fi

echo ""
echo "3. Testing alternative v3 endpoint..."
curl -s -o /tmp/response3.txt -w "%{http_code}" \
    "https://api3.adsterratools.com/v3/publisher/profile.json" \
    -H "X-API-Key: $API_KEY" \
    -H "Accept: application/json" > /tmp/status3.txt

status3=$(cat /tmp/status3.txt)
if [ "$status3" = "200" ]; then
    echo "   ✅ This endpoint works!"
    echo ""
    echo "   📝 Update line 14 in AdsterraAPIService.swift to:"
    echo "   private let baseURL = \"https://api3.adsterratools.com/v3/publisher\""
    echo ""
    cat /tmp/response3.txt | jq '.' 2>/dev/null || cat /tmp/response3.txt
    exit 0
else
    echo "   ❌ Failed with status: $status3"
fi

echo ""
echo "❌ None of the common endpoints worked."
echo ""
echo "Next steps:"
echo "1. Check your Adsterra dashboard for API documentation"
echo "2. Verify your API key is correct"
echo "3. Run ./test_api.sh for more comprehensive testing"
echo "4. Contact Adsterra support"

# Cleanup
rm -f /tmp/response*.txt /tmp/status*.txt
