#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that runs the Sounder SIPS L1a PGE
doc: The PGE is packaged as a Docker container

hints:
  DockerRequirement:
    dockerPull: lucacinquini/baseline-pge:latest
baseCommand: [/home/ops/verdi/ops/baseline_pge/dumby_landsat_cwl2.sh]
requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input_file)
inputs:
  product_id:
    type: string
    inputBinding:
      position: 1
  min_sleep:
    type: int
    inputBinding:
      position: 2
  max_sleep:
    type: int
    inputBinding:
      position: 3
  input_file:
    type: File
    inputBinding:
      position: 4
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
stdout: stdout_run-l1a-pge.txt
stderr: stderr_run-l1a-pge.txt
