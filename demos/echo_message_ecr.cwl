#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
baseCommand: echo
arguments: [$(inputs.message)]

hints:
  DockerRequirement:
    dockerPull: 429178552491.dkr.ecr.us-west-2.amazonaws.com/unity-nikki-1-dev-sps-busybox:latest

inputs:
  message:
    type: string

outputs:
  the_output:
    type: stdout
stdout: echo_message.txt
