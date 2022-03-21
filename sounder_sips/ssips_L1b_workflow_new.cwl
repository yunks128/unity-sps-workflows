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
      - aws_region
      - aws_access_key_id
      - aws_secret_access_key
      - aws_session_token

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  source_s3_folder: string
  source_s3_subdir: string
  static_dir: Directory
  target_s3_folder: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string

outputs:
  stdout_l1b-stage-in:
    type: File
    outputSource: l1b-stage-in/stdout_file
  stderr_l1b-stage-in:
    type: File
    outputSource: l1b-stage-in/stderr_file
  stdout_l1b-run-pge:
    type: File
    outputSource: l1b-run-pge/stdout_file
  stderr_l1b-run-pge:
    type: File
    outputSource: l1b-run-pge/stderr_file

steps:
  l1b-stage-in:
    run: download_dir_from_s3.cwl
    in:
      source_s3_folder: source_s3_folder
      source_s3_subdir: source_s3_subdir
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - target_local_subdir
    - stdout_file
    - stderr_file

  l1b-run-pge:
    run: run_ssips_L1b_pge.cwl
    in:
      input_dir: l1b-stage-in/target_local_subdir
      static_dir: static_dir
    out:
    - stdout_file
    - stderr_file
