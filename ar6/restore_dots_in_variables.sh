#!/bin/bash

echo "restoring PM2.5 and poverty w.r.t. median income dots in variable names"
sed 's/wrt median income/w.r.t. median income/g' ./AR6_output/SusDev_alldata.mif > ./AR6_output/temp.mif
sed -i 's/PM2\_5/PM2.5/g' ./AR6_output/temp.mif 
echo "replacing N/A for missing years with blanks as recommended by Ed Byers"
sed 's/N\/A//g' ./AR6_output/temp.mif > ./AR6_output/SusDev_alldata_final.mif
rm ./AR6_output/temp.mif
