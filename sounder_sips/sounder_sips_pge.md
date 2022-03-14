# Sounder SIPS PGE

Instructions for executing the Sounder SIPS PGE as standalone Docker container.
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
aws s3 cp s3://unity-sps/sounder_sips/in/ . --recursive --profile saml-pub
export PGE_IN_DIR=`pwd`
```

## Download the static data
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

## Download the Docker image
```
aws ecr get-login-password --region us-west-1 --profile saml-pub | docker login --username AWS --password-stdin <aws account number>.dkr.ecr.us-west-1.amazonaws.com
docker pull <aws account number>.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1a_pge:r0.1.0
```

## Execute the Docker container containing the PGE
```
docker run --rm \
    -v ${PGE_IN_DIR}:/pge/in \
    -v ${PGE_OUT_DIR}:/pge/out \
    -v ${PGE_STATIC_DIR}:/tmp/static \
    ${DOCKER_IMAGE} \
    -p input_path /pge/in -p output_path /pge/out -p data_static_path /tmp/static
```
The execution will last approximately two hours and write output in the $PGE_OUT_DIR directory.
