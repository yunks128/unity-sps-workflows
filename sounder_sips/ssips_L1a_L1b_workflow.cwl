#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Workflow that executes the combined Sounder SIPS L1a +L1b end-to-end processing
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
  ScatterFeatureRequirement: {}

inputs:
  l1a_workflow_source_s3_folder: string
  l1a_workflow_source_s3_filename: string
  l1a_workflow_product_id: string
  l1a_workflow_min_sleep: int
  l1a_workflow_max_sleep: int
  l1a_workflow_target_s3_folder: string
  l1b_workflow_target_s3_folder: string
  workflow_aws_access_key_id: string
  workflow_aws_secret_access_key: string
  workflow_aws_session_token: string
outputs: 
  l1a_workflow_target_s3_folders: 
    type: string[]
    outputSource: ssips_L1a_workflow/workflow_target_s3_folders
  l1a_workflow_target_s3_subdirs:
    type: string[]
    outputSource: ssips_L1a_workflow/workflow_target_s3_subdirs
  l1b_workflow_target_s3_folders:
    type: string[]
    outputSource: [ssips_L1b_workflow/workflow_target_s3_folder]
  l1b_workflow_target_s3_subdirs:
    type: string[]
    outputSource: [ssips_L1b_workflow/workflow_target_s3_subdir]

steps:
  ssips_L1a_workflow:
    run: ssips_L1a_workflow.cwl
    in:
      workflow_source_s3_folder: l1a_workflow_source_s3_folder
      workflow_source_s3_filename: l1a_workflow_source_s3_filename
      workflow_product_id: l1a_workflow_product_id
      workflow_min_sleep: l1a_workflow_min_sleep
      workflow_max_sleep: l1a_workflow_max_sleep
      workflow_target_s3_folder: l1a_workflow_target_s3_folder
      workflow_aws_access_key_id: workflow_aws_access_key_id
      workflow_aws_secret_access_key: workflow_aws_secret_access_key
      workflow_aws_session_token: workflow_aws_session_token
    out:
      - workflow_target_s3_folders
      - workflow_target_s3_subdirs
  ssips_L1b_workflow:
    run: ssips_L1b_workflow.cwl
    scatter: workflow_source_s3_subdir
    in:
      workflow_source_s3_folder: l1a_workflow_target_s3_folder
      workflow_source_s3_subdir: ssips_L1a_workflow/workflow_target_s3_subdirs
      workflow_target_s3_folder: l1b_workflow_target_s3_folder
      workflow_aws_access_key_id: workflow_aws_access_key_id
      workflow_aws_secret_access_key: workflow_aws_secret_access_key
      workflow_aws_session_token: workflow_aws_session_token
    out:
      - workflow_target_s3_folder
      - workflow_target_s3_subdir
   

