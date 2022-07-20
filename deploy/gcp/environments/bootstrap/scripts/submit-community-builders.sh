#!/bin/bash

# https://cloud.google.com/build/docs/configuring-builds/use-community-and-custom-builders

PROJECT=$1

git clone https://github.com/GoogleCloudPlatform/cloud-builders-community.git

cd cloud-builders-community/terraform || exit 1

gcloud builds submit --project "$PROJECT" .

cd ../..

rm -rf cloud-builders-community
