# Executing the Sounder SIPS Workflows via Calrissian
This page explains how to execute the Sounder SIPS L1b CWL workflow within a Kubernetes cluster using the Calrissian tool.
[https://github.com/Duke-GCB/calrissian] Calrissian is a CWL implementation for executing workflows onto a Kubernetes cluster, which runs every single step of a CWL workflow on a separate Kubernetes Pod.

## Pre-requisites
- Docker engine installed on private laptop, including running the associated local Kubernetes cluster.

## Steps

- Create and configure a dedicated namespace within the local Kubernetes cluster. For example:
```
export NAMESPACE_NAME=unity-sps
kubectl create namespace "$NAMESPACE_NAME"
kubectl --namespace="$NAMESPACE_NAME" create role pod-manager-role \
  --verb=create,patch,delete,list,watch --resource=pods
kubectl --namespace="$NAMESPACE_NAME" create role log-reader-role \
  --verb=get,list --resource=pods/log
kubectl --namespace="$NAMESPACE_NAME" create rolebinding pod-manager-default-binding \
  --role=pod-manager-role --serviceaccount=${NAMESPACE_NAME}:default
kubectl --namespace="$NAMESPACE_NAME" create rolebinding log-reader-default-binding \
  --role=log-reader-role --serviceaccount=${NAMESPACE_NAME}:default
```

- Checkout this repository:
```
git clone https://github.com/unity-sds/unity-sps-workflows.git
cd unity-sps-workflows
git checkout calrissian
cd calrissian
```

- Renew the AWS credentials for which you have Read/Write permissions to the desired S3 bucket. For example:
```
aws-login -pub
...
Please choose the role you would like to assume:
[0] jpl-mipl / power_user ---->....
...
Credential file /Users/...../.aws/config has been successfully updated. To use you must specify the profile 'saml-pub'.
```

- Activate the Python virtual environment:
```
source <path to venv location>/env/bin/activate
```

## Latest Sounder SIPS L1A, L1B Workflows 

The steps to execute the L1A and L1B workflows are practically the same.

- Edit the file ssips_L1a_workflow_job_new.yml or ssips_L1b_workflow_job_new.yml which contains the specific user parameters used by the workflow:
  - Adjust the value of _static_dir_ to the local directory where the Sounder SIPS static files were downloaded
  - cut-and-paste the value of the AWS keys (_aws_access_key_id_, _aws_secret_access_key_, _aws_session_token_) from the values for the selected profile included in the AWS credential file _~/.aws/credentials_ .

- Execute the workflow:
```
cwl-runner --no-match-user --no-read-only ssips_L1a_workflow.cwl ssips_L1a_workflow.yml
or:
cwl-runner --no-match-user --no-read-only ssips_L1b_workflow.cwl ssips_L1b_workflow.yml
```
- After the workflow completes, verify that fake output files have been created in the target S3 bucket s3://unity-sps/sounder_sips/l1a/out/ or s3://unity-sps/sounder_sips/l1b/out, respectively.

## Older Sounder SIPS L1a+L1b combined Workflow

- Edit the file _ssips_L1a_L1b_workflow_job.yml_ which contains the specific user parameters used by the workflow:
  - Adjust the value of _l1a_workflow_source_s3_folder_ to match your S3 input bucket (where the input test file is stored)
  - Adjust the value of _l1a_workflow_target_s3_folder_ and _l1b_workflow_target_s3_folder_ to the desired S3 locations where the output files will be written  (the target S3 folder must exist, but the target S3 folders within it don't have to)
  - cut-and-paste the value of the AWS keys (_workflow_aws_access_key_id_, _workflow_aws_secret_access_key_, _workflow_aws_session_token_) from the values for the selected profile included in the AWS credential file _~/.aws/credentials_ .

- Execute the workflow:
```
cwl-runner --no-match-user --no-read-only ssips_L1a_L1b_workflow.cwl ssips_L1a_L1b_workflow_job.yml
```
- After the workflow completes, verify that fake L1a and L1b files have been created in the target S3 bucket and folders
