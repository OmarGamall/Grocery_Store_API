#!/bin/bash

# 1. Load variables from .env file
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs -d '\n')
else
    echo "ERROR: .env file not found. Please create one based on .env.example"
    exit 1
fi

# 2. Configuration
API_KEY="$POSTMAN_API_KEY"
COLLECTION_ID="$POSTMAN_COLLECTION_ID"
ENV_ID="$POSTMAN_ENV_ID"

# Directory Configuration
BASE_REPORT_DIR="./reports"
HTML_DIR="$BASE_REPORT_DIR/HTML_Report"
JUNIT_DIR="$BASE_REPORT_DIR/JUnit_Report"

REPORT_NAME="Grocery_Store_Contract_Tests"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# 3. Prepare Folders
mkdir -p "$HTML_DIR"
mkdir -p "$JUNIT_DIR"

# Define Final Paths
HTML_REPORT_PATH="$HTML_DIR/${REPORT_NAME}_${TIMESTAMP}.html"
JUNIT_REPORT_PATH="$JUNIT_DIR/${REPORT_NAME}_${TIMESTAMP}.xml"

# 4. Construct API URLs
COLLECTION_URL="https://api.getpostman.com/collections/$COLLECTION_ID?apikey=$API_KEY"
ENV_URL="https://api.getpostman.com/environments/$ENV_ID?apikey=$API_KEY"

echo "------------------------------------------------------------"
echo "Starting Newman Execution"
echo "Timestamp: $TIMESTAMP"
echo "------------------------------------------------------------"

# 5. Run Newman with Multiple Reporters
# -r cli,htmlextra,junit enables all three output types
newman run "$COLLECTION_URL" \
    -e "$ENV_URL" \
    -r cli,htmlextra,junit \
    --reporter-htmlextra-export "$HTML_REPORT_PATH" \
    --reporter-htmlextra-title "Automated API Test Report: $REPORT_NAME" \
    --reporter-htmlextra-darkTheme \
    --reporter-junit-export "$JUNIT_REPORT_PATH"

# 6. Success/Failure Check
if [ $? -eq 0 ]; then
    echo "SUCCESS: All tests passed."
    echo "HTML Report: $HTML_REPORT_PATH"
    echo "JUnit XML:   $JUNIT_REPORT_PATH"
else
    echo "FAILURE: Some tests failed. Check reports for details."
    exit 1
fi