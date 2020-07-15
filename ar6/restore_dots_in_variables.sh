#!/bin/bash

sed 's/wrt median income/w.r.t. median income/g' ./AR6_output/SusDev_alldata.mif > ./AR6_output/temp.mif
sed 's/PM2\_5/PM2.5/g' ./AR6_output/temp.mif > ./AR6_output/SusDev_alldata_final.mif
rm ./AR6_output/temp.mif
