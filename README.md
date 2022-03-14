# Project Interfaces
Project specific interfaces to REMIND / MAgPIE.

## AR6

Reporting data to the AR6 DB is a multi-step process that can take a
week if you do not have your model registered with the IIASA DB yet.


Information on the process can be found here:

https://data.ene.iiasa.ac.at/ar6-scenario-submission/#/about

### Model Registration

Please check if the model version your runs are based upon is already
registered with the AR6 DB. At the time of this writing I (Alois, 4.6.20) do
not know of any automated way to do this. Maybe ask the [DB
admins](ipccAR6db.ene.admin@iiasa.ac.at).


For the REMIND model with global coverage, two registration steps are
required: There is the rapid registration,

https://forms.office.com/Pages/ResponsePage.aspx?id=C7F5mwcAik6wcq0MjNwapZ2PcWg1iqFLp9EH2Rjz8hZUOTJTNzBaNjdWRUpPWERYWUJGNjEyODNIVi4u

and the more detailed model registration template which is part of the
Download found under section 2 on the [IIASA help
page](https://data.ene.iiasa.ac.at/ar6-scenario-submission/#/about).

Usually you will be reminded after the first step to fill in the more
detailed template and send it via mail.

#### Does my Version of REMIND/MAgPIE warrant the registration of a new model?

This question is difficult to answer. The best way to judge is based
upon the categories in the model registration template. If the setup
of your runs differ substantially from the REMIND/MAgPIE defaults,
e.g., you use different demand sector modules or there are major changes in
the coupled models, it might be better to register a new model to
avoid confusion.

### REMIND/MAgPIE-specific processing of model outputs prior to AR6 submission
Before submitting your data to the AR6 database please make sure that 
- the policy costs in the reporting are calculated w.r.t. the appropriate reference run. For most runs, this will involve re-running the policy costs.

### Columns of the `mapping_template_AR6.csv`

- `idx`: Index as given by the AR6 submission template, this is just for reference
- `Variable_AR6`: The AR6 reporting variable name as given by the submission template
- `Unit`: The AR6 reporting variable unit as given by the submission template
- `r30m44`: The REMIND/MagPIE variable name
- `r30m44_unit`: The REMIND/MagPIE
- `r30m44_factor`: Conversion factor multiplied with the REMIND/MagPIE value to obtain the AR6 compatible value
- `r30m44_spatial`: Restricts reporting to global level ("glo") or regional level ("reg"), empty values mean no restriction
- `m44`: MagPIE specific variable name
- `m44_unit`: MagPIE specific variable unit
- `m44_factor`: Conversion factor for MagPIE value
- `internal_comment`: Comment for internal reference
- `Comment`: Comment to be published with the AR6 submission template
- `Definition`: Variable definition, initial values copied from the AR6 submission template.

The corresponding columns for former REMIND v2.1, MAgPIE v4.2 are still available with the prefix `r21m42`.

### Generate AR6-compatible Output

The workflow to generate AR6-compatible output is as follows:

- the variable mappings are stored together with metadata in a
  *template*. You can, e.g., copy the [ar6/mapping_template_AR6.csv](ar6/mapping_template_AR6.csv) and
  adjust it to your needs.
- from the template you generate a *mappingfile*.
- use the mapping and REMIND and/or MAgPIE output with
  `iamc::write.reportProject` to generate a MIF
  file with AR6 compatible variable names and factors.


A *template* is just a file which contains the mapping, optionally a
factor and a weight column and some metadata. For example, for AR6 one
should report model specifics regarding the accounting for variables
in a tab called "comments". This column is included in the template
for convenience.

When the mappingfile is produced from the template, the metadata is ignored.

To generate the mapping file for the `iamc::write.reportProject`
function, open the [ar6/generate_mappingfile.R](ar6/generate_mappingfile.R) script and adjust the
column names to match the ones in your template and the path to the template.
Then call (working directory is the `ar6` folder)
```
Rscript generate_mappingfile.R
```
This will generate a mapping file, (e.g, `mapping_r21m42_AR6DB.csv`),
to be used with `iamc::write.reportProject` on a combined MIF file.
In the R shell:

```{r}
iamc::write.reportProject("CombindedOutput.mif", "mapping_r21m42_AR6DB.csv", "AR6Output.mif", missing_log="missing.log")
```
If variables are not found because they are not present in the output, 
they will be ignored appended to `missing.log`. This happens, e.g., if
you use output from standalone runs (MAgPIE variables missing) or runs
which do not use the new industry or transport modules.


It is in any case recommended to **check the missing variables** to see which
variables are ignored erringly.

### Automation

If you have many MIFs to process, there is a little helper script,
[ar6/produce_output.R](ar6/produce_output.R) to assist you with the process.

You can specify the mappingfile and a directory with MIF files. It
will produce AR6 compatible outputfiles with a given prefix and will
also rename the model name (to be consistent with your model
registration).

If required, the script will produce only *one* output file with all
scenarios (the flag `GENERATE_SINGLE_OUTPUT`). This can easily be
copied to the submission template.

### Submission

The resulting AR6 compatible output files (MIFs) have to be either
concatenated and imported as a single sheet (named `data`) into the
submission template (this is the preferable way if you have a lot of
scenarios to submit) or as multiple sheets with sheet names `data1`,
`data2` etc. 


Regarding the meta-data in the submission template, please have a look
at exiting (and recent) submissions in the `ar6/submission_templates`
folder. **Please add your submission to this folder** as soon as you
submitted, but please **remove the data** to not bloat this repository. 

### SHAPE

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
columns (`ar6/shape/shape-template.csv`).


