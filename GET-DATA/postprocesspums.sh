
HHTAB=hh0509
PTAB=p0509
DB=mig

psql $DB <<EOF

BEGIN;
	
	/* make 5 year age assignment */
	alter table ${PTAB} add column agep5 int;
	update ${PTAB} set agep5 = (age/5) * 5;
	
	/* create unique state + puma code, index that */
	alter table ${HTAB} add column geoid text;
	update ${HTAB} set geoid = '0' || st || puma;
	alter table ${PTAB} add column geoid text;
	update ${PTAB} set geoid = '0' || st || puma;

    /* geoid for migration source */
	alter table ${PTAB} add column miggeoid text;
	update ${PTAB} set miggeoid = migsp || migpuma;    --- XXX watch out for foreign migsp


	/* migration and geo indexes */
	create index ${PTAB}_miggeoid on ${PTAB}(miggeoid);
	create index ${PTAB}_srcmiggeoid on ${PTAB}(geoid, miggeoid);
	create index ${HTAB}_geoid_idx on ${HTAB}(geoid);
	create index ${PTAB}_geoid_idx on ${PTAB}(geoid);
	create index ${HTAB}_st on ${HTAB}(st);
	create index ${PTAB}_st on ${PTAB}(st);

    /* set a bunch of 0/1 for tabulation later */
    alter table ${PTAB} add column iscollgrad int, 
                        add column ishsgrad int, 
						add column ishisp int;
    update ${PTAB} set iscollgrad = 1 where schl >= 13;
    update ${PTAB} set iscollgrad = 0 where schl < 13;

    update ${PTAB} set ishsgrad = 1 where schl >= 9;
    update ${PTAB} set ishsgrad = 0 where schl < 9;
    
    



	/* basic key indexes */
	create unique index ${HTAB}_serialno on ${HTAB}(serialno);
	create unique index ${PTAB}_serialno on ${PTAB}(serialno); 

	/* creat lots of possibly useful indexes */ 
	create index ${PTAB}_agep on ${PTAB}(agep);	
	create index ${PTAB}_mig on ${PTAB}(mig);
	create index ${PTAB}_sex on ${PTAB}(sex);	


	/*
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
