singularity pull --force --name hariszaf_fetch-tool:latest.sif docker://hariszaf/fetch-tool:latest
singularity pull --force --name debian:stable-slim.sif docker://debian:stable-slim
singularity pull --force --name microbiomeinformatics_pipeline-v5.fastp:0.20.0.sif docker://microbiomeinformatics/pipeline-v5.fastp:0.20.0
singularity pull --force --name microbiomeinformatics_pipeline-v5.easel:v0.45h.sif docker://microbiomeinformatics/pipeline-v5.easel:v0.45h
singularity pull --force --name microbiomeinformatics_pipeline-v5.python3:v3.1.sif docker://microbiomeinformatics/pipeline-v5.python3:v3.1
singularity pull --force --name microbiomeinformatics_pipeline-v5.python2:v1.sif docker://microbiomeinformatics/pipeline-v5.python2:v1
singularity pull --force --name microbiomeinformatics_pipeline-v5.bash-scripts:v1.3.sif docker://microbiomeinformatics/pipeline-v5.bash-scripts:v1.3
singularity pull --force --name microbiomeinformatics_pipeline-v5.cmsearch:v1.1.2.sif docker://microbiomeinformatics/pipeline-v5.cmsearch:v1.1.2
singularity pull --force --name microbiomeinformatics_pipeline-v5.cmsearch-deoverlap:v0.02.sif docker://microbiomeinformatics/pipeline-v5.cmsearch-deoverlap:v0.02
singularity pull --force --name alpine:3.7.sif docker://alpine:3.7
singularity pull --force --name microbiomeinformatics_pipeline-v5.mapseq:v1.2.3.sif docker://microbiomeinformatics/pipeline-v5.mapseq:v1.2.3
singularity pull --force --name microbiomeinformatics_pipeline-v5.mapseq2biom:v1.0.sif docker://microbiomeinformatics/pipeline-v5.mapseq2biom:v1.0
singularity pull --force --name microbiomeinformatics_pipeline-v5.krona:v2.7.1.sif docker://microbiomeinformatics/pipeline-v5.krona:v2.7.1
singularity pull --force --name microbiomeinformatics_pipeline-v5.biom-convert:v2.1.6.sif docker://microbiomeinformatics/pipeline-v5.biom-convert:v2.1.6
singularity pull --force --name hariszaf_pipeline-v5.fraggenescan:v1.31.1.sif docker://hariszaf/pipeline-v5.fraggenescan:v1.31.1
singularity pull --force --name microbiomeinformatics_pipeline-v5.protein-post-processing:v1.0.1.sif docker://microbiomeinformatics/pipeline-v5.protein-post-processing:v1.0.1
singularity pull --force --name hariszaf_pipeline-v5.eggnog:v2.1.8.sif docker://hariszaf/pipeline-v5.eggnog:v2.1.8
singularity pull --force --name hariszaf_pipeline-v5.interproscan:v5.57-90.0.sif docker://hariszaf/pipeline-v5.interproscan:v5.57-90.0
singularity pull --force --name microbiomeinformatics_pipeline-v5.hmmer:v3.2.1.sif docker://microbiomeinformatics/pipeline-v5.hmmer:v3.2.1
singularity pull --force --name quay.io_biocontainers_megahit:1.2.9--h2e03b76_1.sif docker://quay.io/biocontainers/megahit:1.2.9--h2e03b76_1
singularity pull --force --name microbiomeinformatics_pipeline-v5.motus:v2.5.1.sif docker://microbiomeinformatics/pipeline-v5.motus:v2.5.1
singularity pull --force --name microbiomeinformatics_pipeline-v5.go-summary:v1.0.sif docker://microbiomeinformatics/pipeline-v5.go-summary:v1.0
singularity pull --force --name microbiomeinformatics_pipeline-v5.split-fasta:v2.sif docker://microbiomeinformatics/pipeline-v5.split-fasta:v2
singularity pull --force --name microbiomeinformatics_krona:v2.7.1.sif docker://microbiomeinformatics/krona:v2.7.1
mkdir sif_images
mv *.sif sif_images
