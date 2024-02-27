#!/usr/bin/env cwl-runner
$namespaces:
  cwltool: http://commonwl.org/cwltool#
class: Workflow
cwlVersion: v1.2
inputs:
  parameters:
    type:
      fields:
        crid:
        - 'null'
        - string
        output_collection:
        - 'null'
        - string
        sensor:
        - 'null'
        - string
        temp_directory:
        - 'null'
        - string
      type: record
  stage_in:
    type:
      fields:
        download_type: string
        downloading_keys:
        - string
        - 'null'
        edl_password:
        - string
        - 'null'
        edl_password_type:
        - string
        - 'null'
        edl_username:
        - string
        - 'null'
        stac_json: File
      type: record
  stage_out:
    type:
      fields:
        aws_access_key_id:
        - string
        - 'null'
        aws_region:
        - string
        - 'null'
        aws_secret_access_key:
        - string
        - 'null'
        aws_session_token:
        - string
        - 'null'
        collection_id:
        - string
        - 'null'
        staging_bucket:
        - string
        - 'null'
      type: record
outputs:
  stage_out_results:
    outputSource: stage_out/stage_out_results
    type: File
requirements:
  InlineJavascriptRequirement: {}
  NetworkAccess:
    networkAccess: true
  StepInputExpressionRequirement: {}
  SubworkflowFeatureRequirement: {}
steps:
  process:
    in:
      crid:
        source: parameters
        valueFrom: $(self.crid)
      download_dir: stage_in/stage_in_download_dir
      output_collection:
        source: parameters
        valueFrom: $(self.output_collection)
      sensor:
        source: parameters
        valueFrom: $(self.sensor)
      temp_directory:
        source: parameters
        valueFrom: $(self.temp_directory)
    out:
    - process_output_dir
    - process_output_nb
    run: process.cwl
  stage_in:
    in:
      download_type:
        source: stage_in
        valueFrom: $(self.download_type)
      downloading_keys:
        source: stage_in
        valueFrom: $(self.downloading_keys)
      edl_password:
        source: stage_in
        valueFrom: $(self.edl_password)
      edl_password_type:
        source: stage_in
        valueFrom: $(self.edl_password_type)
      edl_username:
        source: stage_in
        valueFrom: $(self.edl_username)
      stac_json:
        source: stage_in
        valueFrom: $(self.stac_json)
    out:
    - stage_in_collection_file
    - stage_in_download_dir
    run: stage_in.cwl
  stage_out:
    in:
      aws_access_key_id:
        source: stage_out
        valueFrom: $(self.aws_access_key_id)
      aws_secret_access_key:
        source: stage_out
        valueFrom: $(self.aws_secret_access_key)
      aws_session_token:
        source: stage_out
        valueFrom: $(self.aws_session_token)
      collection_id:
        source: stage_out
        valueFrom: $(self.collection_id)
      output_dir: process/process_output_dir
      staging_bucket:
        source: stage_out
        valueFrom: $(self.staging_bucket)
    out:
    - stage_out_results
    run: stage_out.cwl
