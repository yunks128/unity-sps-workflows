# unity-sps-workflows
Catalog of CWL workflows


## Steps to run the L1B CWL PGE in HySDS
1. pull down the `l1b_cwl_dind` branch in `unity-sps-worklows` (or use the `main` branch after this is merged in)
2. update the `ssips_L1b_workflow.yml` with your AWS credentials (`aws_access_key_id`, `aws_session_token`, etc.)
3. copy the unity-sps-workflows directory to the verdi pod (path may vary)
`$ kubectl cp /path/to/unity-sps-workflows verdi-668859cbf5-xjmkv:/tmp/unity-sps-workflows -c verdi`
4. exec into the verdi pod (pod name may vary)
`$ kubectl exec -it verdi-668859cbf5-xjmkv -c verdi -- bash`
5. run the build_container.py script to create the HySDS job
`$ python /tmp/unity-sps-workflows/docker/build_container.py --image unity-sps-workflows:develop -f /tmp/unity-sps-workflows`
6. run the job in HySDS ui (use the `verdi-job_worker` queue)
7. the job logs should be in your work local directory `/tmp/data/work/jobs/2022/` under `_stderr.txt`