cwlVersion: v1.0

# A Package that complies with the Best Practice for Earth Observation Application Package needs to:
#
# * Be a valid CWL document with a single Workflow Class and at least one CommandLineTool Class
# * Define the command-line and respective arguments and container for each CommandLineTool
# * Define the Application parameters
# * Define the Application Design Pattern
# * Define the requirements for runtime environment
#
# The Workflow class steps field orchestrates the execution of the application command line and retrieves all the outputs of the processing steps.

$graph:
- class: Workflow
  id: main
  label: Sounder SIPS L1A PGE 
  doc: Processes Sounder SIPS L0 products into L1A products

  requirements:
  - class: ScatterFeatureRequirement

  inputs:
    input_ephatt_dir:
      type: Directory
      label: L0 SNPP_EphAtt Data Directory
      doc: Directory containing L0 emphemeris and attitude files
    input_science_dir:
      type: Directory
      label: L0 ATMS Science Data Directory
      doc: Directory containing L0 science packet files
    static_dir:
      type: Directory
      label: Static Inputs
      doc: Directory containing static DEM data
    start_datetime:
      type: string
      label: Data Start Date/Time
      doc: ISO8601 formated date and time indicating the start of data to be processed from the L0 files
    end_datetime:
      type: string  
      label: Data End Date/Time
      doc: ISO8601 formated date and time indicating the end of data to be processed from the L0 files

  steps:
    l1a_process:
      run: "#l1a_pge"
      in:
        input_ephatt_dir: input_ephatt_dir
        input_science_dir: input_science_dir
        static_dir: static_dir
        start_datetime: start_datetime
        end_datetime: end_datetime
      out:
        - output_dir
        - stdout_file
        - stderr_file

  outputs:
    output_dir:
      outputSource: l1a_process/output_dir
      type: Directory
    stdout_file: 
      outputSource: l1a_process/stdout_file
      type: File
    stderr_file:
      outputSource: l1a_process/stderr_file
      type: File
   
- class: CommandLineTool
  id: l1a_pge

  requirements:
    DockerRequirement:
      dockerPull: public.ecr.aws/unity-ads/sounder_sips_l1a_pge:r0.2.0
  
  arguments: [
    "$(runtime.outdir)/processed_notebook.ipynb",
    "-p", "input_ephatt_path", "$(inputs.input_ephatt_dir)",
    "-p", "input_science_path", "$(inputs.input_science_dir)",
    "-p", "output_path", "$(runtime.outdir)",
    "-p", "data_static_path", "$(inputs.static_dir)",
    "-p", "start_datetime", "$(inputs.start_datetime)",
    "-p", "end_datetime", "$(inputs.end_datetime)",
  ]
  
  inputs:
    input_ephatt_dir:
      type: Directory
    input_science_dir:
      type: Directory
    static_dir:
      type: Directory
    start_datetime:
      type: string  
    end_datetime:
      type: string  
  
  outputs:
    output_dir:
      type: Directory
      outputBinding:
        glob: .
    stdout_file:
      type: stdout
    stderr_file:
      type: stderr
  
  stdout: l1a_pge_stdout.txt
  stderr: l1a_pge_stderr.txt

$namespaces:
  s: https://schema.org/
s:softwareVersion: 1.0.0
schemas:
- http://schema.org/version/9.0/schemaorg-current-http.rdf

s:author: 
  name: James McDuffie
s:citation:
s:codeRepository: 
  url: https://github.jpl.nasa.gov/unity-sds/sips_spss_build
s:contributor: 
  - name: Luca Cinquini
s:dateCreated: 2022-04-14
s:keywords: l0, l1a, thermal, sips, sounder
s:license: All Rights Reserved
s:releaseNotes: Initial release
s:version: 0.1
