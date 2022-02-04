#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Workflow that executes the Sounder SIPS end-to-end L1a processing
doc: Requires valid AWS credentials as input arguments

$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  "cwltool:Secrets":
    secrets:
      - workflow_aws_access_key_id
      - workflow_aws_secret_access_key
      - workflow_aws_session_token

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  workflow_source_s3_folder: string
  workflow_source_s3_filename: string
  workflow_product_id: string
  workflow_min_sleep: int
  workflow_max_sleep: int
  workflow_target_s3_folder: string
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_aws_session_token: string

outputs:
  workflow_target_s3_folders:
    type: string[]
    outputSource: [l1a-stage-out/target_s3_folder]
  workflow_target_s3_subdirs:
    type: string[]
    outputSource: [l1a-stage-out/target_s3_subdir]
  stdout_l1a-stage-in:
    type: File
    outputSource: l1a-stage-in/stdout_file
  stderr_l1a-stage-in:
    type: File
    outputSource: l1a-stage-in/stderr_file
  stdout_l1a-run-pge:
    type: File
    outputSource: l1a-run-pge/stdout_file
  stderr_l1a-run-pge:
    type: File
    outputSource: l1a-run-pge/stderr_file
  #stdout_stage-out:
  #  type: File
  #  outputSource: stage-out/stdout_file
  #stderr_stage-out:
  #  type: File
  #  outputSource: stage-out/stderr_file

steps:
  l1a-stage-in:
    run: download_file_from_s3.cwl
    in:
      source_s3_folder: workflow_source_s3_folder
      source_s3_filename: workflow_source_s3_filename
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      aws_session_token: workflow_aws_session_token
    out:
    - target_local_filename
    - stdout_file
    - stderr_file

  l1a-run-pge:
    run: run_ssips_L1a_pge.cwl
    in:
      product_id: workflow_product_id
      min_sleep: workflow_min_sleep
      max_sleep: workflow_max_sleep
      input_file: l1a-stage-in/target_local_filename
    out:
    - dataset_dirs
    - stdout_file
    - stderr_file

  l1a-stage-out:
    run: upload_dir_to_s3.cwl
    scatter: source_local_subdir
    in:
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      aws_session_token: workflow_aws_session_token
      source_local_subdir: l1a-run-pge/dataset_dirs
      target_s3_folder: workflow_target_s3_folder
    out:
      - target_s3_folder
      - target_s3_subdir

