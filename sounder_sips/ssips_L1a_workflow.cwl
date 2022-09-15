#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Workflow that executes the Sounder SIPS end-to-end L1a processing
doc: Cognito credentials to access the U-DS services are retrieved from the AWS Parameter Store with the supplied keys. 
     
$namespaces:
  cwltool: http://commonwl.org/cwltool#

hints:
  "cwltool:Secrets":
    secrets:
      - username
      - password
      - client_id

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs: 
  input_ephatt_collection_id: string
  input_science_collection_id: string
  output_collection_id: string
  static_dir: Directory
  start_datetime: string
  stop_datetime: string
  
  download_dir: string
  
  dapa_api: string
  username: string
  password: string
  password_type: string
  client_id: string
  cognito_url: string
  aws_region: string

outputs:
  stdout_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stdout_file
  stderr_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stderr_file
  #stdout_stage-in-2:
  #  type: File
  #  outputSource: l1a-stage-in-2/stdout_file
  #stderr_stage-in-2:
  ##  type: File
  #  outputSource: l1a-stage-in-2/stderr_file

steps:
  l1a-stage-in-1:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_ephatt_collection_id
      start_datetime: start_datetime
      stop_datetime: end_datetime
      username: username
      password: password
      password_type: password_type
      client_id: client_id
      cognito_url: cognito_url
      aws_region: aws_region
    out:
    - download_dir
    - stdout_file
    - stderr_file
  l1a-stage-in-2:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_science_collection_id
      start_datetime: start_datetime
      stop_datetime: end_datetime
      username: username
      password: password
      password_type: password_type
      client_id: client_id
      cognito_url: cognito_url
      aws_region: aws_region
    out:
    - download_dir
    - stdout_file
    - stderr_file
    