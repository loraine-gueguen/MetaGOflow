cwlVersion: v1.0
class: CommandLineTool

label: "Quality control filtering step using the BioPython package."

requirements:
#  DockerRequirement:
#    dockerPull: alpine:3.7
  ResourceRequirement:
    coresMax: 4
    ramMin: 100
    ramMax: 500
  InlineJavascriptRequirement: {}

baseCommand: ["run_quality_filtering.py" ]

inputs:
  seq_file:
    type: File
    format: edam:format_1929  # FASTA
    inputBinding:
      position: 1
    label: 'Trimmed sequence file'
    doc: >
      Trimmed and FASTQ to FASTA converted sequences file.
  submitted_seq_count:
    type: int
    label: 'Number of submitted sequences'
    doc: >
      Number of originally submitted sequences as in the user
      submitted FASTQ file - single end FASTQ or pair end merged FASTQ file.
  stats_file_name:
    type: string
    default: stats_summary
    label: 'Post QC stats output file name'
    doc: >
      Give a name for the file which will hold the stats after QC.

outputs:
  filtered_file:
    label: Filtered output file
    type: File
    outputBinding:
      glob: $(inputs.seq_file.nameroot)_filtered.fasta
  stats_summary_file:
    label: Stats summary output file
    type: File
    outputBinding:
      glob: $(inputs.stats_file_name)

arguments:
   - position: 2
     valueFrom: $(inputs.seq_file.nameroot)_filtered.fasta
   - position: 3
     valueFrom: $(inputs.stats_file_name)
   - position: 4
     valueFrom: $(inputs.submitted_seq_count)

$namespaces:
 edam: http://edamontology.org/
 iana: https://www.iana.org/assignments/media-types/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/docs/schema_org_rdfa.html

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder:   "EMBL - European Bioinformatics Institute"