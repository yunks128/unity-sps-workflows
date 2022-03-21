#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Workflow that downloads a list of files from S3 into the local system
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
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
outputs:
   target_local_filenames:
     type: File[]
     outputSource: [download_file_from_s3/target_local_filename]
   stdout_files:
     type: File[]
     outputSource: [download_file_from_s3/stdout_file]
   stderr_files:
     type: File[]
     outputSource: [download_file_from_s3/stderr_file]

steps:
  download_file_from_s3:
    run: download_file_from_s3.cwl
    scatter: [source_s3_filename, source_s3_folder]
    scatterMethod: dotproduct
    in:
      source_s3_folder: source_s3_folders
      source_s3_filename: source_s3_filenames
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - target_local_filename
    - stdout_file
    - stderr_file
