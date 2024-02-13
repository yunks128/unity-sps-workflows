#!/usr/bin/env cwl-runner
cwlVersion: v1.2
$namespaces:
      cwltool: http://commonwl.org/cwltool#
$graph:
  - class: Workflow
    # main is used so this ID is called by default from cwl-runner
    id: main
    label: Workflow that executes the Sounder SIPS end-to-end chirp rebinning workflow

    requirements:
      SubworkflowFeatureRequirement: {}
      NetworkAccess:
        networkAccess: true

    ## Inputs to the e2e rebinning, not to each applicaiton within the workflow
    inputs:
      cmr_collection : string
      cmr_start_time: string
      cmr_stop_time: string
      limits: string?
      cmr_edl_user: string?
      cmr_edl_pass: string?

    outputs:
      results:
        type: File
        outputSource: cmr-search/cmr_results

    steps:
        cmr-search:
          run: "#cmr-tool"
          in:
            cmr_collection: cmr_collection
            cmr_start_time: cmr_start_time
            cmr_stop_time: cmr_stop_time
            limits: limits
            cmr_edl_user: cmr_edl_user
            cmr_edl_pass: cmr_edl_user
          # this is a stac catalog pointing to the CMR STAC as an item
          out: [cmr_results]

  - class: CommandLineTool
    # results in a STAC file called "cmr-results.json" being created with result of a CMR query
    id: cmr-tool
    baseCommand: ["SEARCH"]

    requirements:
      InlineJavascriptRequirement: {}
      DockerRequirement:
        dockerPull: ghcr.io/unity-sds/unity-data-services:5.2.1
      EnvVarRequirement:
        envDef:
          GRANULES_SEARCH_DOMAIN: 'CMR'
          CMR_BASE_URL: 'https://cmr.earthdata.nasa.gov'
          COLLECTION_ID: $(inputs.cmr_collection)
          LIMITS: $(inputs.limits || '-1')
          DATE_FROM: $(inputs.cmr_start_time)
          DATE_TO: $(inputs.cmr_stop_time)
          OUTPUT_FILE: $(runtime.outdir)/cmr-results.json
          LOG_LEVEL: '20'
    inputs:
      cmr_collection:
        type: string
      cmr_start_time:
        type: string
      cmr_stop_time:
        type: string
      cmr_edl_user:
        type: string?
      cmr_edl_pass:
        type: string?
      limits:
        type: string?

    #stac json catalog are the outputs
    outputs:
      cmr_results:
        type: File
        outputBinding:
          glob: "$(runtime.outdir)/cmr-results.json"
