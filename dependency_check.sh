#!/bin/bash

# Set your variables
Dependency_Track_Project_Identity="1f00af01-2df8-4b68-a0ee-6781adfe0c83"
Dependency_Track_Project_Token="odt_RtE9ROsIe5QlJZvi18xoLE0AyzKIVQjf"
DOCKER_REGISTRY="771070158678.dkr.ecr.us-east-2.amazonaws.com"
REPO_DEV_NAME="demo"
ECR_TAG="demo-project-81"

# Run Syft to generate SBOM
syft packages docker:$DOCKER_REGISTRY/$REPO_DEV_NAME:$ECR_TAG -o cyclonedx > syft_scanresults

# Convert SBOM content to base64
BOM_CONTENT_BASE64=$(base64 -w0 syft_scanresults)

# Create JSON payload for Dependency-Track API
echo '{"project": "'"$Dependency_Track_Project_Identity"'", "bom": "'"$BOM_CONTENT_BASE64"'"}' > json_payload.json

# Prepare JSON payload using jq
JSON_PAYLOAD=$(jq -n --slurpfile json json_payload.json '$json[0]')

# Send SBOM to Dependency-Track
curl -X "PUT" "https://api.karthikeyini.tech" \
   -H "Content-Type: application/json" \
   -H "X-API-Key: ${Dependency_Track_Project_Token}" \
   --data @json_payload.json


