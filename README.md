# Example for AMGT-TS

<https://github.com/plantdna/amgt-ts>

Things to note:

 * The configuration file is just a bash script that is sourced by the main
   script; it exports the environment variables that define the configuration
   AMGT-TS uses.  (Note that `SCRIPT_PATH` and optionally `BASE_DIR` will have
   already been set in the main script when this gets sourced.)
 * The example data provided in the web version is
   <https://plantdna.github.io/data/sample15.fq> but is also right here in the
   `PROJECT_DIR` already.
 * Reference stats file is TSV.

Example:

    ./amgt-ts/amgt-ts.sh amgt-ts profile.sh broad
