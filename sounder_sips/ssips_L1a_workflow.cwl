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

  # job specific parameters
  input_ephatt_collection_id: string
  input_science_collection_id: string
  output_collection_id: string
  static_dir: Directory
  start_datetime: string
  stop_datetime: string
  
  ephatt_download_dir:
    type: string
    default: ephatt
  science_download_dir:
    type: string
    default: atms_science
  
  # venue dependent parameters
  staging_bucket: string
  dapa_api: string
  client_id: string
  
  # fixed parameters
  provider_id:
    type: string
    default: SNPP
  username:
    type: string
    default: /sps/processing/workflows/unity_username
  password:
    type: string
    default: /sps/processing/workflows/unity_password
  password_type:
    type: string
    default: PARAM_STORE
  cognito_url: 
    type: string
    default: https://cognito-idp.us-west-2.amazonaws.com
  aws_region:
    type: string
    default: us-west-2

outputs:
  stdout_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stdout_file
  stderr_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stderr_file
  ephatt_downloaded_dir:
    type: Directory
    outputSource: l1a-stage-in-1/download_dir
  #stdout_stage-in-2:
  #  type: File
  #  outputSource: l1a-stage-in-2/stdout_file
  #stderr_stage-in-2:
  ##  type: File
  #  outputSource: l1a-stage-in-2/stderr_file
  science_downloaded_dir:
    type: Directory
    outputSource: l1a-stage-in-2/download_dir
  stdout_run-pge:
    type: File
    outputSource: l1a-run-pge/stdout_file
  stderr_run-pge:
    type: File
    outputSource: l1a-run-pge/stderr_file
  output_dir:
    type: Directory
    outputSource: l1a-run-pge/output_dir
  stdout_stage-out:
    type: File
    outputSource: l1a-stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: l1a-stage-out/stderr_file

steps:

  l1a-stage-in-1:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: ephatt_download_dir
      dapa_api: dapa_api
      collection_id: input_ephatt_collection_id
      start_datetime: start_datetime
      stop_datetime: stop_datetime
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
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: science_download_dir
      dapa_api: dapa_api
      collection_id: input_science_collection_id
      start_datetime: start_datetime
      stop_datetime: stop_datetime
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
    
  l1a-run-pge:
    run: https://raw.githubusercontent.com/unity-sds/sounder-sips-application/main/cwl/l1a_workflow.cwl
    in:
      input_ephatt_dir: l1a-stage-in-1/download_dir
      input_science_dir: l1a-stage-in-2/download_dir
      static_dir: static_dir
      start_datetime: start_datetime
      end_datetime: stop_datetime
    out:
    - output_dir
    - stdout_file
    - stderr_file
    
  l1a-stage-out:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/dapa_upload.cwl
    in:
      upload_dir: l1a-run-pge/output_dir
      collection_id: output_collection_id
      provider_id: provider_id
      dapa_api: dapa_api
      staging_bucket: staging_bucket
      aws_region: aws_region
      username: username
      password: password
      password_type: password_type
      client_id: client_id
      cognito_url: cognito_url
    out:
    - stdout_file
    - stderr_file
    
