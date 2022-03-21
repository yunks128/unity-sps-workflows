#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool the uploads recursively a local directory to S3
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
          region = $(inputs.aws_region)
          aws_access_key_id = $(inputs.aws_access_key_id)
          aws_secret_access_key = $(inputs.aws_secret_access_key)
          aws_session_token = $(inputs.aws_session_token)
      - $(inputs.source_local_subdir)

baseCommand: [aws]
arguments: [
  "s3",
  "cp",
  "--recursive",
  "$(inputs.source_local_subdir.basename)",
  "$(inputs.target_s3_folder)/$(inputs.source_local_subdir.basename)"
]

inputs:
  aws_region: string
  aws_access_key_id: string
  aws_secret_access_key: string
  aws_session_token: string
  source_local_subdir:
    type: Directory
  target_s3_folder:
    type: string
outputs:
  target_s3_folder: 
    type: string
    outputBinding:
      outputEval: $(inputs.target_s3_folder)
  target_s3_subdir:
    type: string
    outputBinding:
      outputEval: $(inputs.source_local_subdir.basename)
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: upload_dir_to_s3_stdout.txt
stderr: upload_dir_to_s3_stderr.txt

