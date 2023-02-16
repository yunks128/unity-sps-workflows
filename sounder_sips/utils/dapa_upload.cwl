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
      - jwt_token
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
      UNITY_BEARER_TOKEN: $(inputs.jwt_token)
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
     
  jwt_token: string
  dapa_api: string
  staging_bucket: string
  
  aws_region:
    type: string
    default: us-west-2
    
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

