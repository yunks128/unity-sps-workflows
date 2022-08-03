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
      - aws_access_key_id
      - aws_secret_access_key
      - aws_session_token
      - unity_token
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-data-services:1.5.15
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: .aws/credentials
        entry: |
          [default]
          output = json
          aws_region = $(inputs.aws_region)
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)
          aws_session_token = $(inputs.aws_session_token)
  EnvVarRequirement:
    envDef:
      UNITY_BEARER_TOKEN: $(inputs.unity_token)
      AWS_REGION: $(inputs.aws_region)
      AWS_ACCESS_KEY_ID: $(inputs.aws_access_key_id)
      AWS_SECRET_ACCESS_KEY: $(inputs.aws_secret_access_key)
      AWS_SESSION_TOKEN: $(inputs.aws_session_token)
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
  unity_token: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  download_dir: string
  dapa_api: string
  collection_id: string
  start_datetime: string
  stop_datetime: string
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

