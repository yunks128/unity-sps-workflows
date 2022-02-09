# Sounder SIPS L1a+L1b Workflow
This directory contains the CWL and supporting files needed to execute the designated Sounder SIPS L1a+L1b workflow.
At this time, fake PGEs and input data are used.

## Pre-requisites
- Read/Write permissions to an S3 bucket pre-populated with the L1a input file
- A python virtual environment with the latest version of the CWL libraries installed

## Steps

- Clone this repository and enter this directory:
```
git clone https://github.com/unity-sds/unity-sps-workflows.git
cd unity-sps-workflows/ 
git checkout devel
cd sounder_sips 
```

- Renew the AWS credentials for which you have Read/Write permissions to the desired S3 bucket. For example:
```
aws-login -gov
...
Please choose the role you would like to assume:
[0] my_role---->....
...
Credential file /Users/...../.aws/config has been successfully updated. To use you must specify the profile 'saml-gov'.
```

