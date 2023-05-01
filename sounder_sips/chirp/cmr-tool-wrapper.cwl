#!/usr/bin/env cwl-runner

cwlVersion: v1.2
class: CommandLineTool

hints:
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-sps-prototype/chirp-rebinning:unity-v0.1
baseCommand: ["/usr/app/cmr-tool-wrapper.py"]

inputs:
  cmr_collection:
    type: string
    inputBinding:
      prefix: -c
  cmr_start_time:
    type: string
    inputBinding:
      prefix: --start_datetime
  cmr_stop_time:
    type: string
    inputBinding:
      prefix: --stop_datetime
  cmr_edl_user:
    type: string
    default: 'none'
    inputBinding:
      prefix: --edl_username
  cmr_edl_pass:
    type: string
    default: 'none'
    inputBinding:
      prefix: --edl_password

outputs:
  results:
    type: File
    outputBinding:
      glob: cmr_results.txt

