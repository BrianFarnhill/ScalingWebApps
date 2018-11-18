#!/bin/bash

temp_role=$(aws sts assume-role \
                    --role-arn "arn:aws:iam::"$CHILD_ACCOUNT":role/OrganizationAccountAccessRole" \
                    --role-session-name "ChildAccount")

export AWS_ACCESS_KEY_ID=$(echo $temp_role | jq .Credentials.AccessKeyId | xargs)
export AWS_SECRET_ACCESS_KEY=$(echo $temp_role | jq .Credentials.SecretAccessKey | xargs)
export AWS_SESSION_TOKEN=$(echo $temp_role | jq .Credentials.SessionToken | xargs)
export AWS_REGION=$(echo $REGION_NAME)

# Create the staging bucket
aws s3api create-bucket --bucket ""$CHILD_ACCOUNT"-staging" --region $REGION_NAME --create-bucket-configuration LocationConstraint="$REGION_NAME"
export PUBLISH_BUCKET_NAME="$CHILD_ACCOUNT-staging"

# Create the IAM user with policy
aws iam create-user --user-name PlayerOne
aws iam create-login-profile --user-name PlayerOne --password ScaleMyApp!
aws iam put-user-policy --user-name PlayerOne --policy-name PlayerPolicy --policy-document file://playerpolicy.json

# Do the main build and publish actions
./build/build.sh && ./build/publish.sh
