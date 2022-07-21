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
  download_dir: string
  dapa_api: string
  input_collection_id_1: string
  input_collection_id_2: string
  static_dir: Directory
  target_s3_folder: string
  start_datetime: string
  end_datetime: string
  unity_token: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  command: string

outputs:
  stdout_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stdout_file
  stderr_stage-in-1:
    type: File
    outputSource: l1a-stage-in-1/stderr_file
  #stdout_stage-in-1:
  #  type: File
  #  outputSource: l1a-stage-in-1/stdout_file
  #stderr_stage-in-1:
  #  type: File
  #  outputSource: l1a-stage-in-1/stderr_file
  stdout_run-pge:
    type: File
    outputSource: l1a-run-pge/stdout_file
  stderr_run-pge:
    type: File
    outputSource: l1a-run-pge/stderr_file
  stdout_stage-out:
    type: File
    outputSource: l1a-stage-out/stdout_file
  stderr_stage-out:
    type: File
    outputSource: l1a-stage-out/stderr_file
  output_target_s3_folder:
    type: string
    outputSource: l1a-stage-out/target_s3_folder
  output_target_s3_subdir:
    type: string
    outputSource: l1a-stage-out/target_s3_subdir
  stdout_stage-in-dir-1:
    type: File
    outputSource: ls_stage-in-dir-1/stdout_file
  stderr_stage-in-dir-1:
    type: File
    outputSource: ls_stage-in-dir-1/stderr_file

steps:
  l1a-stage-in-1:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_collection_id_1
      start_datetime: start_datetime
      stop_datetime: end_datetime
      unity_token: unity_token
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - download_dir
    - stdout_file
    - stderr_file
  l1a-stage-in-2:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/dapa_download.cwl
    in:
      download_dir: download_dir
      dapa_api: dapa_api
      collection_id: input_collection_id_2
      start_datetime: start_datetime
      stop_datetime: end_datetime
      unity_token: unity_token
      aws_region: aws_region
      aws_access_key_id: aws_access_key_id
      aws_secret_access_key: aws_secret_access_key
      aws_session_token: aws_session_token
    out:
    - download_dir
    - stdout_file
    - stderr_file
    
  ls_stage-in-dir-1:
    run: https://raw.githubusercontent.com/unity-sds/unity-sps-workflows/devel/sounder_sips/utils/exec_sh_command.cwl
    in:
      command: [ls, -l, $(l1a-stage-in-1/download_dir)]
    out:
    - stdout_file
    - stderr_file
      
  l1a-run-pge:
    # run: run_ssips_L1a_pge.cwl
    run: l1a_package.cwl
    in:
      input_dir: l1a-stage-in-1/download_dir
      static_dir: static_dir
      start_datetime: start_datetime
      end_datetime: end_datetime
    out:
    - output_dir
    - stdout_file
    - stderr_file

  l1a-stage-out:
    run: utils/upload_dir_to_s3.cwl
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
