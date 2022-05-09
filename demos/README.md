# CWL Demos
This directory contains example CWL workflows.

## Pre-requisites
Create a python virtual environment with the latest version of the CWL libraries installed. For example, such an environment can be created as follows:
```
cd <any working directory>
virtualenv cwl_venv
source cwl_venv/bin/activate
pip install cwltool cwl-runner
```

## "Echo" example

As a first example, you can execute a CWL workflow which simply echoes to standard output a message that is passed as input to the workflow:

```
cwl-runner echo.cwl echo.yaml

INFO cwl-runner 3.1.20211107152837
INFO Resolved 'echo.cwl' to 'file:///Users/cinquini/tmp/echo.cwl'
INFO [job echo.cwl] /private/tmp/docker_tmp0mxmmci1$ echo \
    'Hello world!'
Hello world!
INFO [job echo.cwl] completed success
{}
INFO Final process status is success
```

The file `echo.cwl` contains the worklow specification, whilethe file `echo.yaml` contains the value of the parameters (the "message") for this specific workflow instance.

