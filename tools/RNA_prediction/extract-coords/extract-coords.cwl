#!/usr/bin/env cwl-runner
cwlVersion: v1.0
class: CommandLineTool
$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/

hints:
 DockerRequirement:
   dockerPull: alpine:3.7

requirements:
  ShellCommandRequirement: {}
  InlineJavascriptRequirement: {}
  ResourceRequirement:
    coresMin: 2
    ramMin: 200

inputs:
  infernal_matches:
    label: output from infernal cmsearch
    format: edam:format_3475
    type: File
    inputBinding:
      position: 1
  name:
    type: string?

stdout: $(inputs.name).matched_seqs_with_coords

baseCommand: [ awk ]

arguments:
 - valueFrom: "'{print $1\"-\"$3\"/q\"$8\"-\"$9\" \"$8\" \"$9\" \"$1}'"
   shellQuote: false

outputs:
  matched_seqs_with_coords: stdout

doc: |
  The awk script takes the output of Infernal's cmsearch so-called fmt=1 mode
  and makes it suitable for use by esl-sfetch, a sequence selector
  
  Reading the user's guide for Infernal, Version 1.1.2; July 2016
  http://eddylab.org/infernal/Userguide.pdf#page=60 we see that
  the relevant fields in the cmsearch output are:
  (column number: explanation)
  1: The name of the target sequence or profile
  3: The name of the query sequence or profile
  8: The start of the alignment of this hit with respect to the
      sequence, numbered 1..L for a sequence of L residues.
  9: The end of the alignment of this hit with respect to the sequence,
      numbered 1..L for a sequence of L residues

  Likewise the format esl-sfetch wants is: <newname> <from> <to> <source seqname>

  Putting it all together we see that the newname (which esl-sfetch with
  output using) is a concatenation of the original name, the sequence
  number, and the coordinates.

$schemas:
 - https://raw.githubusercontent.com/edamontology/edamontology/main/releases/EDAM_1.20.owl
 - https://schema.org/version/latest/schemaorg-current-http.rdf

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder:
    - name: "EMBL - European Bioinformatics Institute"
    - url: "https://www.ebi.ac.uk/"

