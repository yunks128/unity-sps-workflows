#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["s3", "ls"]

hints:
  DockerRequirement:
    dockerPull: amazon/aws-cli:latest

requirements:
  EnvVarRequirement:
    envDef:
      AWS_ROLE_ARN:
        envName: AWS_ROLE_ARN
        envValue: $(inputs.aws_role_arn)
      AWS_WEB_IDENTITY_TOKEN_FILE:
        envName: AWS_WEB_IDENTITY_TOKEN_FILE
        envValue: $(inputs.aws_web_identity_token_file)

inputs:
  aws_role_arn:
    type: string
  aws_web_identity_token_file:
    type: string

outputs: []
