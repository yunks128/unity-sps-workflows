# Sounder SIPS PGEs

Instructions for executing the Sounder SIPS L1a and L1b PGEs as standalone Docker containers.
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

## Create the output directory
```
cd <some directory>
mkdir output
cd output
export PGE_OUT_DIR=`pwd`
```


## Set the Docker image and version
Set the Docker image and version to use, for example:
```
# For L1a:
export DOCKER_IMAGE=<aws account number>.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1a_pge
# For L1b
export DOCKER_IMAGE=<aws account number>.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1b_pge
export DOCKER_TAG=r.0.2.0
```

## Download the Docker image
```
aws ecr get-login-password --region us-west-1 --profile saml-pub | docker login --username AWS --password-stdin <aws account number>.dkr.ecr.us-west-1.amazonaws.com
docker pull ${DOCKER_IMAGE}:${DOCKER_TAG}
```

## Execute the Docker container containing the PGE
```
docker run --rm \
    -v ${PGE_IN_DIR}:/pge/in \
    -v ${PGE_OUT_DIR}:/pge/out \
    -v ${PGE_STATIC_DIR}:/tmp/static \
    ${DOCKER_IMAGE}:${DOCKER_TAG} \
    -p input_path /pge/in -p output_path /pge/out -p data_static_path /tmp/static
```
The execution will last approximately two hours and write output in the $PGE_OUT_DIR directory.
