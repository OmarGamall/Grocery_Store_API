#!/bin/bash

# 1. Load variables from .env
if [ -f .env ]; then
    while IFS='=' read -r key value || [ -n "$key" ]; do
        # 1a. Cleanup: Remove leading/trailing whitespace from key and value
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs | sed 's/\r$//')
        
        # 1b. Skip comments and empty keys
        [[ $key =~ ^#.* ]] || [[ -z $key ]] && continue
        
        # 1c. Dynamically export the variable
        export "$key=$value"
    done < .env
else
    echo "❌ ERROR: .env file not found."
    exit 1
fi

# 2. Assign and Verify Paths
COLLECTION="$COLLECTION_PATH"
ENVIRONMENT="$ENVIRONMENT_PATH"

# Debug: Print the paths to verify they are loaded
echo "------------------------------------------------------------"
echo "🔍 Debugging Paths:"
echo "Collection Path:  '$COLLECTION'"
echo "Environment Path: '$ENVIRONMENT'"

# 3. File Existence Check (Fails early if files are missing)
if [ ! -f "$COLLECTION" ]; then
    echo "❌ ERROR: Collection file not found at: $COLLECTION"
    exit 1
fi

if [ ! -f "$ENVIRONMENT" ]; then
    echo "❌ ERROR: Environment file not found at: $ENVIRONMENT"
    exit 1
fi

# 4. Directory Logic
BASE_REPORT_DIR="./reports"
HTML_DIR="$BASE_REPORT_DIR/HTML_Report"
JUNIT_DIR="$BASE_REPORT_DIR/JUnit_Report"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

mkdir -p "$HTML_DIR" "$JUNIT_DIR"

echo "------------------------------------------------------------"
echo "🚀 Running Local Automation: $(date)"
echo "------------------------------------------------------------"

# 5. Execute Newman
# We use "$VAR" everywhere to ensure spaces in filenames don't break the command
newman run "$COLLECTION" \
    -e "$ENVIRONMENT" \
    --env-var "access_token=$POSTMAN_ACCESS_TOKEN" \
    -r cli,htmlextra,junit \
    --reporter-htmlextra-export "$HTML_DIR/Report_$TIMESTAMP.html" \
    --reporter-htmlextra-darkTheme \
    --reporter-junit-export "$JUNIT_DIR/Results_$TIMESTAMP.xml"

# 6. Final Status
if [ $? -eq 0 ]; then
    echo "------------------------------------------------------------"
    echo "✅ SUCCESS: Reports generated in $BASE_REPORT_DIR"
else
    echo "------------------------------------------------------------"
    echo "❌ FAILURE: Tests failed. Check HTML reports for debugging."
    exit 1
fi