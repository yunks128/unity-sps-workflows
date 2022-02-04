#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Workflow that executes the Sounder SIPS end-to-end L1b processing
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

inputs:
  workflow_source_s3_folder: string
  workflow_source_s3_subdir: string
  workflow_target_s3_folder: string
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_aws_session_token: string

outputs:
  workflow_target_s3_folder:
    type: string
    outputSource: l1b-stage-out/target_s3_folder
  workflow_target_s3_subdir:
    type: string
    outputSource: l1b-stage-out/target_s3_subdir
  stdout_stage-in:
    type: File
    outputSource: l1b-stage-in/stdout_file
  stderr_stage-in:
    type: File
    outputSource: l1b-stage-in/stderr_file
  stdout_run-pge:
    type: File
    outputSource: l1b-run-pge/stdout_file
  stderr_run-pge:
    type: File
    outputSource: l1b-run-pge/stderr_file
  stdout_stage-out:
    type: File
    outputSource: l1b-stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: l1b-stage-out/stderr_file
steps:
  l1b-stage-in:
    run: download_dir_from_s3.cwl
    in:
      source_s3_folder: workflow_source_s3_folder
      source_s3_subdir: workflow_source_s3_subdir
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      aws_session_token: workflow_aws_session_token
    out:
    - target_local_subdir
    - stdout_file
    - stderr_file

  l1b-run-pge:
    run: run_ssips_L1b_pge.cwl
    in:
      src_dir: l1b-stage-in/target_local_subdir
    out:
    - tgt_dir
    - stdout_file
    - stderr_file

  l1b-stage-out:
    run: upload_dir_to_s3.cwl
    in:
      aws_access_key_id: workflow_aws_access_key_id
      aws_secret_access_key: workflow_aws_secret_access_key
      aws_session_token: workflow_aws_session_token
      source_local_subdir: l1b-run-pge/tgt_dir
      target_s3_folder: workflow_target_s3_folder
    out:
    - target_s3_folder
    - target_s3_subdir
    - stdout_file
    - stderr_file

