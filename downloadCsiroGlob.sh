#!/bin/bash

#!/bin/bash
base_url="https://data-cbr.csiro.au/thredds/ncss/catch_all/CMAR_CAWCR-Wave_archive/CAWCR_Wave_Hindcast_aggregate/gridded/ww3.glob_24m."

for year in {2013..2022}; do
    for month in {01..12}; do
        # the end date is the last day of the month 01=31, 02=28, 03=31, 04=30, 05=31, 06=30, 07=31, 08=31, 09=30, 10=31, 11=30, 12=31
        if [[ $month -eq 2 ]]; then
            if [[ $(date -d "$year-02-28" +%s) -lt $(date -d "$year-03-01" +%s) ]]; then
                days=28
            else
                days=29
            fi
        elif [[ $month -eq 1 || $month -eq 3 || $month -eq 5 || $month -eq 7 || $month == 08 || $month -eq 10 || $month -eq 12 ]]; then
            days=31
        else
            days=30
        fi
        start_date="$year-${month}-01T00:00:00Z"
        end_date="$year-${month}-${days}T23:00:00Z"
        url="${base_url}$year${month}.nc?var=dp&var=fp&var=hs&var=spr&var=t&north=0&west=255&east=300&south=-18&horizStride=1&time_start=${start_date}&time_end=${end_date}&timeStride=1&accept=netcdf"
        wget $url
        echo $month
        # for file in *.nc@var=hs*; 
		# do similar to this using regular expression : ww3.glob_24m.199001.nc@var=dp&var=fp&var=hs&var=spr&var=t&north=0&west=255&east=300&south=-18&horizStride=1&time_start=1990-01-01T00%3A00%3A00Z&time_end=1990-01-31T23%3A00%3A00Z&timeStride=1&accept=netcdf
        #     mv "$file" "${file%.nc@var=hs*}.nc"
        # done
		for file in *.nc@var=dp*;
		do
			mv "$file" "${file%.nc@var=hs*}.nc"
		done

	done
    done
done
