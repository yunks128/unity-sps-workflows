#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Demo workflow that generates N files
baseCommand: sh

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.script_name)

inputs:
  script_name:
    type: File
    inputBinding:
      position: 0
  base_filename:
    type: string
    inputBinding:
      position: 1

outputs:
  the_files:
    type: File[]
    outputBinding:
      glob: "*.dat"
