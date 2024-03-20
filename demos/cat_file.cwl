#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool
hints:
  DockerRequirement:
    dockerPull: busybox
baseCommand: cat

requirements:
  InitialWorkDirRequirement:
    listing:
      - $(inputs.the_file)

inputs:
  the_file:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)

outputs:
  standard_out:
    type: stdout
stdout: cat_file.txt
