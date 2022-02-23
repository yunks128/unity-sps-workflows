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
          mkdir ./in_dir
          cp *.PDS in_dir/.
          ls -l in_dir
          echo "Output Directory:"
          mkdir ./out_dir
          cp in_dir/*.PDS out_dir/.
          ls -l out_dir

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
  output_dir:
    type: Directory
    outputBinding:
      glob: "out_dir"
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: run_ssips_pge_stdout.txt
stderr: run_ssips_pge_stderr.txt


