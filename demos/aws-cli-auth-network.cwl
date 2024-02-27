#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: ["s3", "ls"]  # Example AWS CLI command

hints:
  DockerRequirement:
    dockerPull: amazon/aws-cli:latest  # AWS CLI Docker image

requirements:
  NetworkAccess:
    networkAccess: true

  InitialWorkDirRequirement:
    listing:
      - entryname: web_identity_token  # Fixed name for the token file inside the container
        entry: $(inputs.token_file)

  EnvVarRequirement:
    envDef:
      AWS_ROLE_ARN:
        envName: "AWS_ROLE_ARN"
        envValue: $(inputs.aws_role_arn)
      AWS_WEB_IDENTITY_TOKEN_FILE:
        envName: "AWS_WEB_IDENTITY_TOKEN_FILE"
        # Use a fixed path based on the entryname given above
        envValue: $(runtime.outdir)/web_identity_token

inputs:
  token_file:
    type: File
    # Path to the token file on the Kubernetes pod
  aws_role_arn:
    type: string
    # AWS Role ARN for authentication

outputs: []  # Adjust based on your actual output requirements
