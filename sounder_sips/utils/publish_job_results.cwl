cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["/usr/app/publish_job.py"]
hints:
    DockerRequirement:
        dockerPull: ghcr.io/unity-sds/unity-sps-prototype/sps-job-publisher:develop
requirements:
    NetworkAccess:
        networkAccess: true

inputs:
    job_id:
        type: string
        inputBinding:
            position: 1
    update_results:
        type: string
        default: --update_results
        inputBinding:
            position: 2
    auth_method:
        type: string
        default: iam
        inputBinding:
            position: 3
            prefix: --aws_auth_method
    jobs_data_sns_topic_arn:
        type: string
        inputBinding:
            position: 4
            prefix: --jobs_data_sns_topic_arn
outputs:
    results:
        type: stdout
    errors:
        type: stderr
stdout: "publish_job_status_stdout.txt"
stderr: "publish_job_status_stderr.txt"
