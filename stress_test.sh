#!/bin/bash

# Stress Test Script for HelloZig HTTP Server
# Uses Apache Bench (ab) to test the /hello endpoint

echo "======================================"
echo "HelloZig HTTP Server Stress Test"
echo "======================================"
echo ""

# Check if server is running
if ! curl -s http://127.0.0.1:8080/hello >/dev/null 2>&1; then
  echo "Error: Server is not running on port 8080"
  echo "Please start the server first: ./zig-out/bin/hellozig"
  exit 1
fi

echo "Server is running. Starting stress tests..."
echo ""

# Test 1: Light load
echo "Test 1: Light Load (1,000 requests, 10 concurrent)"
echo "------------------------------------------------"
ab -n 1000 -c 10 http://127.0.0.1:8080/hello
echo ""
sleep 1

# Test 2: Medium load
echo "Test 2: Medium Load (10,000 requests, 100 concurrent)"
echo "------------------------------------------------------"
ab -n 10000 -c 100 http://127.0.0.1:8080/hello
echo ""
sleep 1

# Test 3: Heavy load
echo "Test 3: Heavy Load (50,000 requests, 500 concurrent, keep-alive)"
echo "----------------------------------------------------------------"
ab -n 50000 -c 500 -k http://127.0.0.1:8080/hello
echo ""
sleep 1

# Test 4: Extreme load
echo "Test 4: Extreme Load (100,000 requests, 1000 concurrent, keep-alive)"
echo "--------------------------------------------------------------------"
ab -n 100000 -c 1000 -k http://127.0.0.1:8080/hello
echo ""

echo "======================================"
echo "All tests completed!"
echo "======================================"
