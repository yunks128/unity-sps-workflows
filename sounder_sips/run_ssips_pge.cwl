#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.source_files)
      - entryname: my_script.sh
        entry: |-
          echo "Working Directory:"
          ls -l $1
          echo "Static Directory:"
          ls -l $2
          echo "Input Directory:"
          mkdir ./in
          cp *.PDS in/.
          ls -l in
          echo "Output Directory:"
          mkdir ./out
          cp in/*.PDS out/.
          ls -l out

hints:
  DockerRequirement:
    dockerPull: alpine:latest
baseCommand: ["sh", "my_script.sh"]
arguments: [
  "$(runtime.outdir)",
  "$(inputs.static_dir)"
]

inputs:
  source_files:
    type: File[]
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


