#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that downloads a file from S3 into the local system
doc: Requires valid AWS credentials as input arguments

$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
      - aws_region
      - aws_access_key_id
      - aws_secret_access_key
      - aws_session_token
  DockerRequirement:
    dockerPull: pymonger/aws-cli
requirements:
  InitialWorkDirRequirement:
    listing:
      - entryname: .aws/credentials
        entry: |
          [default]
          output = json
          region = $(inputs.aws_region)
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)
          aws_session_token = $(inputs.aws_session_token)

baseCommand: [aws]
arguments: [
  "s3",
  "cp",
  "$(inputs.source_s3_folder)/$(inputs.source_s3_filename)",
  "$(inputs.source_s3_filename)"
]

inputs:
  source_s3_folder:
    type: string
  source_s3_filename:
    type: string
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
  target_local_filename:
    type: File
    outputBinding:
      glob: "$(inputs.source_s3_filename)"
stdout: stdout_download_file_from_s3.txt
stderr: stderr_download_file_from_s3.txt

