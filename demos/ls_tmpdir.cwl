#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}

hints:
  DockerRequirement:
    dockerPull: alpine:latest
baseCommand: [ls]
arguments: [
  "-l",
  "$(runtime.tmpdir)"
]

inputs: []

outputs:
  dataset_dirs:
    type:
      type: array
      items: Directory
    outputBinding:
      glob: "dumby-product-*"
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: run_ssips_pge_stdout.txt
stderr: run_ssips_pge_stderr.txt


