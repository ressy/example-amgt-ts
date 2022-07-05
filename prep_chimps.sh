#!/usr/bin/env bash

# Download a handful of our chimp STR samples from SRA, adapter-trim R1, and
# combine across loci for each sample (as AMGT-TS expects)

adapter=CTGTCTCTTATACACATCTCCGAGCCCACGAGAC # just R1
attrs="chimps.csv"
dir="chimps"

function prep_files {
	dir_sra="$dir/raw"
	dir_trim="$dir/trim"
	dir_combo="$dir/combo"
	# Cut out just the SRR accession numbers and the sample names.
	SRR_NUM=$(   head -n 1 "$attrs" | tr -d '"' | sed s/,/\\n/g | grep -n SRR | cut -f 1 -d :)
	SAMPLE_NUM=$(head -n 1 "$attrs" | tr -d '"' | sed s/,/\\n/g | grep -n sample_name | cut -f 1 -d :)
	SRR=$(   tail -n +2 "$attrs" | tr -d '"' | cut -f $SRR_NUM,$SAMPLE_NUM -d ,)

	if [[ ! -d "$dir_sra" ]]; then
		echo "Downloading raw data from SRA.  This may take a while."
	fi
	mkdir -p "$dir_sra"
	mkdir -p "$dir_trim"
	# Fetch each file pair, renaming each time.
	echo "$SRR" | while read entry; do
		sample=$(echo "$entry" | cut -f 1 -d ,)
		srr=$(echo "$entry" | cut -f 2 -d ,)
		dest_r1="$dir_sra/${sample}_R1_001.fastq.gz"
		dest_r2="$dir_sra/${sample}_R2_001.fastq.gz"
		if [[ ! -e "$dest_r1" || ! -e "$dest_r2" ]]; then
			echo "Downloading $srr to $sample..."
			fastq-dump --gzip --split-files --keep-empty-files --outdir "$dir_sra" "$srr" > /dev/null
			mv "$dir_sra/${srr}_1.fastq.gz" "$dest_r1"
			mv "$dir_sra/${srr}_2.fastq.gz" "$dest_r2"
		fi
	done
	for path in "$dir_sra"/*_R1_001.fastq.gz; do
		trim="$dir_trim/$(basename $path)"
		if [[ ! -e  "$trim" ]]; then
			cutadapt -a $adapter "$path" -o "$trim"
		fi
	done
	# Gather all loci per sample for AMGT-TS
	mkdir -p "$dir_combo"
	tail -n +2 "$attrs" | cut -f 11 -d , | sort -u | while read samp; do
		zcat $(grep ",$samp," "$attrs" | cut -f 29 -d , | sed "s:^:$dir_trim/:") > "$dir_combo/${samp}.fq"
	done
}

prep_files
