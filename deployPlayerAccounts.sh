#!/bin/bash

# ***************************************************************
# This script isn't part of the main lab, rather one that is used
# to provision many child accounts so that if you are running the
# workshop with several participants (such as at re:Invent) you
# can give each their own child account in your organisation.
#
# This script assumes the accounts have already been created 
# using the createPlayerACcounts.sh script, and the account numbers
# are stored in accounts.txt. Be sure to wait 24 hours after
# creating the child accounts so that all services are enabled
# and ready to use. 
#
# To run this script begin by setting your AWS keys in local
# variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and 
# AWS_SESSION_TOKEN) and update the email format. 
# ***************************************************************

export AWS_REGION=$(echo $REGION_NAME)

DEFAULT_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
DEFAULT_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
DEFAULT_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

## Do an initial build of all assets
./build/build.sh

while read ACCOUNT_ID; do

    ## Assume role in to the child account
    TEMP_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::"$ACCOUNT_ID":role/OrganizationAccountAccessRole" --role-session-name "ChildAccount")
    export AWS_ACCESS_KEY_ID=$(echo $TEMP_ROLE | jq .Credentials.AccessKeyId | xargs)
    export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_ROLE | jq .Credentials.SecretAccessKey | xargs)
    export AWS_SESSION_TOKEN=$(echo $TEMP_ROLE | jq .Credentials.SessionToken | xargs)

    aws s3api create-bucket --bucket ""$ACCOUNT_ID"-staging" --region $REGION_NAME --create-bucket-configuration LocationConstraint="$REGION_NAME"
    export PUBLISH_BUCKET_NAME="$ACCOUNT_ID-staging"

    ## Publish the CloudFormation template to the child account
    ./build/publish.sh

    ## To change the script to delete the stacks instead, comment out the publish line and uncomment the below two lines
    ## STACK_NAME="PlayerStartTemplate"
    ## aws cloudformation delete-stack --stack-name $STACK_NAME --region $REGION_NAME

    ## Reset credentials to defaults to assume in to the next account
    export AWS_ACCESS_KEY_ID=DEFAULT_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=DEFAULT_AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN=DEFAULT_AWS_SESSION_TOKEN

done <accounts.txt
