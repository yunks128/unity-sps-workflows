# Sounder SIPS PGE

Instructions for executing the Sounder SIPS PGE as standalone Docker container.
Below, `<some directory>` can be any directory, `<account number>` is the JPL MIPL AWS account number.

## Renew the AWS credentials
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
