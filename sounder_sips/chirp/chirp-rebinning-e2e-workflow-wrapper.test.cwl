#!/usr/bin/env cwl-runner
cwlVersion: v1.1
class: Workflow
label: Workflow that wraps the execution of the Sounder SIPS end-to-end chirp rebinngin workflow by invoking the U-SPS job management functionality

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  MultipleInputFeatureRequirement: {}

## Inputs to the CHIRP e2e workflow
inputs:

  # publish_job parameters
  job_id: string
  job_status:
    type: string
    default: "unknown"
  job_inputs:
    type: string
    default: "{}"
  jobs_data_sns_topic_arn:
    type: string

  # Generic inputs
  input_processing_labels: string[]

  # For CMR Search Step
  input_cmr_collection_name: string
  input_cmr_search_start_time: string
  input_cmr_search_stop_time: string
  # input_cmr_edl_user: string
  # input_cmr_edl_pass: string

  #for chirp rebinning step
  # none -

  # For unity data upload step, unity catalog
  output_collection_id: string
  output_data_bucket: string

  # For DAAC CNM step
  input_daac_collection_shortname: string
  input_daac_collection_sns: string

## Outputs of the CHIRP e2e workflow
outputs:
  results: 
    type: File
    outputSource: workflow/results

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
    # run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/chirp/chirp-rebinning-e2e-workflow.cwl
    run: https://raw.githubusercontent.com/unity-sds/sounder-sips-chirp-workflows/main/chirp-rebinning-e2e-workflow.test.cwl
    in:
      input_processing_labels: input_processing_labels
      input_cmr_collection_name: input_cmr_collection_name
      input_cmr_search_start_time: input_cmr_search_start_time
      input_cmr_search_stop_time: input_cmr_search_stop_time
      # input_cmr_edl_user: input_cmr_edl_user
      # input_cmr_edl_pass: input_cmr_edl_pass
      output_collection_id: output_collection_id
      output_data_bucket: output_data_bucket
      input_daac_collection_shortname: input_daac_collection_shortname
      input_daac_collection_sns: input_daac_collection_sns
      dependency_stdout: create_job/results
      dependency_stderr: create_job/errors
    out:
    - results
    # FIXME: enable stdout, stderr
    # - stdout_file
    # - stderr_file

  update_job:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/publish_job_status.cwl
    in:
      job_id: job_id
      job_status:
        valueFrom: "succeeded"
      job_inputs: job_inputs
      jobs_data_sns_topic_arn: jobs_data_sns_topic_arn
      # FIXME
      dependency_output: [workflow/results, create_job/results]
      # dependency_stdout: [workflow/stdout_file, create_job/results]
      # dependency_stderr: [workflow/stderr_file, create_job/errors]
    out:
    - results
    - errors
