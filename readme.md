# Scaling Web Applications

This repo contains code and assets used for the 2018-19 re:Invent builders session "Scale up a web application",
delivered by Brian Farnhill and Tony Hawke.

## Setting this solution up in your own account

You can set this solution up in your own account to perform your own testing and run through of the session
using the guide below. For info on the steps required for this, head to the
[Solution Deployment](guides/deployment.md) page.

## Session Walkthrough

The main session walkthrough is broken up in to a number of steps as you make changes to an existing web
application to improve its performance. Once you have the solution deployed, begin at step one and work
through from there.

1. [Review the existing solution and take a performance baseline](guides/1-start.md)
2. [Review the configuration of CloudFront, and adjust load tests to use it](guides/2-cloudfront.md)
3. [Review ElastiCache and the code changes required to use it, take a new set of load tests](guides/3-elasticache.md)
4. [Review configuration of Serverless API components, incorporate it in to the load tests](guides/4-serverless.md)
5. [Conclusion](guides/conclusion.md)

## License details

Copyright 2020 Amazon.com, Inc. or its affiliates. All Rights Reserved.

Licensed under the Apache License, Version 2.0 (the "License"). You may not use the code in
this repository except in compliance with the License. A copy of the License is located at

[http://aws.amazon.com/apache2.0/](http://aws.amazon.com/apache2.0/)

or in the "license" file accompanying this file. This file is distributed on an "AS IS"
BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations under the License.
