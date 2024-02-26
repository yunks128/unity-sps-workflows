#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: amazon/aws-cli:latest
baseCommand: ["s3", "ls"]

inputs: []
outputs: []
