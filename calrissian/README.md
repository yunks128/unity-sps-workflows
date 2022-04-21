# Executing the Sounder SIPS Workflows via Calrissian
This page explains how to execute the Sounder SIPS L1b CWL workflow within a Kubernetes cluster using the Calrissian tool.
[Calrissian](https://github.com/Duke-GCB/calrissian) is a CWL implementation for executing workflows on a Kubernetes cluster, which runs every step of the CWL workflow on a separate Kubernetes Pod.

## Pre-requisites
- Docker engine installed on private laptop, including running the associated local Kubernetes cluster.
- Static data downloaded from the AWS S3 bucket s3://unity-ads/sounder_sips/static_files/ to a local directory <static_data_dir>

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

- Create a Kubernetes secret holding valid AWS credentials to download and upload data from/to the proper AWS account
(delete any previous existing secret):
```
kubectl delete secret aws-creds -n $NAMESPACE_NAME 

aws-login -pub
...
Please choose the role you would like to assume:
[0] jpl-mipl / power_user ---->....

export aws_access_key_id=...
export aws_secret_access_key=...
export aws_session_token=...

kubectl --namespace="$NAMESPACE_NAME" create secret generic aws-creds \
  --from-literal=aws_access_key_id="$aws_access_key_id" \
  --from-literal=aws_secret_access_key="$aws_secret_access_key"\
  --from-literal=aws_session_token="$aws_session_token"

kubectl get secrets -n $NAMESPACE_NAME
NAME                  TYPE                                  DATA   AGE
aws-creds             Opaque                                3      15s
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

- Create Kubernetes volumes to hold temporary data for the CWL workflow, as well as permanent static data used by the L1b PGE:
```
kubectl create -f VolumeClaims.yaml -n $NAMESPACE_NAME 

k get pvc -n $NAMESPACE_NAME 
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
calrissian-input-data    Bound    pvc-ffca8962-3974-45c7-8a72-fe11acbf6b53   1Gi        RWO,ROX        hostpath       18s
calrissian-output-data   Bound    pvc-e1d97847-9b67-4e26-ad19-000faf4934e2   1Gi        RWX            hostpath       18s
calrissian-static-data   Bound    pvc-416e3149-c23d-4414-88ad-b670621f5ee7   5Gi        RWX            hostpath       18s
calrissian-tmpout        Bound    pvc-7be0664e-dd24-4c96-95a1-227ffbb62885   1Gi        RWX            hostpath       18s
```

- Create a Kubernetes Pod that is used to access the volumes:
```
k create -f AccessVolumes.yaml -n $NAMESPACE_NAME
```

- Copy the static data from the local disk to the Kubernetes static data volume. Make sure the static files appear at the root level
of the /calrissian/static-data directory inside the Pod - if not, enter the Pod and move the directory/files:
```
kubectl cp <static_data_dir> access-pv:/calrissian/static-data/. -n $NAMESPACE_NAME

k exec -it access-pv -n $NAMESPACE_NAME -- sh -c 'ls -l /calrissian/static-data' 
total 12
-rw-r--r-- 1 calrissian root  163 Apr 11 14:15 README.txt
drwxr-xr-x 4 calrissian root 4096 Apr 11 14:23 dem
drwxr-xr-x 2 calrissian root 4096 Apr 11 14:27 mcf

# To move data to the proper location inside the Pod:
# k exec -it access-pv -n $NAMESPACE_NAME sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
# cd /calrissian/static-data
# mv STATIC_DATA/* .
# rmdir STATIC_DATA
# exit
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
