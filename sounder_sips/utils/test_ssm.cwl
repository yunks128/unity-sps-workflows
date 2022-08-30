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
    dockerPull: pymonger/aws-cli
baseCommand: [aws]
arguments: [
  "ssm",
  "get-parameter",
  "--name",
  "$(inputs.password)",
  "--with-decryption"
]
   
requirements:
  EnvVarRequirement:
    envDef:
      USERNAME: $(inputs.username)
      PASSWORD: $(inputs.password)
      AWS_DEFAULT_REGION: $(inputs.aws_region)

inputs:
  aws_region: string
  username: string
  password: string
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: test_ssm_stdout.txt
stderr: test_ssm_stderr.txt

