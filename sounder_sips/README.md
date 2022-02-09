# Sounder SIPS L1a+L1b Workflow
This directory contains the CWL and supporting files needed to execute the designated Sounder SIPS L1a+L1b workflow.
At this time, fake PGEs and input data are used.

## Pre-requisites
- Read/Write permissions to an S3 bucket pre-populated with the L1a input file
- A python virtual environment with the latest version of the CWL libraries installed. For example, such an environment can be created as follows:
```
cd <any working directory>
virtualenv cwl_venv
source cwl_venv/bin/activate
pip install cwltool cwl-runner
```


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

- Edit the file _ssips_L1a_L1b_workflow_job.yml_ which contains the specific user parameters used by the workflow:
  - Adjust the value of _l1a_workflow_source_s3_folder_ to match your S3 input bucket (where the input test file is stored)
  - Adjust the value of _l1a_workflow_target_s3_folder_ and _l1b_workflow_target_s3_folder_ to the desired S3 locations where the output files will be written  (the target S3 folder must exist, but the target S3 folders within it don't have to)
  - cut-and-paste the value of the AWS keys (_workflow_aws_access_key_id_, _workflow_aws_secret_access_key_, _workflow_aws_session_token_) from the values for the selected profile included in the AWS credential file _~/.aws/credentials

o Activate the Python virtual environment:
```
source <path to venv location>/env/bin/activate
```

o Execute the workflow:
```
cwl-runner --no-match-user --no-read-only ssips_L1a_L1b_workflow.cwl ssips_L1a_L1b_workflow_job.yml
```

o Afetr the workflow completes, verify that fake L1a and L1b files have been created in the target S3 bucket and folders
