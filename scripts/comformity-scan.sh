#!/bin/bash
set -e

echo "🔍 Running Conformity Template Scanner..."

# Check if Conformity CLI is available
if ! command -v conformity &> /dev/null; then
    echo "❌ Conformity CLI not found. Installing..."
    npm install -g @cloudone/conformity-template-scanner
fi

# Scan Terraform files
echo "📋 Scanning Terraform templates..."

# Convert Terraform to JSON format for scanning
terraform init -backend=false
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > tfplan.json

# Run Conformity scan
conformity template-scanner scan \
    --template-file tfplan.json \
    --template-type terraform \
    --output-format json \
    --output-file conformity-results.json

# Check scan results
if [ -f "conformity-results.json" ]; then
    echo "✅ Conformity scan completed"
    
    # Parse results and check for critical issues
    CRITICAL_COUNT=$(jq '[.[] | select(.severity == "CRITICAL")] | length' conformity-results.json)
    HIGH_COUNT=$(jq '[.[] | select(.severity == "HIGH")] | length' conformity-results.json)
    
    echo "📊 Scan Results:"
    echo "   Critical issues: $CRITICAL_COUNT"
    echo "   High issues: $HIGH_COUNT"
    
    # Fail pipeline if critical issues found
    if [ "$CRITICAL_COUNT" -gt 0 ]; then
        echo "❌ Critical security issues found! Pipeline failed."
        jq '.[] | select(.severity == "CRITICAL")' conformity-results.json
        exit 1
    fi
    
    # Warn about high issues but continue
    if [ "$HIGH_COUNT" -gt 0 ]; then
        echo "⚠️  High severity issues found:"
        jq '.[] | select(.severity == "HIGH")' conformity-results.json
    fi
    
    echo "✅ Security scan passed!"
else
    echo "❌ Conformity scan failed - no results file generated"
    exit 1
fi