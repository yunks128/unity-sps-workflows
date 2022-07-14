#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that uploads data to the Unity DAPA server
doc: Requires valid AWS credentials as input arguments. Also the target collection must exist.

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
    dockerPull: ghcr.io/unity-sds/unity-data-services:1.5.14
requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.upload_dir)
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
      UPLOAD_DIR: $(runtime.outdir)/$(inputs.upload_dir.basename)
      PROVIDER_ID: $(inputs.provider_id)
      DAPA_API: $(inputs.dapa_api)
      COLLECTION_ID: $(inputs.collection_id)
      STAGING_BUCKET: $(inputs.staging_bucket)
      DELETE_FILES: 'FALSE'
      VERIFY_SSL: 'FALSE'

baseCommand: [upload]

inputs:
  unity_token: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  upload_dir:
     type: Directory
  dapa_api: string
  collection_id: string
  provider_id: string
  staging_bucket: string
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: stdout_dapa_upload.txt
stderr: stderr_dapa_upload.txt

