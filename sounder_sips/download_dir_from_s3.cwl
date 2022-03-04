#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that downloads recursively an S3 URL into a local directory
doc: Requires valid AWS credentials as input arguments

$namespaces:
  cwltool: http://commonwl.org/cwltool#
hints:
  "cwltool:Secrets":
    secrets:
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
          aws_region = $(inputs.aws_region)
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)
          aws_session_token = $(inputs.aws_session_token)

baseCommand: [aws]
arguments: [
  "s3",
  "cp",
  "--recursive",
  "$(inputs.source_s3_folder)/$(inputs.source_s3_subdir)",
  "$(inputs.source_s3_subdir)"
]

inputs:
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  source_s3_folder:
    type: string
  source_s3_subdir:
    type: string
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
  target_local_subdir:
    type: Directory
    outputBinding:
      glob: "$(inputs.source_s3_subdir)"
stdout: stdout_download_dir_from_s3.txt
stderr: stderr_download_dir_from_s3.txt

