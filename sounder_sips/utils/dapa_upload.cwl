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
      - username
      - password
      - client_id
  DockerRequirement:
    dockerPull: ghcr.io/unity-sds/unity-data-services:1.10.1
requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.upload_dir)
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
      UPLOAD_DIR: $(runtime.outdir)/$(inputs.upload_dir.basename)
      PROVIDER_ID: $(inputs.provider_id)
      DAPA_API: $(inputs.dapa_api)
      COLLECTION_ID: $(inputs.collection_id)
      STAGING_BUCKET: $(inputs.staging_bucket)
      DELETE_FILES: 'FALSE'
      VERIFY_SSL: 'FALSE'

baseCommand: [upload]

inputs:
 
  collection_id: string
  provider_id: string
  upload_dir:
     type: Directory
     
  client_id: string
  dapa_api: string
  staging_bucket: string
  
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
  uploaded_dir:
    type: Directory
    outputBinding:
      glob: "$(runtime.outdir)/$(inputs.upload_dir.basename)"
stdout: stdout_dapa_upload.txt
stderr: stderr_dapa_upload.txt

