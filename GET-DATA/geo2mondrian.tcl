set TAB counties
set IDFLD cntyidfp
set GEOFLD geom_snap
set DB geocoder

set dataf [open "$TAB.txt" w]
set geof  [open "$TAB.map" w]

set SQL "select distinct $IDFLD
				, st_numpoints(st_exteriorring($GEOFLD)) as pn
                , regexp_replace(name, '\[^\[:alnum:\]\]', '', 'g') as name
                , statefp as statename 
                , random() as r
		 	from $TAB order by $IDFLD;"
set LINES [ exec psql -Aqt -d $DB -c $SQL ]

puts $dataf "FIPS	NUMPOINTS	NAME	STATEFIPS	COUNT"

foreach {L}  $LINES {
	set LL [split $L |]
	set ID [lindex $LL 0]
	set PCOUNT [lindex $LL 1]
	puts [join $LL "	"]

	# Export the map coordinate data + file
	set SQL "select st_x(g) || '  ' || st_y(g) from 
 				(select (st_dumppoints($GEOFLD)).geom as g from 
                    (select $GEOFLD from $TAB where $IDFLD='$ID') a) b;" 
	set POINTS [ exec psql -Aqt -d $DB -c $SQL ]

	puts $geof "$ID	/PCounty	$PCOUNT"
	puts $geof $POINTS;				# comes out of psql with newlines already

	# Export 
	puts $dataf [join $LL "	"]
}
