#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: python:latest
baseCommand: python

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
