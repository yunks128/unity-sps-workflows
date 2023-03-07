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
  granules:
    type: File

outputs:
  products:
    type: File
    outputSource: chirp-rebinning/products

steps:

  chirp-rebinning:
    run: chirp-rebinning.cwl
    in:
      granules: granules
      
    out:
    - products
