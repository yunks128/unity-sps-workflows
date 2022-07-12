aws ecr get-login-password --region us-west-1 --profile saml-pub | docker login --username AWS --password-stdin 884500545225.dkr.ecr.us-west-1.amazonaws.com


docker pull 884500545225.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1b_pge:r0.2.0
docker pull 884500545225.dkr.ecr.us-west-1.amazonaws.com/unity-sds/sounder_sips_l1b_pge:r0.1.0


python ~/jpl/unity-sps-prototype/hysds/build_container.py --image l1b_pge_demo:develop -f ~/Desktop/l1b_pge_demo


kubectl cp /Users/dustinlo/Desktop/unity/l1b_pge_cwl_demo verdi-668859cbf5-xjmkv:/tmp/l1b_pge_cwl_demo -c verdi
kubectl cp /Users/dustinlo/jpl/unity-sps-workflows verdi-668859cbf5-xjmkv:/tmp/unity-sps-workflows -c verdi

python build_container.py --image l1b_pge_cwl_demo:develop -f /tmp/l1b_pge_cwl_demo
python /tmp/build_container.py --image unity-sps-workflows:develop -f /tmp/unity-sps-workflows

docker build . -t foo:bar -f /tmp/l1b_pge_cwl_demo/docker/Dockerfile

pod/verdi-668859cbf5-jcpz8

