# Conclusion

1. [Review the existing solution and take a performance baseline](1-start.md)
2. [Review the configuration of CloudFront, and adjust load tests to use it](2-cloudfront.md)
3. [Review ElastiCache and the code changes required to use it, take a new set of load tests](3-elasticache.md)
4. [Review configuration of Serverless API components, incorporate it in to the load tests](4-serverless.md)
5. **Conclusion**

Through this session we have focussed on a few things:

* Using AWS services to improve performance of a website, making minimal changes to
  code and re-using code where possible
* Monitoring applications that use different AWS services as they run at load
* Using live load tests to validate performance of a web site before users get to it
  in the wild

There are a number of AWS services we touched on throughout this session, all of which
could be used to improve a websites performance. Consider where each could fit in
your own architectures and use them where they make sense. There are also a range of
other features in these services that can help you in other areas that haven't been
touched on in this session (such as security, availability, cost optimization etc.).

Remember to stop your load tests and if you are done with the environment, you can
remove the cloud formation stack to clean everything up (and just deploy it again if
you want to go through more!). We hope you have enjoyed this content!
