# !/bin/bash
export REF_DIR=$SCRIPT_PATH/ref
export SCRIPT_DIR=$SCRIPT_PATH
export PROJECT_DIR=$BASE_DIR/working
export TMP_DIR=$BASE_DIR/tmp

export FORMAT=fq

export PICARD=$(which picard) # will this work or is picard.jar needed?
export BWA=$(which bwa)
export SAMTOOLS=$(which samtools)
export BAMTOOLS=$(which bamtools)
export SEQTK=$(which seqtk)

# fastx
export FASTX_DIR=$(dirname $(which fastq_quality_filter))

# blast
export BLAST_BIN=$(dirname $(which blastn))

export REF_FILE=$REF_DIR/sites.amplicon.fa
export POS_FILE=$REF_DIR/sites.motif.info.stats

# parameters
export THREADS=2
export CPU_CORES=2
export MIN_QUALITY_SCORE=20

# references processing
export FLANK_LENGTH=20

# SSR typing
export MIN_BASES_PERCENT=80
