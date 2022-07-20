#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: alpine:latest
baseCommand: [sh]
arguments: [
  "-c",
  "$(inputs.command)"
]

inputs: 
  command: string

outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: stdout_exec_sh_command.txt
stderr: stderr_exec_sh_command.txt


