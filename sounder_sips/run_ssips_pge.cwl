#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool

requirements:
  InlineJavascriptRequirement: {}
  InitialWorkDirRequirement:
    listing:
      - $(inputs.input_dir)
      - $(inputs.static_dir)
      - entryname: my_script.sh
        entry: |-
          export input_dir=$3
          export output_dir=$6
          export static_dir=$9
          mkdir -p /pge/in /pge/out
          cp -R $input_dir/* /pge/in/.
          echo "Input Directory:"
          ls -l /pge/in
          echo "Static Directory:"
          ls -l $static_dir

          papermill /pge/interface/run_l1a_pge.ipynb -p input_path /pge/in -p output_path /pge/out -p data_static_path $static_dir -
          #cp -R /pge/in/* /pge/out/.
          cp -R /pge/out .
          echo "Output Directory:"
          ls -lR ./out


hints:
  DockerRequirement:
    dockerPull: unity-sds/sounder_sips_l1a_pge:r0.1.0
  EnvVarRequirement:
      envDef:
        SIPS_STATIC_DIR: $(inputs.static_dir.path)

baseCommand: ["sh", "my_script.sh"]
#baseCommand: ["papermill", "/pge/interface/run_l1a_pge.ipynb"]
arguments: [
  "-p",
  "input_path",
  "$(inputs.input_dir)",
  "-p",
  "output_path",
  "$(runtime.outdir)/out",
  "-p",
  "data_static_path",
  "$(inputs.static_dir)" 
]


inputs:
  input_dir:
    type: Directory
  static_dir:
    type: Directory

outputs:
  output_dir:
    type: Directory
    outputBinding:
      glob: "out"
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr

stdout: run_ssips_pge_stdout.txt
stderr: run_ssips_pge_stderr.txt
