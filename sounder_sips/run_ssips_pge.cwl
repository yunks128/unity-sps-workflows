#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - entryname: my_script.sh
        entry: |-
          echo "Input Directory:"
          ls -l $1
          echo "Static Directory:"
          ls -lR $2
          echo "Output Directory:"
          ls -lR $3

hints:
  DockerRequirement:
    dockerPull: alpine:latest
baseCommand: ["sh", "my_script.sh"]
arguments: [
  "$(runtime.tmpdir)",
  "$(inputs.static_dir)",
  "$(runtime.outdir)"
]

inputs:
  static_dir:
    type: Directory

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


