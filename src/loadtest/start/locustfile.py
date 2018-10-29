# Copyright 2015-2015 Amazon.com, Inc. or its affiliates. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License"). You may not use this file
# except in compliance with the License. A copy of the License is located at
#
#     http://aws.amazon.com/apache2.0/
#
# or in the "license" file accompanying this file. This file is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations under the License.


# https://aws.amazon.com/blogs/devops/using-locust-on-aws-elastic-beanstalk-for-distributed-load-generation-and-testing/ 

import os
#import string
#import random
#import json
#import time
#import boto3
#import uuid
from locust import HttpLocust, TaskSet, task
#from requests_aws4auth import AWS4Auth


class MyTaskSet(TaskSet):
    @task(1000)
    def homePage(self):
        self.client.get("/")

    @task(1000)
    def loadingGif(self):
        self.client.get("/images/loading.gif")

    @task(1000)
    def mainLogo(self):
        self.client.get("/images/AWS-reInvent-2018.png")

    @task(1000)
    def jqueryjs(self):
        self.client.get("/static/jquery/jquery.min.js")

    @task(1000)
    def bootstrapcss(self):
        self.client.get("/static/bootstrap/css/bootstrap.min.css")

    @task(1000)
    def maincss(self):
        self.client.get("/stylesheets/style.css")

    @task(1000)
    def popperjs(self):
        self.client.get("/static/popper/popper.min.js")

    @task(1000)
    def bootstrapjs(self):
        self.client.get("/static/bootstrap/js/bootstrap.min.js")

    @task(1000)
    def loaderjs(self):
        self.client.get("/javascripts/loader.js")

    @task(1000)
    def data(self):
        self.client.get("/data")

    # @task(1000)
    # def sampleOne(self):
    #     auth = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)        
    #     self.client.get("/latest/SampleOne", auth=auth)
    #     response.close()

    # @task(1000)
    # def sampleTwo(self):
    #     auth = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)        
    #     response = self.client.get("/latest/SampleTwo", auth=auth)
    #     response.close()

    # @task(100)
    # def addDeleteSampleOne(self):
    #     auth = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)        
    #     response = self.client.post("/latest/SampleOne", data=json.dumps({"TextValue": str(uuid.uuid4())}), auth=auth, catch_response=True)
    #     newId = response.json()["records"][0]["ID"]
    #     response.success()
    #     deleteBody = {
    #         "ID": newId
    #     }
    #     time.sleep(1)
    #     response.close()
    #     auth2 = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)
    #     deleteResponse = self.client.request("DELETE", "/latest/SampleOne", data=json.dumps(deleteBody), auth=auth2, catch_response=True)
    #     deleteResponse.success()
    #     deleteResponse.close()


    # @task(100)
    # def addDeleteSampleTwo(self):
    #     auth = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)        
    #     response = self.client.post("/latest/SampleTwo", data=json.dumps({"TextValue": str(uuid.uuid4())}), auth=auth, catch_response=True)
    #     newId = response.json()["records"][0]["ID"]
    #     response.success()
    #     deleteBody = {
    #         "ID": newId
    #     }
    #     time.sleep(1)
    #     response.close()
    #     auth2 = AWS4Auth(self.locust.credentials.access_key, self.locust.credentials.secret_key, os.getenv('REGION', 'ap-southeast-2'), 'execute-api', session_token=self.locust.credentials.token)
    #     deleteResponse = self.client.request("DELETE", "/latest/SampleTwo", data=json.dumps(deleteBody), auth=auth2, catch_response=True)
    #     deleteResponse.success()
    #     deleteResponse.close()

class MyLocust(HttpLocust):
    host = os.getenv('TARGET_URL')    
    task_set = MyTaskSet
    min_wait = 1
    max_wait = 1
    # session = boto3.Session()
    # credentials = session.get_credentials()
