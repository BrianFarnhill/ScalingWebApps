#!/bin/bash

aws s3 sync ./build/release "s3://$PUBLISH_BUCKET_NAME" --delete

#TODO: Add the deployment of the cloudformation script for player start to here so we have it running somewhere
