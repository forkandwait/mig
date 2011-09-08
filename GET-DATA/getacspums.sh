#!/bin/sh
set -e -u

YEAR=acs2009_5yr

echo "Starting to download for year = $YEAR, $(date)"

STATES="ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma md \
    me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa pr ri sc sd tn \
    tx ut va vt wa wi wv wy"

for ST in $STATES; do
	echo "$ST, $(date)" 1>&2
	curl -s "ftp://ftp2.census.gov/${YEAR}/pums/csv_h${ST}.zip" > "csv_h${ST}.zip"
	
	sleep 2
	curl -s "ftp://ftp2.census.gov/${YEAR}/pums/csv_p${ST}.zip" > "csv_p${ST}.zip"

	sleep 2
	unzip  -n "csv_h${ST}.zip" -d "h${ST}"
	unzip  -n "csv_p${ST}.zip" -d "p${ST}"

	rm  "csv_h${ST}.zip"
	rm  "csv_p${ST}.zip"

	sleep 4
	exit
done

echo "Finished to download for year = $YEAR, $(date)"
