BEGIN;
	
	/* make 5 year age assignment */
	alter table p0509 add column agep5 int;
	update p0509 set agep5 = (age/5) * 5;
	
	/*create unique state + puma code, index that */
	alter table hh0509 add column geoid text;
	update hh0509 set geoid = '0' || st || puma;

	alter table p0509 add column geoid text;
	update p0509 set geoid = '0' || st || puma;

	alter table p0509 add column miggeoid text;
	update p0509 set miggeoid = migsp || migpuma;    --- XXX watch out for foreign migsp


	/* migration/ geo indexes */
	create index p0509_miggeoid on p0509(miggeoid);
	create index p0509_srcmiggeoid on p0509(geoid, miggeoid);
	create index hh0509_geoid_idx on hh0509(geoid);
	create index p0509_geoid_idx on p0509(geoid);
	create index hh0509_st on hh0509(st);
	create index p0509_st on p0509(st);

	/* basic key indexes */
	create unique index hh0509_serialno on hh0509(serialno);
	create unique index p0509_serialno on p0509(serialno); 

	/* creat lots of possibly useful indexes */ 
	create index p0509_agep on p0509(agep);	
	create index p0509_fert on p0509(fert);
	create index p0509_mar on p0509(mar);
	create index p0509_mig on p0509(mig);	
	create index p0509_rel on p0509(rel);
	create index p0509_mig on p0509(mig);
	create index p0509_schl on p0509(schl);
	create index p0509_sex on p0509(sex);	
	create index p0509_esp on p0509(esp);
	create index p0509_esr on p0509(esr);
	create index p0509_msp on p0509(msp);
	create index p0509_nativity on p0509(nativity);
	create index p0509_paoc on p0509(paoc);
	create index p0509_pernp on p0509(pernp);

	create index p0509_racaian on p0509(racaian);
	create index p0509_RACASN on p0509(RACASN);
	create index p0509_RACBLK on p0509(RACBLK);
	create index p0509_RACNHPI on p0509(RACNHPI);
	create index p0509_WAOB on p0509(WAOB);

    -- language spoken at home... 
	ANALYZE;	
COMMIT;


-- make some useful aggregate tables
BEGIN;
	create table migcounts as 
		select geoid, miggeoid, sum(pwgtp) as wgtcnt, count(*) as reccnt 
			from p0509 
			group by geoid, miggeoid;
COMMIT;
