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
  source_s3_folders:
    type: string[]
  source_s3_filenames:
    type: string[]
  static_dir: Directory
  target_s3_folder: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string

outputs:
  stdout_l1a-run-pge:
    type: File
    outputSource: l1a-run-pge/stdout_file
  stderr_l1a-run-pge:
    type: File
    outputSource: l1a-run-pge/stderr_file

steps:
  l1a-stage-in:
    run: download_files_from_s3.cwl
    in:
      source_s3_folders: source_s3_folders
      source_s3_filenames: source_s3_filenames
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - target_local_filenames

  l1a-run-pge:
    run: run_ssips_pge.cwl
    in:
      source_files: l1a-stage-in/target_local_filenames
      static_dir: static_dir
    out:
    - output_dir
    - stdout_file
    - stderr_file

  l1a-stage-out:
    run: upload_dir_to_s3.cwl
    in:
      source_local_subdir: l1a-run-pge/output_dir
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
