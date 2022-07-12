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
      - unity_token

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  download_dir: string
  dapa_api: string
  collection_id: string
  start_datetime: string
  stop_datetime: string
  static_dir: Directory
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  unity_token: string
  target_s3_folder: string

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
  stdout_stage-out:
    type: File
    outputSource: l1b-stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: l1b-stage-out/stderr_file
  output_target_s3_folder:
    type: string
    outputSource: l1b-stage-out/target_s3_folder
  output_target_s3_subdir:
    type: string
    outputSource: l1b-stage-out/target_s3_subdir

steps:
  l1b-stage-in:
    run: utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: collection_id
      start_datetime: start_datetime
      stop_datetime: stop_datetime
      unity_token: unity_token
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - download_dir
    - stdout_file
    - stderr_file

  l1b-run-pge:
    run: l1b_package.cwl
    in:
      input_dir: l1b-stage-in/download_dir
      static_dir: static_dir
    out:
    - output_dir
    - stdout_file
    - stderr_file

  l1b-stage-out:
    run: utils/upload_dir_to_s3.cwl
    in:
      source_local_subdir: l1b-run-pge/output_dir
      target_s3_folder: target_s3_folder
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - target_s3_folder
    - target_s3_subdir
    - stdout_file
    - stderr_file

