#!/usr/bin/env cwl-runner
cwlVersion: v1.1
class: Workflow
label: Workflow that wraps sleep command line tool to make testing of certain parts of SPS easier 

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  MultipleInputFeatureRequirement: {}

## Inputs to the sleep workflow
inputs:

  # publish_job parameters
  job_id: string
  job_status:
    type: string
    default: "unknown"
  job_inputs:
    type: string
    default: "none"
  jobs_data_sns_topic_arn:
    type: string


## Outputs of the CHIRP e2e workflow
outputs: []

steps:

  create_job:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/publish_job_status.cwl
    in:
      job_id: job_id
      job_status:
        valueFrom: "running"
      job_inputs: job_inputs
      jobs_data_sns_topic_arn: jobs_data_sns_topic_arn
    out:
    - results
    - errors

  workflow:
    # FIXME
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/sleep.cwl
    # run: https://raw.githubusercontent.com/unity-sds/sounder-sips-chirp-workflows/main/chirp-rebinning-e2e-workflow.cwl
    in:
        sleep_time:
          valueFrom: 30
    out:
    - stdout_file
    - stderr_file

  update_job:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/publish_job_status.cwl
    in:
      job_id: job_id
      job_status:
        valueFrom: "succeeded"
      job_inputs: job_inputs
      jobs_data_sns_topic_arn: jobs_data_sns_topic_arn
      dependency_stdout: [workflow/stdout_file, create_job/results]
      dependency_stderr: [workflow/stderr_file, create_job/errors]

    out:
    - results
    - errors