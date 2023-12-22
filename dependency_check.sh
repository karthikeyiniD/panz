#!/bin/bash
Dependency_Track_Project_Identity="identity"
Dependency_Track_Project_Token="token"
syft packages docker:$DOCKER_REGISTRY/$REPO_DEV_NAME:$ECR_TAG-Dev-$BUILD_NUMBER -o cyclonedx > syft_scanresults
apk add --no-cache jq
BOM_CONTENT_BASE64=$(base64 -w0 syft_scanresults)
echo '{"project": "'"$Dependency_Track_Project_Identity"'", "bom": "'"$BOM_CONTENT_BASE64"'"}' > json_payload.json
JSON_PAYLOAD=$(jq -n --slurpfile json json_payload.json '$json[0]')
curl -X "PUT" "https://www.karthikeyini.tech/api/v1/bom" \
   -H "Content-Type: application/json" \
   -H "X-API-Key: ${Dependency_Track_Project_Token}" \
   --data @json_payload.json
