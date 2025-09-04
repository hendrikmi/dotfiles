#!/bin/bash
# Athena query runner with environment variable configuration
# Usage: echo "SELECT * FROM table" | ./athena-query.sh
#
# Environment variables:
#   ATHENA_OUTPUT_LOCATION - S3 path for query results (required)
#   ATHENA_DATABASE - Database to query (required)
#   AWS_REGION - AWS region (uses AWS CLI default if not set)

# Check required environment variables
if [ -z "$ATHENA_OUTPUT_LOCATION" ]; then
    echo "Error: ATHENA_OUTPUT_LOCATION environment variable is not set" >&2
    exit 1
fi

if [ -z "$ATHENA_DATABASE" ]; then
    echo "Error: ATHENA_DATABASE environment variable is not set" >&2
    exit 1
fi

# Build region parameter if AWS_REGION is set
REGION_PARAM=""
if [ -n "$AWS_REGION" ]; then
    REGION_PARAM="--region $AWS_REGION"
fi

QUERY=$(cat)
QUERY_ID=$(aws athena start-query-execution \
    --query-string "$QUERY" \
    --result-configuration OutputLocation="$ATHENA_OUTPUT_LOCATION" \
    --query-execution-context Database="$ATHENA_DATABASE" \
    $REGION_PARAM \
    --output text --query 'QueryExecutionId')

while aws athena get-query-execution --query-execution-id $QUERY_ID $REGION_PARAM --query 'QueryExecution.Status.State' --output text | grep -qE 'RUNNING|QUEUED'; do :; done

aws athena get-query-results --query-execution-id $QUERY_ID $REGION_PARAM --output text --query 'ResultSet.Rows[*].[Data[*].VarCharValue]' | column -t -s $'\t'
