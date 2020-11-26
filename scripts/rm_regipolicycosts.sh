#!/bin/bash

# Removes regional consumption losses from the REMIND reporting as these should be exluded from the AR6 reporting
# (Jerome Hilaire, Bjoern Soergel, Jun 2020)

echo "you should re-calculate the policy costs with correct reference runs before running this script"

mif_files=`find . -name REMIND_generic*_adjustedPolicyCosts.mif`
echo $mif_files

myregex="(CHN;|CHA;|EUR;|RUS;|LAM;|USA;|IND;|JPN;|ROW;|OAS;|MEA;|AFR;|CAZ;|NEU;|REF;|SSA;)Policy Cost.(Consumption Loss|Consumption \+ Current Account Loss)"

for file in $mif_files
do
  echo "Processing $file"
  cp $file $file.bak
  sed -ire -E "/$myregex/d" $file
done
