#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: CommandLineTool
label: index a sequence file for use by esl-sfetch
doc: "https://github.com/EddyRivasLab/easel"

hints:
 DockerRequirement:
   dockerPull: quay.io/biocontainers/hmmer:3.2.1--hf484d3e_1

baseCommand: [esl-sfetch, --index]

requirements:
  InitialWorkDirRequirement:
    listing:
        - $(inputs.sequences)

inputs:
  sequences:
    type: File
    inputBinding:
      position: 1
      valueFrom: $(self.basename)
    label: Input fasta file.

outputs:
  sequences_with_index:
    type: File
    secondaryFiles: .ssi
    outputBinding:
      glob: $(inputs.sequences.basename)

    doc: The index file

#$namespaces:
  #edam: http://edamontology.org/
  #s: http://schema.org/
#$schemas:
 #- http://edamontology.org/EDAM_1.16.owl
 #- https://schema.org/docs/schema_org_rdfa.html

#s:license: "https://www.apache.org/licenses/LICENSE-2.0"
#s:copyrightHolder: "EMBL - European Bioinformatics Institute"