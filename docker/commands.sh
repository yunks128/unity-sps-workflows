kubectl cp /Users/dustinlo/jpl/unity-sps-workflows verdi-668859cbf5-gbfjj:/tmp/unity-sps-workflows -c verdi

python /tmp/unity-sps-workflows/docker/build_container.py --image unity-sps-workflows:develop -f /tmp/unity-sps-workflows

docker build . -t foo:bar -f /tmp/l1b_pge_cwl_demo/docker/Dockerfile
