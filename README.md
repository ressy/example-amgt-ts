# Example for AMGT-TS

My notes running the supplied examples for AMGT-TS within a conda environment.

 * <https://github.com/plantdna/amgt-ts>
 * <https://doi.org/10.1186/s12859-021-04351-w>

Example:

    conda env update --file environment.yml
    conda activate example-amgt-ts
    mkdir -p project
    cp -ru amgt-ts/working project
    ./amgt-ts/amgt-ts.sh --project=project --script=amgt-ts --environment=profile.sh --method=broad

Or, trying some of our chimpanzee samples by downloading from SRA:

    conda env update --file env-chimps.yml
    conda activate example-amgt-ts-chimps
    ./prep_chimps.sh
    mkdir -p project-chimps/working/00_fastq
    cp chimps/combo/*.fq project-chimps/working/00_fastq
    conda deactivate
    conda env update --file environment.yml
    conda activate example-amgt-ts
    ./amgt-ts/amgt-ts.sh --project=project-chimps --script=amgt-ts --environment=profile.chimps.sh --method=broad

Things to note:

 * The configuration file is just a bash script that is sourced by the main
   script; it exports the environment variables that define the configuration
   AMGT-TS uses.  (Note that `SCRIPT_PATH` and optionally `BASE_DIR` will have
   already been set in the main script when this gets sourced.)
 * `BASE_DIR` defaults to an undefined variable equivalent to an empty string
   rather than `.` so you probably *do* want to specify it via `--project` so
   as not to get permission errors trying to write to the root directory.
 * The PICARD variable must point directly to the picard.jar file, not a picard
   wrapper script (as comes with bioconda's packages, for example).
 * Steps 02 and 03 are only relevant for the precise method so they don't show
   up in the output when using the broad method.  01 and 04 are present for
   both precise and broad methods.
 * The reference FASTA description line (not just ID) is used to match the
   sites in the stats file.
 * The FORMAT in the configuration is used for the file extension of the
   inputs.  Compression is not supported.
 * The output stat files are sorted assuming the IDs (e.g., s258878) are
   numeric from the second character onward.  If not, the stat file header
   might not appear on the first line.
 * The input and output stats/stat files are TSV.
 * The internal python scripts require pandas.

Things I don't yet understand:

 * What is `SSR.No` in the reference stat file?
 * What is `FLANK_LENGTH` in the configuration?
 * What is the library prep method?  Are the reads fragmented with a particular
   target size, or left as full-length from PCR?  (The former seems implicit
   but I'm not sure.)
 * Where is the step to define the final genotypes, like shown in the pairs of
   alleles for the diploid parent/offspring trio in [Figure 5]?
 * Why use the "SSRn" groupings as genotypes rather than the full sequence
   content observed?  (For example sample15 s282049's results are almost
   entirely SSR18, but these reads split into two groups, roughly 50:50, with
   different SNPs in both flanking regions and a deletion in the right flank for
   one of them.  Is this a heterozygous individual from that perspective?)

[Figure 5]: https://bmcbioinformatics.biomedcentral.com/articles/10.1186/s12859-021-04351-w/figures/5
