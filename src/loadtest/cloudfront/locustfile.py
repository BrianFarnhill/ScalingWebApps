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
        self.client.get("/images/AWS-reInvent-2018.png")

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
    host = os.getenv('CLOUDFRONT_URL')    
    task_set = MyTaskSet
    min_wait = 5000
    max_wait = 15000
