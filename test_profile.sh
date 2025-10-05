#!/bin/bash

# Test Adsterra Profile Endpoint
# This will help us understand what data the profile endpoint returns

if [ -z "$1" ]; then
    echo "Usage: ./test_profile.sh YOUR_API_KEY"
    exit 1
fi

API_KEY="$1"
BASE_URL="https://api3.adsterratools.com/publisher"

echo "🔍 Testing Adsterra Profile Endpoint..."
echo ""

echo "1. Testing /profile.json endpoint..."
echo "   URL: ${BASE_URL}/profile.json"
echo ""

response=$(curl -s -w "\n%{http_code}" \
    -X GET "${BASE_URL}/profile.json" \
    -H "X-API-Key: ${API_KEY}" \
    -H "Accept: application/json")

http_code=$(echo "$response" | tail -n 1)
body=$(echo "$response" | sed '$d')

echo "   Status: $http_code"
echo "   Response:"
echo "$body" | jq '.' 2>/dev/null || echo "$body"
echo ""

if [ "$http_code" = "200" ]; then
    echo "✅ Profile endpoint exists!"
    echo ""
    echo "Extracting balance information..."
    balance=$(echo "$body" | jq -r '.items[0].balance // .data.balance // .balance // "not found"' 2>/dev/null)
    currency=$(echo "$body" | jq -r '.items[0].currency // .data.currency // .currency // "not found"' 2>/dev/null)
    
    echo "   Balance: $balance"
    echo "   Currency: $currency"
    echo ""
    
    if [ "$balance" != "not found" ] && [ "$balance" != "null" ]; then
        echo "✅ Balance field found in response!"
        echo "   The app should be using this value: $currency $balance"
    else
        echo "❌ Balance field NOT found in response"
        echo "   This explains why the app shows incorrect balance"
    fi
elif [ "$http_code" = "404" ]; then
    echo "❌ Profile endpoint does NOT exist (404)"
    echo ""
    echo "This means:"
    echo "- The API v3 doesn't have a profile/balance endpoint"
    echo "- Balance cannot be fetched via API"
    echo "- The app will show period revenue instead of actual balance"
    echo ""
    echo "Solution: Update app to show 'Period Revenue' instead of 'Balance'"
elif [ "$http_code" = "401" ]; then
    echo "🔐 401 Unauthorized - Check your API key"
elif [ "$http_code" = "403" ]; then
    echo "🚫 403 Forbidden - API key may be expired"
else
    echo "❓ Unexpected response: HTTP $http_code"
fi

echo ""
echo "---"
echo "For comparison, let's check stats endpoint:"
echo ""

stats_response=$(curl -s -w "\n%{http_code}" \
    -X GET "${BASE_URL}/stats.json?start_date=2025-09-27&finish_date=2025-10-04&group_by[]=date" \
    -H "X-API-Key: ${API_KEY}" \
    -H "Accept: application/json")

stats_http_code=$(echo "$stats_response" | tail -n 1)
stats_body=$(echo "$stats_response" | sed '$d')

echo "Stats endpoint status: $stats_http_code"

if [ "$stats_http_code" = "200" ]; then
    echo "✅ Stats endpoint works"
    total_revenue=$(echo "$stats_body" | jq '[.items[].revenue] | add' 2>/dev/null)
    echo "   Total 7-day revenue: \$$total_revenue"
    echo ""
    echo "This is what the app currently shows as 'Balance' when profile is unavailable."
fi

echo ""
echo "---"
echo "RECOMMENDATION:"
echo ""
if [ "$http_code" = "200" ]; then
    echo "✅ Use the profile endpoint for accurate balance"
    echo "   Make sure ProfileData model matches the response structure"
else
    echo "⚠️  Since profile endpoint doesn't exist:"
    echo "   1. Change 'Balance' label to 'Period Revenue' or 'Earned (7 days)'"
    echo "   2. Add note: 'For full balance, check Adsterra dashboard'"
    echo "   3. Or: Add manual balance input in settings"
fi
