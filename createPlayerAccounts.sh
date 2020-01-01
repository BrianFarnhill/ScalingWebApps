#!/bin/bash

# ***************************************************************
# This script isn't part of the main lab, rather one that is used
# to provision many child accounts so that if you are running the
# workshop with several participants (such as at re:Invent) you
# can give each their own child account in your organisation.
#
# IMPORTANT NOTE: While the accounts can be programmatically 
# created, remember that suspending an AWS account is a manual
# process, so clean up of accounts needs to be considered
#
# To run this script begin by setting your AWS keys in local
# variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY and 
# AWS_SESSION_TOKEN) and update the email format. This script
# assumes that each email has a GUID in it to be unique, you 
# may need to also tailor this so each child account has a valid
# email address that you can get to (as you will need to log in
# as the root user to suspend an account, so you really need
# valid email addresses)
# ***************************************************************

PLAYER_COUNT=1
export AWS_REGION=$(echo $REGION_NAME)

DEFAULT_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
DEFAULT_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
DEFAULT_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

i=1
while [ $i -le $PLAYER_COUNT ]
do
    CURRENT_UUID=$(uuidgen)
    ACCOUNT_EMAIL="brfarn+${CURRENT_UUID}@amazon.com"

    ## Create the new account
    CREATE_ACCOUNT_INFO=$(aws organizations create-account --email $ACCOUNT_EMAIL --account-name "Scaling Web Apps ($CURRENT_UUID)")
    CREATE_ACCOUNT_JOB_ID=$(echo $CREATE_ACCOUNT_INFO | jq .CreateAccountStatus.Id | xargs)

    ACCOUNT_ID="000000000000"
    ## Wait for the account creation to complete
    ACCOUNT_READY=0
    while [ $ACCOUNT_READY -lt 1 ]
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

    ## Append the account number to an output file
    echo $ACCOUNT_ID >> accounts.txt

    ((i = i + 1))
done
