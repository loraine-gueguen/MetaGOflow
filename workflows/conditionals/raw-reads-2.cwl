#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: v1.2.0-dev4

requirements:
  SubworkflowFeatureRequirement: {}
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}
#  SchemaDefRequirement:
#    types:
#      - $import: ../tools/biom-convert/biom-convert-table.yaml

inputs:

    motus_input: File
    filtered_fasta: File

    ssu_db: {type: File, secondaryFiles: [.mscluster] }
    lsu_db: {type: File, secondaryFiles: [.mscluster] }
    ssu_tax: [string, File]
    lsu_tax: [string, File]
    ssu_otus: [string, File]
    lsu_otus: [string, File]

    rfam_models:
      type:
        - type: array
          items: [string, File]
    rfam_model_clans: [string, File]
    other_ncRNA_models: string[]

    ssu_label: string
    lsu_label: string
    5s_pattern: string
    5.8s_pattern: string

    # cgc
    CGC_config: [string?, File?]
    CGC_postfixes: string[]
    cgc_chunk_size: int

    # functional annotation
    protein_chunk_size_hmm: int
    protein_chunk_size_IPS: int
    func_ann_names_ips: string
    func_ann_names_hmmer: string
    HMM_gathering_bit_score: boolean
    HMM_omit_alignment: boolean
    HMM_database: string
    HMM_database_dir: [string, Directory?]
    hmmsearch_header: string
    ko_file: [string, File]

    EggNOG_db: [string?, File?]
    EggNOG_diamond_db: [string?, File?]
    EggNOG_data_dir: [string?, Directory]

    InterProScan_databases: [string, Directory]
    InterProScan_applications: string[]  # ../tools/InterProScan/InterProScan-apps.yaml#apps[]?
    InterProScan_outputFormat: string[]  # ../tools/InterProScan/InterProScan-protein_formats.yaml#protein_formats[]?
    ips_header: string

    go_config: [string?, File?]
    motus_db: string?

outputs:
  motus_output:
    type: File
    outputSource: motus_taxonomy/motus

  sequence_categorisation_folder:
    type: Directory
    outputSource: move_to_seq_cat_folder/out
  taxonomy-summary_folder:
    type: Directory
    outputSource: return_tax_dir/out

  chunking_fasta_files:
    type: File[]?
    outputSource: chunking_final/fasta_chunks

  rna-count:
    type: File
    outputSource: rna_prediction/LSU-SSU-count

  compressed_files:
    type: File[]
    outputSource: compression/compressed_file

  functional_annotation_folder:
    type: Directory
    outputSource: functional_annotation/functional_annotation_folder
  stats:
    type: Directory
    outputSource: functional_annotation/stats

 # FAA count
  count_CDS:
    type: int
    outputSource: cgc/count_faa

  optional_tax_file_flag:
    type: File?
    outputSource: no_tax_file_flag/created_file

steps:
# << mOTUs2 >>
  motus_taxonomy:
    run: ../../subworkflows/raw_reads/mOTUs-workflow.cwl
    in:
      reads: motus_input
      motus_db: motus_db
    out: [ motus ]

# << Get RNA >>
  rna_prediction:
    run: ../../subworkflows/rna_prediction-sub-wf.cwl
    in:
      type: { default: 'raw'}
      input_sequences: filtered_fasta
      silva_ssu_database: ssu_db
      silva_lsu_database: lsu_db
      silva_ssu_taxonomy: ssu_tax
      silva_lsu_taxonomy: lsu_tax
      silva_ssu_otus: ssu_otus
      silva_lsu_otus: lsu_otus
      ncRNA_ribosomal_models: rfam_models
      ncRNA_ribosomal_model_clans: rfam_model_clans
      pattern_SSU: ssu_label
      pattern_LSU: lsu_label
      pattern_5S: 5s_pattern
      pattern_5.8S: 5.8s_pattern
    out:
      - ncRNA
      - cmsearch_result
      - LSU-SSU-count
      - SSU_folder
      - LSU_folder
      - SSU_fasta
      - LSU_fasta
      - compressed_rnas
      - number_LSU_mapseq
      - number_SSU_mapseq

# add no-tax file-flag if there are no lsu and ssu seqs
  no_tax_file_flag:
    when: $(inputs.count_lsu < 3 && inputs.count_ssu < 3)
    run: ../../../utils/touch_file.cwl
    in:
      count_lsu: rna_prediction/number_LSU_mapseq
      count_ssu: rna_prediction/number_SSU_mapseq
      filename: { default: no-tax}
    out: [ created_file ]

# << other ncrnas >>
  other_ncrnas:
    run: ../../subworkflows/other_ncrnas.cwl
    in:
     input_sequences: filtered_fasta
     cmsearch_file: rna_prediction/ncRNA
     other_ncRNA_ribosomal_models: other_ncRNA_models
     name_string: { default: 'other_ncrna' }
    out: [ ncrnas ]

# << COMBINED GENE CALLER >>
  cgc:
    in:
      input_fasta: filtered_fasta
      maskfile: rna_prediction/ncRNA
      postfixes: CGC_postfixes
      chunk_size: cgc_chunk_size
    out: [ predicted_faa, predicted_ffn, count_faa ]
    run: ../../subworkflows/raw_reads/cgc/CGC-subwf.cwl

# << FUNCTIONAL ANNOTATION: hmmscan, IPS, eggNOG >>
# << GO SUMMARY>>
# << PFAM >>
# << summaries and stats IPS, HMMScan, Pfam >>
# << add header to IPS and HMM and chunking TSVs >>

  functional_annotation:
    run: ../../subworkflows/raw_reads/Func_ann_and_post_proccessing-subwf.cwl
    in:
       check_value: cgc/count_faa

       filtered_fasta: filtered_fasta
       rna_prediction_ncRNA: rna_prediction/ncRNA
       cgc_results_faa: cgc/predicted_faa
       protein_chunk_size_hmm: protein_chunk_size_hmm
       protein_chunk_size_IPS: protein_chunk_size_IPS

       func_ann_names_ips: func_ann_names_ips
       InterProScan_databases: InterProScan_databases
       InterProScan_applications: InterProScan_applications
       InterProScan_outputFormat: InterProScan_outputFormat
       ips_header: ips_header

       func_ann_names_hmmer: func_ann_names_hmmer
       HMM_gathering_bit_score: HMM_gathering_bit_score
       HMM_omit_alignment: HMM_omit_alignment
       HMM_database: HMM_database
       HMM_database_dir: HMM_database_dir
       hmmsearch_header: hmmsearch_header

       go_config: go_config
       ko_file: ko_file
       type_analysis: { default: 'Reads' }
    out:
      - functional_annotation_folder
      - stats


# << FINAL STEPS >>

# gzip
  compression:
    run: ../../../utils/pigz/gzip.cwl
    scatter: uncompressed_file
    in:
      uncompressed_file:
        source:
          - rna_prediction/ncRNA                        # cmsearch.all.deoverlapped
          - rna_prediction/cmsearch_result              # cmsearch.all
        linkMerge: merge_flattened
    out: [compressed_file]

# << chunking >>
  chunking_final:
    run: ../../subworkflows/final_chunking.cwl
    in:
      fasta: filtered_fasta
      ffn: cgc/predicted_ffn
      faa: cgc/predicted_faa
      LSU: rna_prediction/LSU_fasta
      SSU: rna_prediction/SSU_fasta
    out:
      - fasta_chunks                         # fasta, ffn, faa, chunks
      - SC_fasta_chunks                                 # LSU, SSU

# << move chunked files >>
  move_to_seq_cat_folder:  # LSU and SSU
    run: ../../../utils/return_directory/return_directory.cwl
    in:
      file_list:
        source:
          - chunking_final/SC_fasta_chunks
          - rna_prediction/compressed_rnas
          - other_ncrnas/ncrnas
        linkMerge: merge_flattened
      dir_name: { default: 'sequence-categorisation' }
    out: [ out ]

# return taxonomy summary dir
  return_tax_dir:
    run: ../../../utils/return_directory/return_directory.cwl
    in:
      dir_list:
        - rna_prediction/SSU_folder
        - rna_prediction/LSU_folder
      dir_name: { default: 'taxonomy-summary' }
    out: [out]


$namespaces:
 edam: http://edamontology.org/
 s: http://schema.org/
$schemas:
 - http://edamontology.org/EDAM_1.16.owl
 - https://schema.org/version/latest/schemaorg-current-http.rdf

s:license: "https://www.apache.org/licenses/LICENSE-2.0"
s:copyrightHolder:
  - name: "EMBL - European Bioinformatics Institute"
  - url: "https://www.ebi.ac.uk/"