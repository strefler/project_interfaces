This file describes the preparation of AR6 submissions, starting from the REMIND and MAgPIE reportings. You can skip step 3 if you are submitting REMIND standalone. (Bjoern Soergel, Jun 2020)

0. rerun REMIND & MAgPIE reportings (only necessary if new variables have been been added to the reporting since your run was performed)

1. run policy cost reporting: Rscript output.R -> comparison -> policy costs -> select scenarios as: Run A, reference run for run A, run B, reference run for run B, etc. 
This copies the REMIND reporting but replaces the policy costs with the ones calculated with your reference run of choice. (Normally the corresponding SSPx-NPi run is the appropriate reference, but your study might have special requirements.) Continue with the new file REMIND_generic_xxx_adjustedPolicyCosts.mif .

2. Remove regional Policy Cost|Consumption Loss and Policy Cost|Consumption + Current Account Loss from this file, keep only the global one (we only want to report the global values to the AR6 database). Use this script to do so conveniently: scripts/rm_regipolicycosts.sh (thanks to Jerome!)
Note: for the SDP submission this should be skipped and done only after calculating the additional indicators. (otherwise you get infilled NAs)

3. merge MAgPIE and REMIND (with correct policy costs) reporting:  see script here: scripts/combineReports.R (thanks to David)

special steps for SDP submission with additional SDG indicators:

4a. check out sdp-postprocessing repository from PIK Gitlab. Copy the combined .mif files from Step 3 into sdp-postprocessing/mifs. Run master.R to add the post-processing for additional SDG indicators (mif files are modified inplace).

4b. Do step 2 here (removal of regional consumption losses).  

Further steps largely follow the submission procedure as already described by Alois in this documentation of this repository, but with some specialities added.

5. Check that all variables important for you are in the mapping ar6/mapping_template.csv. If you make any additions, push them back into the repository. Make sure that variable name and unit in the left columns exactly match the AR6 convention.

6. run "ar6/generate_mappingfile.R" to create a mapping from our variables to AR6 variables

7. Copy your mif files processed as described above into the ar6 folder. Adjust model name and study identifier in ar6/produce_output.R and run it. Check missing.log to make sure all your variables are correctly processed. (Certain buildings/industry/transport variables not present in standard-REMIND might be flagged as missing. If they are irrelevant for your upload, you can probably proceed.)

8. run fixVariableNames_removeNAs.sh on the output files to fix some special variable names and replace NAs with blanks

9. copy the outputs from ar6/AR6_output into the AR6 submission Excel spreadsheet (see Alois' slides for details). Notes:
- copy only the years until 2100
- there is currently still an encoding issue with the unit "\mu g/m3" for the air pollution variables. You have to correct this by hand when copying the data into the AR6 spreadsheet (replacing ug/m3 with the Greek letter)
- add comments for variables in the comments sheet as necessary
- complete/update scenario metadata sheet

