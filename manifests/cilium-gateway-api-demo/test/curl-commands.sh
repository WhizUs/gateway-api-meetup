#!/bin/bash

# Test normal traffic split
echo "Testing normal traffic split..."
count_v1=0
count_v2=0
total=100

for i in $(seq 1 $total); do
    response=$(curl -s -H "Host: demo.example.com" http://localhost:30080)
    if [[ $response == *"App-V1"* ]]; then
        ((count_v1++))
    elif [[ $response == *"App-V2"* ]]; then
        ((count_v2++))
    fi
done

echo "App-V1 responses: $count_v1"
echo "App-V2 responses: $count_v2"

# Test canary header routing
# echo "Testing canary header routing..."
# curl -H "Host: demo.example.com" -H "X-Canary: true" http://localhost:30080

# Test echo header routing
# echo "Testing echo header routing..."
# curl -H "Host: demo.example.com" -H "X-Echo: true" http://localhost:30080 | jq