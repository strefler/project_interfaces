# Project Interfaces
Project specific interfaces to REMIND / MAgPIE.

## SHAPE

For SHAPE WP3, the harmonization of the input data across models is
based on the **AR6 reporting template** which can be found here:

https://data.ene.iiasa.ac.at/ar6-scenario-submission/static/files/global_sectoral/IPCC_AR6_WG3_Global_sectoral_Pathways_scenario_template_v1.3.xlsx

The project partner requires us to provide additionally information on
whether a variable is
- exogenous/endogenous (`source` column)
- of high/medium/low `quality` (reflecting the level of trust we have in
the output)
- interesting for our own modelling effort (a `useful` input for our REMIND/MAgPIE?).


To facilitate working on the template and enabling version control, 
the variable list is put into a CSV file together with the additional
columns (`shape-template.csv`).

### Generate AR6-compatible Output

To generate the output using this template on a combined REMIND/MAgPIE MIF file,
generate the mapping file for the `iamc::write.reportProject` function
first (working directory is the `shape` folder)
```
Rscript generate_mappingfile.R
```
This will generate a mapping file, i.e., `mapping_r21m42_AR6DB.csv`,
to be used with `iamc::write.reportProject` on a combined MIF file.
In the R shell:

```{r}
iamc::write.reportProject("CombindedOutput.mif", "mapping_r21m42_AR6DB.csv", "AR6Output.mif")
```
If variables are not found because they are not present in the output, 
they will be ignored but a warning is produced. This happens, e.g., if
you use output from standalone runs (MAgPIE variables missing) or runs
which do not use the new industry or transport modules.


It is in any case recommended to **check the warnings** to see which
variables are ignored.

