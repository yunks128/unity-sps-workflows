#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: Tool that downloads data from the Unity DAPA server
doc: Requires valid AWS credentials as input arguments

$namespaces:
  cwltool: http://commonwl.org/cwltool#

baseCommand: [sleep]
inputs:
    sleep_time:
        type: int
        default: 5
        inputBinding:
            position: 1
outputs:
  stdout_file:
    type: stdout
  stderr_file:
    type: stderr
stdout: sleep_stdout.txt
stderr: sleep_stderr.txt