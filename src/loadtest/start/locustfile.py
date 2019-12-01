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
from locust import HttpLocust, TaskSet, task


class MyTaskSet(TaskSet):
    @task(1000)
    def homePage(self):
        self.client.get("/")

    @task(1000)
    def dataPage(self):
        self.client.get("/data")

    @task(100)
    def loadingGif(self):
        self.client.get("/images/loading.gif")

    @task(100)
    def mainLogo(self):
        self.client.get("/images/DeckAssets_allup_light_graphs.jpg")

    @task(100)
    def jqueryjs(self):
        self.client.get("/static/jquery/jquery.min.js")

    @task(100)
    def bootstrapcss(self):
        self.client.get("/static/bootstrap/css/bootstrap.min.css")

    @task(100)
    def maincss(self):
        self.client.get("/stylesheets/style.css")

    @task(100)
    def popperjs(self):
        self.client.get("/static/popper/popper.min.js")

    @task(100)
    def bootstrapjs(self):
        self.client.get("/static/bootstrap/js/bootstrap.min.js")

    @task(100)
    def loaderjs(self):
        self.client.get("/javascripts/loader.js")

class MyLocust(HttpLocust):
    host = os.getenv('TARGET_URL')    
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000
