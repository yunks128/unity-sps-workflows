#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
label: Demo combined workflow that scatters the output of the first workflow to invoke the second workflow N times.

requirements:
  SubworkflowFeatureRequirement: {}
  ScatterFeatureRequirement: {}

inputs:
  L1a_script: File
  L1b_script: File
  base_filename: string
outputs: 
  los_files:
    type:
      type: array
      items:
        type: array
        items: File
    outputSource: L1b_pge/the_files

steps:
  L1a_pge:
    run: L1a.cwl
    in:
      script_name: L1a_script
      base_filename: base_filename
    out: [the_files]

  L1b_pge:
    run: L1b.cwl
    scatter: filename
    in:
      script_name: L1b_script
      filename: L1a_pge/the_files
    out: [the_files]
