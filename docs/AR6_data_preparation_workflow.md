This file describes the preparation of AR6 submissions, starting from the REMIND and MAgPIE reportings. You can skip step 2 if you are submitting REMIND standalone. (Bjoern Soergel, Jun 2016)

0. rerun REMIND & MAgPIE reportings (only necessary if new variables have been been added to the reporting since your run was performed)

1. run policy cost reporting: Rscript output.R -> comparison -> policy costs -> select scenarios as: Run A, reference run for run A, run B, reference run for run B, etc. 
This copies the REMIND reporting but replaces the policy costs with the ones calculated with your reference run of choice. (Normally the corresponding SSPx-NPi run is the appropriate reference, but your study might have special requirements.) Continue with the new file REMIND_generic_xxx_adjustedPolicyCosts.mif .

2. Remove regional Policy Cost|Consumption Loss and Policy Cost|Consumption + Current Account Loss from this file, keep only the global one (we only want to report the global values to the AR6 database).
Use this script to do so conveniently: scripts/rm_regipolicycosts.sh (thanks to Jerome!)

3. merge MAgPIE and REMIND (with correct policy costs) reporting:  see script here: scripts/combineReports.R (thanks to David)

further steps follow the submission procedure as already described by Alois in this documentation of this repository

4. Check that all variables important for you are in the mapping ar6/mapping_template.csv. If you make any additions, push them back into the repository.

5. run "ar6/generate_mappingfile.R" to create a mapping from our variables to AR6 variables

6. copy your mif files processed as described above into the ar6 folder. Adjust model name and study identifier in ar6/produce_output.R and run it. Check missing.log to make sure your variables are correctly processed.

7. copy the outputs from ar6/AR6_output into the AR6 submission Excel spreadsheet (see Alois' slides for details). Notes:
- copy only the years until 2100
- there is currently still an issue with the unit "\degree C" for the global mean temperature. You have to correct this by hand when copying the data into the AR6 spreadsheet.

