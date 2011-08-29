
## Downloads and preps the entire countries worth of PUMA geographies

set -e -u

source "./statenames.sh"

# get length of an array
tlen=${#FULLNAMES[@]}
 
rm -f allpumas.sql
# use for loop read all puma geographies
for (( i=0; i<${tlen}; i++ )); do
	FN=${FULLNAMES[i]}
	C=${CODES[i]}
	BNAME="tl_2009_${C}_puma100"

	curl "ftp://tigerline.census.gov/${FN}/${BNAME}.zip" > "${BNAME}.zip"
	unzip -o "${BNAME}.zip" -d "${BNAME}.d"
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -p -s 4269 -g -I "${BNAME}.d/${BNAME}" "${BNAME}"  > "puma100_ddl.sql"
	/usr/lib64/postgresql-8.4/bin/shp2pgsql -a -s 4269 -g -I "${BNAME}.d/${BNAME}" "${BNAME}" >> "puma100_data.sql"
done

#ftp://tigerline.census.gov/01_ALABAMA/tl_2009_01_puma100.zip
