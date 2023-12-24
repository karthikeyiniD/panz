# #!/bin/bash

# # Set your variables
# Dependency_Track_Project_Identity="70009411-9135-4bd4-8618-40d8cf252157"
# Dependency_Track_Project_Token="odt_RtE9ROsIe5QlJZvi18xoLE0AyzKIVQjf"
# DOCKER_REGISTRY="771070158678.dkr.ecr.us-east-2.amazonaws.com"
# REPO_DEV_NAME="demo"
# ECR_TAG="demo-project-25"

# # Run Syft to generate SBOM
# syft packages docker:$DOCKER_REGISTRY/$REPO_DEV_NAME:$ECR_TAG -o cyclonedx > syft_scanresults

# # Convert SBOM content to base64
# BOM_CONTENT_BASE64=$(base64 -w0 syft_scanresults)

# # Create JSON payload for Dependency-Track API
# echo '{"project": "'"$Dependency_Track_Project_Identity"'", "bom": "'"$BOM_CONTENT_BASE64"'"}' > json_payload.json

# # Prepare JSON payload using jq
# JSON_PAYLOAD=$(jq -n --slurpfile json json_payload.json '$json[0]')

# # Send SBOM to Dependency-Track
# curl -X "POST" "https://www.karthikeyini.tech/api/v1/bom" \
#    -H "Content-Type: application/json" \
#    -H "X-API-Key: ${Dependency_Track_Project_Token}" \
#    --data @json_payload.json


#!/bin/bash

if [ "$#" -ne 2 ]; then
  echo "$0 docker:771070158678.dkr.ecr.us-east-2.amazonaws.com/demo:demo-project-8 70009411-9135-4bd4-8618-40d8cf252157"
  exit -1
fi


# REPLACE HERE-------------------------
YourCompanyPrefix="www.karthikeyini.tech"
YourApiKey="odt_RtE9ROsIe5QlJZvi18xoLE0AyzKIVQjf"
# END REPLACE--------------------------

SCRIPT_PATH=$(dirname -- "$(readlink -f "${BASH_SOURCE}")")
project="$2"
sbom="$(uuidgen).sbom"

echo -n "Extracting SBOM..." 
&& $SCRIPT_PATH/syft.sh packages "$1" -o cyclonedx-json > $sbom 
&& echo -ne " done\nSending SBOM..." 
&& curl -X POST -H "X-API-Key: $YourApiKey" \
         -H 'Content-Type: multipart/form-data; boundary=__X_BOM__' \
         -F "bom=@$sbom" \
         -F "project=$project" \
         "https://$YourCompanyPrefix.deptrack.yoursky.blue/api/v1/bom" 
&& echo -e " sent\n\nCleaning..." 
&& rm $sbom
