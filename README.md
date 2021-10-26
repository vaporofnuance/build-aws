# build-aws

## Description

This Docker image is for faciliating build, test, and deploy for AWS applications.  Its only current target is within a Jenkins Pipeline; though, it could presumably be used for other CI/CD systems since it has no Jenkins specific content.

## Contents


The following are installed on this image.

  - Terraform 0.14.3
  - AWSCLI
  - Localstack
  - Go 1.15.6
  - Python 3.6
  - Java 11
  - Maven
  - other various tools (such as Git, gcc, and Make)
