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
      - username
      - password
      - client_id
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
      USERNAME: $(inputs.username)
      PASSWORD: $(inputs.password)
      PASSWORD_TYPE: $(inputs.password_type)
      CLIENT_ID: $(inputs.client_id)
      COGNITO_URL: $(inputs.cognito_url)
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
  
  dapa_api: string
  client_id: string
  
  aws_region:
    type: string
    default: us-west-2
  username: 
    type: string
    default: usps_username
  password: 
    type: string
    default: usps_password
  password_type: 
    type: string
    default: PARAM_STORE
  cognito_url:
    type: string
    default: https://cognito-idp.us-west-2.amazonaws.com
  
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

