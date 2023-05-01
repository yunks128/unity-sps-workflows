#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-sps-prototype/chirp-rebinning:unity-v0.1
baseCommand: ["/usr/app/chirp-rebinning.py"]

inputs:
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
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: chirp-rebinning_stdout.txt
stderr: chirp-rebinning_stderr.txt
