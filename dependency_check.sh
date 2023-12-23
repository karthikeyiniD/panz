#!/bin/bash
Dependency_Track_Project_Identity="608fb4c8-3202-4d5c-94d1-610bd6f3354a"
Dependency_Track_Project_Token="odt_uh8kitt8MyRMYvc7utwG3I7dFOElw2Kg"
DOCKER_REGISTRY="771070158678.dkr.ecr.us-east-2.amazonaws.com"
REPO_DEV_NAME="demo"
ECR_TAG="demo-project-6"
syft packages docker:$DOCKER_REGISTRY/$REPO_DEV_NAME:$ECR_TAG -o cyclonedx > syft_scanresults
BOM_CONTENT_BASE64=$(base64 -w0 syft_scanresults)
echo '{"project": "'"$Dependency_Track_Project_Identity"'", "bom": "'"$BOM_CONTENT_BASE64"'"}' > json_payload.json
JSON_PAYLOAD=$(jq -n --slurpfile json json_payload.json '$json[0]')
curl -X "PUT" "https://www.karthikeyini.tech/api/v1/bom" \
   -H "Content-Type: application/json" \
   -H "X-API-Key: ${Dependency_Track_Project_Token}" \
   --data @json_payload.json
