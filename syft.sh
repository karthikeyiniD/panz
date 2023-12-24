#!/bin/bash

DOCKER_REGISTRY="771070158678.dkr.ecr.us-east-2.amazonaws.com"
REPO_DEV_NAME="demo"
ECR_TAG="demo-project-changebuildnumber"

# Run Syft to generate SBOM
syft packages docker:$DOCKER_REGISTRY/$REPO_DEV_NAME:$ECR_TAG -o cyclonedx > bom.json
cat bom.json
