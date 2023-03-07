#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool
baseCommand: python
requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.script)
inputs:
  script:
    type: File
    default:
      class: File
      path: chirp-rebinning.py
    inputBinding:
      position: 0
  granules:
    type: File
    inputBinding:
      position: 1
      prefix: -g
outputs:
  products:
    type: File
    outputBinding:
      glob: products.txt
