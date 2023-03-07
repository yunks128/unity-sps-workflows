#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-sps-prototype/chirp-rebinning:unity-v0.1
#requirements:
#  InitialWorkDirRequirement:
#    listing:
#      - $(inputs.script)

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
