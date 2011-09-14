
set -e -u

HHTAB=hh0509
PTAB=p0509
DB=mig

psql $DB <<EOF

BEGIN;

	/* make 5 year age assignment */
	alter table ${PTAB} add column agep5 int;
	update ${PTAB} set agep5 = (agep/5) * 5;
	
	/* create unique state + puma code, index that */
	alter table ${HHTAB} add column geoid text;
	update ${HHTAB} set geoid = '0' || st || puma;
	alter table ${PTAB} add column geoid text;
	update ${PTAB} set geoid = '0' || st || puma;

    /* geoid for migration source */
	alter table ${PTAB} add column miggeoid text;
	update ${PTAB} set miggeoid = migsp || migpuma;    --- XXX watch out for foreign migsp

    /* set a bunch of 0/1 for tabulation later */
    alter table ${PTAB} add column iscollgrad int, 
                        add column ishsgrad int, 
						add column ishisp int;
    alter table ${PTAB} rename column racblk to isblack;

    update ${PTAB} set iscollgrad = 1 where schl >= 13;
    update ${PTAB} set iscollgrad = 0 where schl < 13;

    update ${PTAB} set ishsgrad = 1 where schl >= 9;
    update ${PTAB} set ishsgrad = 0 where schl < 9;

    update ${PTAB} set ishisp = 1 where hisp >= 2;
    update ${PTAB} set ishisp = 0 where hisp <= 1;

    COMMIT;
    
EOF
