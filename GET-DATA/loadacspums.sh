#!/bin/sh
set -e -u

YR="0509"
DB=mig
##FPREF="/other/webbs/macbackup/EVERYTHING_ANALYSIS/INCOMING/USCENSUS/ACS"
FPREF='.'
STATES="ak al ar az ca co ct dc de fl ga hi ia id il in ks ky la ma md \
    me mi mn mo ms mt nc nd ne nh nj nm nv ny oh ok or pa pr ri sc sd tn \
    tx ut va vt wa wi wv wy"


for ST in $STATES; do
	echo "$ST $(date)"

	PCOMMAND="copy p${YR} from '$FPREF/p${ST}/ss09p${ST}.csv' with csv header;" 
	psql --dbname="$DB" --command="$PCOMMAND"

	HHCOMMAND="copy hh${YR} from '$FPREF/h${ST}/ss09h${ST}.csv' with csv header;" 
	psql --dbname="$DB" --command="$HHCOMMAND"

	sleep 2
done


