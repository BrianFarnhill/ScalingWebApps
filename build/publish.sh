#!/bin/bash

aws s3 sync ./build/release "s3://$PUBLISH_BUCKET_NAME" --delete

STACK_NAME="PlayerStartTemplate"
aws cloudformation describe-stacks --stack-name $STACK_NAME >/dev/null 2>/dev/null
if [ $? = 0 ]; then
    aws cloudformation update-stack --stack-name $STACK_NAME \
                                    --template-url "https://$PUBLISH_BUCKET_NAME.s3.amazonaws.com/cfn/player-start.yaml" \
                                    --capabilities CAPABILITY_IAM \
                                    --region $REGION_NAME
else
    aws cloudformation create-stack --stack-name $STACK_NAME \
                                    --template-url "https://$PUBLISH_BUCKET_NAME.s3.amazonaws.com/cfn/player-start.yaml" \
                                    --capabilities CAPABILITY_IAM \
                                    --region $REGION_NAME
fi
