## Downloads and preps the entire country worth of PUMA geographies

set -e -u

# clear previously downloaded data 
rm -f puma100_ddl.sql puma100_data.sql

# census state level codes
source "./statenames.sh"
tlen=${#FULLNAMES[@]}

# use for loop read all puma geographies (clobbers ddl each time)
for (( i=0; i<${tlen}; i++ )); do
	FN=${FULLNAMES[i]}
	C=${CODES[i]}
	BNAME="tl_2009_${C}_puma100"

	echo "working on $FN"
	sleep 2

	curl -s -S "ftp://tigerline.census.gov/${FN}/${BNAME}.zip" > "${BNAME}.zip"
	unzip -o "${BNAME}.zip" -d "${BNAME}.d" 1>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -p -s 4269 -g -I "${BNAME}.d/${BNAME}" "${BNAME}"  > "puma100_ddl.sql" 2>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -a -s 4269 -g -I "${BNAME}.d/${BNAME}" "${BNAME}" >> "puma100_data.sql" 2>/dev/null 
done

#ftp://tigerline.census.gov/01_ALABAMA/tl_2009_01_puma100.zip
