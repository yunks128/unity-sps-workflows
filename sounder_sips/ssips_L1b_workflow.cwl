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
  input_collection_id: string
  output_collection_id: string
  start_datetime: string
  stop_datetime: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  unity_token: string
  staging_bucket: string
  provider_id: string

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

steps:
  l1b-stage-in:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_collection_id
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
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/l1b_package.cwl
    in:
      input_dir: l1b-stage-in/download_dir
    out:
    - output_dir
    - stdout_file
    - stderr_file

  l1b-stage-out:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_upload.cwl
    in:
      upload_dir: l1b-run-pge/output_dir
      collection_id: output_collection_id
      provider_id: provider_id
      dapa_api: dapa_api
      staging_bucket: staging_bucket
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
      unity_token: unity_token
    out:
    - stdout_file
    - stderr_file

