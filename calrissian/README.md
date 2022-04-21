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
- Create Kubernetes volumes to hold temporary data for the CWL workflow, as well as permanent static data used by the L1b PGE:
```
kubectl create -f VolumeClaims.yaml -n $NAMESPACE_NAME 

kubectl get pvc -n $NAMESPACE_NAME 
NAME                     STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
calrissian-input-data    Bound    pvc-ffca8962-3974-45c7-8a72-fe11acbf6b53   1Gi        RWO,ROX        hostpath       18s
calrissian-output-data   Bound    pvc-e1d97847-9b67-4e26-ad19-000faf4934e2   1Gi        RWX            hostpath       18s
calrissian-static-data   Bound    pvc-416e3149-c23d-4414-88ad-b670621f5ee7   5Gi        RWX            hostpath       18s
calrissian-tmpout        Bound    pvc-7be0664e-dd24-4c96-95a1-227ffbb62885   1Gi        RWX            hostpath       18s
```

- Create a Kubernetes Pod that is used to access the volumes:
```
kubectl create -f AccessVolumes.yaml -n $NAMESPACE_NAME
```

- Copy the static data from the local disk to the Kubernetes static data volume. Make sure the static files appear at the root level
of the /calrissian/static-data directory inside the Pod - if not, enter the Pod and move the directory/files:
```
kubectl cp <static_data_dir> access-pv:/calrissian/static-data/. -n $NAMESPACE_NAME

kubectl exec -it access-pv -n $NAMESPACE_NAME -- sh -c 'ls -l /calrissian/static-data' 
total 12
-rw-r--r-- 1 calrissian root  163 Apr 11 14:15 README.txt
drwxr-xr-x 4 calrissian root 4096 Apr 11 14:23 dem
drwxr-xr-x 2 calrissian root 4096 Apr 11 14:27 mcf

# To move data to the proper location inside the Pod:
# kubectl exec -it access-pv -n $NAMESPACE_NAME sh
kubectl exec [POD] [COMMAND] is DEPRECATED and will be removed in a future version. Use kubectl exec [POD] -- [COMMAND] instead.
# cd /calrissian/static-data
# mv STATIC_DATA/* .
# rmdir STATIC_DATA
# exit
```

- Create a Kubernetes Pod that holds 2 containers:
  - A container "dind-daemon" that runs an internal Docker engine (via the "docker-in-docker" pattern)
  - A container "docker-cmds" that represents a "makeshift" worker node which will submit a "docker run" command to the internal Docker engine accessible at: tcp://localhost:2375
  Note that the "dind-daemon" container mounts two volumes that gives it access to the kube-config file to interact with the Kubernetes cluster, and the current directory that contains the definition of the CWL workflow to run.
```
kubectl create -f dind.yaml -n $NAMESPACE_NAME 

kubectl get pods -n $NAMESPACE_NAME 
NAME        READY   STATUS    RESTARTS   AGE
access-pv   1/1     Running   0          28m
dind        2/2     Running   0          15s
```

- Enter the Docker client container and submit the Calrissian job to execute the CWL workflow:
```
kubectl exec -it dind -c docker-cmds -- sh

docker run --rm --name kubectl -v /.kube/config:/.kube/config -v /working-dir:/working-dir -w /working-dir bitnami/kubectl:lat
est create -f SounderSipsL1bJob.yaml -n unity-sps
job.batch/calrissian-job created
```

- You can follow the execution of the CWL workflow in another window, by printing the logs of the Calrissian Pod until completion:
```
kubectl get pods -n $NAMESPACE_NAME                    
NAME                         READY   STATUS    RESTARTS   AGE
access-pv                    1/1     Running   0          34m
calrissian-job-ptl4c         1/1     Running   0          72s
dind                         2/2     Running   0          6m24s
l1b-stage-out-pod-gsrpfxud   1/1     Running   0          9s

kubectl logs -f calrissian-job-ptl4c -n $NAMESPACE_NAME
...

```
