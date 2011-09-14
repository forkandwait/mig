
HHTAB=hh0509
PTAB=p0509
DB=mig

psql $DB <<EOF

	-- make some useful aggregate tables
	BEGIN;
        /* source / destination counts */
		create table migcounts as 
			select geoid, miggeoid, sum(pwgtp) as wgtcnt, count(*) as reccnt 
				from ${PTAB} 
				group by geoid, miggeoid;

        /* characteristics of PUMAS */
        create table pumachar as 
            select geoid
			       , sum(pwgtp) as pop
                   , count(*) as recs
				   
			       , sum(iscollgrad * pwgtp) as collgradsum
				   , sum(racblk * pwgtp) as blacksum
				   , sum(racwht * pwgtp) as whtsum
				   , sum(fhisp * pwgtp) as hispsum
                   , sum(racaian * pwgtp) as aiansum 
			   from ${PTAB}
			   group by geoid;
                          
                         
	COMMIT;
EOF
