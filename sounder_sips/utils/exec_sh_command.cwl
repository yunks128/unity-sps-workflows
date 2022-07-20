#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: ubuntu:latest
baseCommand: [sh, -c]
arguments: [$(inputs.commands)] 

inputs: 
  commands: string[]

outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: stdout_exec_sh_command.txt
stderr: stderr_exec_sh_command.txt


