#!/bin/bash

PLAYER_COUNT=24
export AWS_REGION=$(echo $REGION_NAME)


DEFAULT_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
DEFAULT_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
DEFAULT_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN


## Do an initial build of all assets
./build/build.sh

i=1
while [[ $i -le $PLAYER_COUNT ]]
do
    CURRENT_UUID=$(uuidgen)
    ACCOUNT_EMAIL="brfarn+${CURRENT_UUID}@amazon.com"

    ## Create the new account
    CREATE_ACCOUNT_INFO=$(aws organizations create-account --email $ACCOUNT_EMAIL --account-name "Scaling Web Apps ($CURRENT_UUID)")
    CREATE_ACCOUNT_JOB_ID=$(echo $CREATE_ACCOUNT_INFO | jq .CreateAccountStatus.Id | xargs)

    ACCOUNT_ID="000000000000"
    ## Wait for the account creation to complete
    ACCOUNT_READY=0
    while [[ $ACCOUNT_READY != 1]]
    do
        CURRENT_CREATE_STATE=$(aws organizations describe-create-account-status --create-account-request-id $CREATE_ACCOUNT_JOB_ID)
        CREATE_RESULT=$(echo $CURRENT_CREATE_STATE | jq .CreateAccountStatus.State | xargs)
        if [ $CREATE_RESULT = "SUCCEEDED" ]; then
            ACCOUNT_ID=$(echo $CURRENT_CREATE_STATE | jq .CreateAccountStatus.AccountId | xargs)
            ACCOUNT_READY=1
        else 
            echo "Waiting for account to provision (task ID: $CREATE_ACCOUNT_JOB_ID)"
            sleep 30
        fi
    done

    ## Assume role in to the child account
    TEMP_ROLE=$(aws sts assume-role --role-arn "arn:aws:iam::"$ACCOUNT_ID":role/OrganizationAccountAccessRole" --role-session-name "ChildAccount")
    export AWS_ACCESS_KEY_ID=$(echo $TEMP_ROLE | jq .Credentials.AccessKeyId | xargs)
    export AWS_SECRET_ACCESS_KEY=$(echo $TEMP_ROLE | jq .Credentials.SecretAccessKey | xargs)
    export AWS_SESSION_TOKEN=$(echo $TEMP_ROLE | jq .Credentials.SessionToken | xargs)

    ## Create the S3 bucket to deploy to in the child account
    aws s3api create-bucket --bucket ""$ACCOUNT_ID"-staging" --region $REGION_NAME --create-bucket-configuration LocationConstraint="$REGION_NAME"
    export PUBLISH_BUCKET_NAME="$ACCOUNT_ID-staging"

    ## Publish the CloudFormation template to the child account
    ./build/publish.sh

    ## Reset credentials to defaults to assume in to the next account
    export AWS_ACCESS_KEY_ID=DEFAULT_AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY=DEFAULT_AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN=DEFAULT_AWS_SESSION_TOKEN

    ## Append the account number to an output file
    echo $ACCOUNT_ID >> accounts.txt

    ((i = i + 1))
done
