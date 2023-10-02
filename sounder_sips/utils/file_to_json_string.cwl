cwlVersion: "v1.2"
class: ExpressionTool
label: CWL tool to serialize a File object into a JSON string

requirements:
  - class: InlineJavascriptRequirement
    expressionLib:
             - |
               /**
                * Javascript function that serializes a generic object into a JSON string.
                *
                * @param {Object} the_object : Any Javascript object.
                * @return {String} : A JSON formatted string of the object structure.
               */
               function serialize(the_object) {
                 return JSON.stringify(the_object);
               }

expression: |
  ${ return {"the_json_string": serialize( inputs.the_file ) }; }

inputs: 
  the_file: File

outputs:
  the_json_string: string
