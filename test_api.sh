#!/bin/bash

# Adsterra API Endpoint Tester
# This script helps you find the correct API endpoint for your Adsterra account

echo "🔍 Adsterra API Endpoint Tester"
echo "================================"
echo ""

# Check if API key is provided
if [ -z "$1" ]; then
    echo "Usage: ./test_api.sh YOUR_API_KEY"
    echo ""
    echo "Example:"
    echo "  ./test_api.sh abc123def456"
    exit 1
fi

API_KEY="$1"

echo "Testing various Adsterra API endpoints..."
echo ""

# Array of base URLs to test
declare -a BASE_URLS=(
    "https://api3.adsterratools.com/publisher"
    "https://publishers.adsterra.com/api/v2/publisher"
    "https://api.adsterratools.com/publisher/v1"
    "https://api3.adsterratools.com/v3/publisher"
    "https://api3.adsterratools.com"
    "https://publishers.adsterra.com/api/publisher"
)

# Array of endpoint paths to test
declare -a ENDPOINTS=(
    "/profile.json"
    "/profile"
    ""
)

# Test each combination
for base_url in "${BASE_URLS[@]}"; do
    for endpoint in "${ENDPOINTS[@]}"; do
        full_url="${base_url}${endpoint}"
        
        echo -n "Testing: $full_url ... "
        
        # Make the request and capture status code
        http_code=$(curl -s -o /dev/null -w "%{http_code}" \
            -X GET "$full_url" \
            -H "X-API-Key: $API_KEY" \
            -H "Accept: application/json" \
            --connect-timeout 5)
        
        # Check the result
        case $http_code in
            200)
                echo "✅ SUCCESS! This endpoint works!"
                echo ""
                echo "🎯 Found working endpoint:"
                echo "   Base URL: $base_url"
                if [ -n "$endpoint" ]; then
                    echo "   Endpoint: $endpoint"
                fi
                echo ""
                echo "Response:"
                curl -s -X GET "$full_url" \
                    -H "X-API-Key: $API_KEY" \
                    -H "Accept: application/json" | jq '.' 2>/dev/null || cat
                echo ""
                echo "---"
                echo "Update AdsterraAPIService.swift line 14 to:"
                echo "private let baseURL = \"$base_url\""
                echo "---"
                ;;
            401)
                echo "🔐 401 Unauthorized (API key may be incorrect)"
                ;;
            403)
                echo "🚫 403 Forbidden (API key may be expired)"
                ;;
            404)
                echo "❌ 404 Not Found"
                ;;
            000)
                echo "⏱️  Timeout or connection error"
                ;;
            *)
                echo "❓ HTTP $http_code"
                ;;
        esac
    done
done

echo ""
echo "Testing complete!"
echo ""
echo "If none of the endpoints worked:"
echo "1. Check your Adsterra dashboard for API documentation"
echo "2. Verify your API key is correct and has the right permissions"
echo "3. Contact Adsterra support for the correct API endpoint URL"
