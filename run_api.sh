#!/bin/bash

# 1. Load variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -d '\n')
else
    echo "ERROR: .env file not found. Please create one based on .env.example"
    exit 1
fi

# 2. Configuration (Using variables from .env)
API_KEY="$POSTMAN_API_KEY"
COLLECTION_ID="$POSTMAN_COLLECTION_ID"
ENV_ID="$POSTMAN_ENV_ID"

REPORT_DIR="./reports" # Use relative path for GitHub compatibility
REPORT_NAME="Grocery_Store_Contract_Tests"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 3. Logic
mkdir -p "$REPORT_DIR"
FINAL_REPORT_PATH="$REPORT_DIR/${REPORT_NAME}_${TIMESTAMP}.html"

COLLECTION_URL="https://api.getpostman.com/collections/$COLLECTION_ID?apikey=$API_KEY"
ENV_URL="https://api.getpostman.com/environments/$ENV_ID?apikey=$API_KEY"

echo "Starting Newman Execution..."

newman run "$COLLECTION_URL" \
    -e "$ENV_URL" \
    -r cli,htmlextra \
    --reporter-htmlextra-export "$FINAL_REPORT_PATH" \
    --reporter-htmlextra-title "Automated API Test Report: $REPORT_NAME"