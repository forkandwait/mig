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
	BNAME100="tl_2009_${C}_puma100"
	BNAME500="tl_2009_${C}_puma500"

	echo "working on $FN"
	sleep 2

	curl -s -S "ftp://tigerline.census.gov/${FN}/${BNAME100}.zip" > "${BNAME100}.zip"
	unzip -o "${BNAME100}.zip" -d "${BNAME100}.d" 1>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -p -s 4269 -g the_geom -I "${BNAME100}.d/${BNAME100}" "puma100"  > \
		"puma100_ddl.sql" 2>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -a -s 4269 -g the_geom "${BNAME100}.d/${BNAME100}" "puma100" >> \
		"puma100_data.sql" 2>/dev/null 
	rm "${BNAME100}.zip"
	rm ${BNAME100}.d/*
	rmdir "${BNAME100}.d"


	curl -s -S "ftp://tigerline.census.gov/${FN}/${BNAME500}.zip" > "${BNAME500}.zip"
	unzip -o "${BNAME500}.zip" -d "${BNAME500}.d" 1>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -p -s 4269 -g the_geom -I "${BNAME500}.d/${BNAME500}" "puma500"  > \
		"puma500_ddl.sql" 2>/dev/null
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -a -s 4269 -g the_geom "${BNAME500}.d/${BNAME500}" "puma500" >> \
		"puma500_data.sql" 2>/dev/null 
	rm "${BNAME500}.zip"
	rm ${BNAME500}.d/*
	rmdir "${BNAME500}.d"

done

#ftp://tigerline.census.gov/01_ALABAMA/tl_2009_01_puma100.zip
