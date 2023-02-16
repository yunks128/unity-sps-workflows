#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that downloads data from the Unity DAPA server
doc: Requires valid AWS credentials as input arguments

$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - jwt_token
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-data-services:1.10.1
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: .aws/config
        entry: |
          [default]
          output = json
          aws_region = $(inputs.aws_region)
  EnvVarRequirement:
    envDef:
      UNITY_BEARER_TOKEN: $(inputs.jwt_token)
      AWS_REGION: $(inputs.aws_region)
      LOG_LEVEL: '20'
      DOWNLOAD_DIR: $(runtime.outdir)/$(inputs.download_dir)
      DAPA_API: $(inputs.dapa_api)
      COLLECTION_ID: $(inputs.collection_id)
      LIMITS: '100'
      DATE_FROM: $(inputs.start_datetime)
      DATE_TO: $(inputs.stop_datetime)
      VERIFY_SSL: 'FALSE'

baseCommand: [download]

inputs:

  collection_id: string
  start_datetime: string
  stop_datetime: string
  download_dir: string
  
  jwt_token: string
  dapa_api: string
  
  aws_region:
    type: string
    default: us-west-2
  
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
  download_dir:
    type: Directory
    outputBinding:
      glob: "$(inputs.download_dir)"
stdout: stdout_dapa_download.txt
stderr: stderr_dapa_download.txt
