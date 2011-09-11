
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
    update ${PTAB} set iscollgrad = 1 where schl >= 13;
    update ${PTAB} set iscollgrad = 0 where schl < 13;

    update ${PTAB} set ishsgrad = 1 where schl >= 9;
    update ${PTAB} set ishsgrad = 0 where schl < 9;
    COMMIT;

    BEGIN;
	/* basic key indexes */
	create unique index ${HHTAB}_person_idx on ${HHTAB}(serialno, sporder);
	create unique index ${PTAB}_serialno_idx on ${PTAB}(serialno); 

	/* other possibly useful indexes */ 
	create index ${PTAB}_agep_idx on ${PTAB}(agep);	
	create index ${PTAB}_mig_idx on ${PTAB}(mig);
	create index ${PTAB}_sex_idx on ${PTAB}(sex);	


	/* migration and geo indexes */
	create index ${PTAB}_miggeoid on ${PTAB}(miggeoid);
	create index ${PTAB}_srcmiggeoid on ${PTAB}(geoid, miggeoid);
	create index ${HHTAB}_geoid_idx on ${HHTAB}(geoid);
	create index ${PTAB}_geoid_idx on ${PTAB}(geoid);
	create index ${HHTAB}_st on ${HHTAB}(st);
	create index ${PTAB}_st on ${PTAB}(st);

	/*  -- maybe should use binary thing?
    create index ${PTAB}_fert on ${PTAB}(fert);
	create index ${PTAB}_mar on ${PTAB}(mar);
	create index ${PTAB}_mig on ${PTAB}(mig);	
	create index ${PTAB}_rel on ${PTAB}(rel);
	create index ${PTAB}_schl on ${PTAB}(schl);
	create index ${PTAB}_esp on ${PTAB}(esp);
	create index ${PTAB}_esr on ${PTAB}(esr);
	create index ${PTAB}_msp on ${PTAB}(msp);
	create index ${PTAB}_nativity on ${PTAB}(nativity);
	create index ${PTAB}_paoc on ${PTAB}(paoc);
	create index ${PTAB}_pernp on ${PTAB}(pernp);

	create index ${PTAB}_racaian on ${PTAB}(racaian);
	create index ${PTAB}_racasn on ${PTAB}(racasn);
	create index ${PTAB}_racblk on ${PTAB}(racblk);
	create index ${PTAB}_racnhpi on ${PTAB}(racnhpi);
	create index ${PTAB}_waob on ${PTAB}(waob);
    -- language spoken at home... 
    */

	ANALYZE;	
	COMMIT;
EOF
