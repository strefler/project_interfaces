This file describes the preparation of AR6 submissions, starting from the REMIND and MAgPIE reportings. You can skip step 2 if you are submitting REMIND standalone. (Bjoern Soergel, last updated Nov 2020)

0. rerun REMIND and/or MAgPIE reportings.  (only necessary if there have been issues with the reporting, or if variables were added to remind/magpie4 libraries that are not yet present in the snapshot used for the coupling). 

IMPORTANT: due to fixes in the REMIND emission reporting, make sure you use remind library version >= 36.180.0 (snapshot 2020_11_19).

1. run policy cost reporting: Rscript output.R -> comparison -> policy costs -> select scenarios as: Run A, reference run for run A, run B, reference run for run B, etc. 
This copies the REMIND reporting but replaces the policy costs with the ones calculated with your reference run of choice. (Normally the corresponding SSPx-NPi run is the appropriate reference, but your study might have special requirements.) Continue with the new file REMIND_generic_xxx_adjustedPolicyCosts.mif .

2. merge MAgPIE and REMIND (with correct policy costs) reporting:  see script here: scripts/combine_report.R (thanks to David). Copy this into your remind main folder and use it like: "Rscript combine_report.R runs=C_SDP-PkBudg1000,C_SSP1-PkBudg900,C_SSP1-NDC,C_SSP2-NDC,C_SSP2-PkBudg900"
Make sure to adjust (i) the name of the REMIND reporting suffix (with/without corrected policy costs), (ii) the name prefix for your coupled runs (unless you want all of your reportings to be called "bjoernAR6_...")

special steps for SDP submission with additional SDG indicators:

3a. check out sdp-postprocessing repository from PIK Gitlab. Create a new folder unmodified_mifs at the same level, and copy the combined reportings from step 3 into it. create a folder sdp-postprocessing/mifs. Run master.R (best using slurm script!) to add the post-processing for additional SDG indicators (mif files are copied into folder mifs and modified inplace).

3b. Do step 2 here (removal of regional consumption losses).  

Further steps largely follow the submission procedure as already described by Alois in this documentation of this repository, but with some specialities added.

4. Check that all variables important for you are in the mapping ar6/mapping_template.csv. If you make any additions, push them back into the repository. Make sure that variable name and unit in the left columns exactly match the AR6 convention.

5. run "ar6/generate_mappingfile.R" to create a mapping from our variables to AR6 variables

6. Copy your mif files processed as described above into the ar6 folder. Adjust model name and study identifier in ar6/produce_output.R and run it. Check missing.log to make sure all your variables are correctly processed. (Certain buildings/industry/transport variables not present in standard-REMIND might be flagged as missing. If they are irrelevant for your upload, you can probably proceed.)

7. run fixVariableNames_removeNAs.sh on the output files to fix some special variable names and replace NAs with blanks

8. copy the outputs from ar6/AR6_output into the AR6 submission Excel spreadsheet (see Alois' slides for details). Notes:
- copy only the years until 2100
- there is currently still an encoding issue with the unit "\mu g/m3" for the air pollution variables. You have to correct this by hand when copying the data into the AR6 spreadsheet (replacing ug/m3 with the Greek letter)

9. add comments for variables in the comments sheets. The creation of the mapping template also creates a ar6-comments.csv that lists all comments in the mapping file. Copy this into the Comments sheet and modify/add as needed for your submission. If you have generic comments for variables (not specific to your study) make sure they are added to the mapping template so that everyone's submissions have them.

10. complete/update scenario metadata sheet

