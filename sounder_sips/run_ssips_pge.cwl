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
          export input_dir=$2
          export static_dir=$4
          export output_dir=$6
          echo "Input Directory:"
          ls -l $input_dir
          echo "Static Directory:"
          ls -l $static_dir
          echo "Output Directory:"
          mkdir -p $output_dir
          cp $input_dir/*.PDS $output_dir/.
          ls -l $output_dir

hints:
  DockerRequirement:
    dockerPull: alpine:latest
baseCommand: ["sh", "my_script.sh"]
arguments: [
  "--input_dir",
  "$(runtime.outdir)",
  "--static_dir",
  "$(inputs.static_dir)",
  "--output_dir",
  "$(runtime.outdir)/out_dir"
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


