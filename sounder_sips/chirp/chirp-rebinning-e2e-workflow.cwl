#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: Workflow
label: Workflow that executes the Sounder SIPS end-to-end CHIRP rebinning workflow

$namespaces:
  cwltool: http://commonwl.org/cwltool#

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}

inputs:
  input_cmr_collection_name: string
  input_cmr_search_start_time: string
  input_cmr_search_stop_time: string
  input_cmr_edl_user: string
  input_cmr_edl_pass: string

outputs:
  results:
    type: File
    outputSource: chirp-rebinning/products
  stdout_file: 
    outputSource: chirp-rebinning/stdout_file
    type: File
  stderr_file:
    outputSource: chirp-rebinning/stderr_file
    type: File

steps:

  cmr-step:
    run: cmr-tool-wrapper.cwl
    in:
      cmr_collection: input_cmr_collection_name
      cmr_start_time: input_cmr_search_start_time
      cmr_stop_time: input_cmr_search_stop_time
      cmr_edl_user: input_cmr_edl_user
      cmr_edl_pass: input_cmr_edl_pass
    out:
    - results

  chirp-rebinning:
    run: chirp-rebinning.cwl
    in:
      granules: cmr-step/results
    out:
    - products
    - stdout_file
    - stderr_file
