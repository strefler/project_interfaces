#!/bin/bash

# Removes a small number of variables that are only used for consistency checks from the AR6 upload file."
# (Bjoern, Jul 2021, based on an earlier script by Jerome)

# variable list to be excluded by Gunnar
# (looks like "Emissions|BC|AFOLU|Land" and "Primary Energy|Oil|Electricity|*" aren't mapped anyway)
# also exclude all Investment|Energy Supply|XXX subcategories for now, keep only top-level category

myregex="(Emissions\|BC\|AFOLU\|Agriculture;\
|Emissions\|BC\|AFOLU\|Land;\
|Primary Energy\|Coal\|Electricity\|w\/ CCS;\
|Primary Energy\|Coal\|Electricity\|w\/o CCS;\
|Primary Energy\|Oil\|Electricity\|w\/ CCS;\
|Primary Energy\|Oil\|Electricity\|w\/o CCS;\
|Primary Energy\|Gas\|Electricity\|w\/ CCS;\
|Primary Energy\|Gas\|Electricity\|w\/o CCS;\
|Primary Energy\|Biomass\|Electricity\|w\/ CCS;\
|Primary Energy\|Biomass\|Electricity\|w\/o CCS;\
|Investment\|Energy Supply\|)"


echo "removing the following variables:"
echo $myregex

mif_files=`find ./AR6_output/ -name *.mif`
echo $mif_files

for file in $mif_files
do
  echo "Processing $file, line count before and after"
  wc -l $file
  cp $file $file.bak
  sed -ire -E "/$myregex/d" $file
  wc -l $file
done
