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
requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:

  # job specific parameters
  input_collection_id: string
  output_collection_id: string
  start_datetime: string
  stop_datetime: string
  
  # venue dependent parameters
  dapa_api: string
  staging_bucket: string
  
  # fixed parameters
  aws_region:
    type: string
    default: us-west-2
  provider_id:
    type: string
    default: SNPP
  jwt_token:
    type: string
  download_dir:
    type: string
    default: granules

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
  output_dir:
    type: Directory
    outputSource: l1b-run-pge/output_dir
  stdout_stage-out:
    type: File
    outputSource: l1b-stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: l1b-stage-out/stderr_file

steps:
  l1b-stage-in:
    # FIXME
    # run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/dapa_download.cwl
    run: utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_collection_id
      # staging_bucket: staging_bucket
      # provider_id: provider_id
      start_datetime: start_datetime
      stop_datetime: stop_datetime
      jwt_token: jwt_token
      aws_region: aws_region
    out:
    - download_dir
    - stdout_file
    - stderr_file

  l1b-run-pge:
    # run: https://raw.githubusercontent.com/unity-sds/sounder-sips-application/main/cwl/l1b_workflow.cwl
    run: http://uads-test-dockstore-deploy-lb-1762603872.us-west-2.elb.amazonaws.com:9998/api/ga4gh/trs/v2/tools/%23workflow%2Fgithub.com%2Fnlahaye%2Fsounder-sips-application%2Fsounder_sips_l1b/versions/main/PLAIN-CWL/descriptor/%2Fcwl%2Fl1b_workflow.cwl
    in:
      input_dir: l1b-stage-in/download_dir
    out:
    - output_dir
    - stdout_file
    - stderr_file

  l1b-stage-out:
    # FIXME
    # run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/main/sounder_sips/utils/dapa_upload.cwl
    run: utils/dapa_upload.cwl
    in:
      upload_dir: l1b-run-pge/output_dir
      collection_id: output_collection_id
      provider_id: provider_id
      dapa_api: dapa_api
      staging_bucket: staging_bucket
      aws_region: aws_region
      jwt_token: jwt_token
    out:
    - stdout_file
    - stderr_file
