# Sounder SIPS PGEs

This page contains the instructions for executing the Sounder SIPS L1a and L1b PGEs as standalone Docker containers.
The two PGEs can be executed independently - i.e. the L1b PGE can be executed first without prior execution of the L1a PGE.
Below, `<some directory>` can be any directory, `<aws account number>` is the JPL MIPL AWS account number.

## Renew the AWS credentials
```
aws-login -pub
```
Credentials will be written for the _saml-pub_ profile.

## Download the input data
```
cd <some directory>
mkdir input
cd input
# for the L1a PGE:
aws s3 cp s3://unity-sps/sounder_sips/l1a/in/ . --recursive --profile saml-pub
# for the L1b PGE:
aws s3 cp s3://unity-sps/sounder_sips/l1b/in/ . --recursive --profile saml-pub
export PGE_IN_DIR=`pwd`
```

## Download the static data
Static data is needed by both the L1a nd L1b PGEs.
```
cd <some directory>
mkdir static
cd static
aws s3 cp s3://unity-ads/sounder_sips/static_files/ . --recursive --profile saml-pub
export PGE_STATIC_DIR=`pwd`
```

## Set the Docker image and version
Set the Docker image and version to use, for example:
```
# For L1a:
export DOCKER_IMAGE=<aws account number>.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1a_pge
# For L1b
export DOCKER_IMAGE=<aws account number>.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1b_pge
export DOCKER_TAG=r0.1.0
```

## Download the Docker image
```
aws ecr get-login-password --region us-west-1 --profile saml-pub | docker login --username AWS --password-stdin <aws account number>.dkr.ecr.us-west-1.amazonaws.com
docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
```

## Execute the Docker container containing the PGE

Mounting the local input and output directories to the default locations inside the container where the PGE will look for (i.e., '/pge/in' and '/pge/out'):
```
docker run --rm \
    -v ${PGE_IN_DIR}:/pge/in \
    -v ${PGE_OUT_DIR}:/pge/out \
    -v ${PGE_STATIC_DIR}:/tmp/static \
    ${DOCKER_IMAGE}:${DOCKER_TAG} \
    /tmp/processed_notebook.ipynb \
    -p data_static_path /tmp/static
```

Alternatively, mounting the local input and output directories to other locations inside the container and passing them as additional paremeters to the PGE
(note that the output directory must be writable by the user executing the PGE inside the container):

```
docker run --rm \
    -v ${PGE_IN_DIR}:/pge/inx \
    -v ${PGE_OUT_DIR}:/tmp/outx \
    -v ${PGE_STATIC_DIR}:/tmp/staticx \
    -w /tmp \
    ${DOCKER_IMAGE}:${DOCKER_TAG} \
    /tmp/processed_notebook.ipynb \
    -p input_path /pge/inx -p output_path /tmp/outx -p data_static_path /tmp/staticx
```

Finally, also overriding the entrypoint:
```
docker run --rm \
    -v ${PGE_IN_DIR}:/pge/inx \
    -v ${PGE_OUT_DIR}:/tmp/out \
    -v ${PGE_STATIC_DIR}:/tmp/static \
    -w /tmp \
    --entrypoint papermill \
    ${DOCKER_IMAGE}:$DOCKER_TAG \
    /pge/interface/run_l1b_pge.ipynb /tmp/processed_notebook.ipynb \
    -p input_path /pge/inx -p output_path /tmp/out -p data_static_path /tmp/static
```
The execution of the L1a Docker container will last approximately two hours and write output in the $PGE_OUT_DIR directory.
The execution of the L1b Docker container will last only a few minutes and again write output in the $PGE_OUT_DIR directory.
