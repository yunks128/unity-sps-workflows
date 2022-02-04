#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that runs the Sounder SIPS L1b PGE
doc: The PGE is packaged as a Docker container

hints:
  DockerRequirement:
    dockerPull: lucacinquini/baseline-pge:latest

baseCommand: [/home/ops/verdi/ops/baseline_pge/copy_dir.sh]

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.src_dir)

inputs:
  src_dir:
    type: Directory
    inputBinding:
      position: 1

outputs:
  tgt_dir:
    type: Directory
    outputBinding:
      glob: "*_processed"
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: stdout_run-l1b-pge.txt
stderr: stderr_run-l1b-pge.txt

