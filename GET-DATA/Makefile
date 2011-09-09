STATES=pak pal par paz pca pco pct pdc pde pfl pga phi pia pid pil	\
pin pks pky pla pma pmd pme pmi pmn pmo pms pmt pnc pnd pne pnh pnj	\
pnm pnv pny poh pok por ppa ppr pri psc psd ptn ptx put pva pvt pwa	\
pwi pwv pwy hak hal har haz hca hco hct hdc hde hfl hga hhi hia hid	\
hil hin hks hky hla hma hmd hme hmi hmn hmo hms hmt hnc hnd hne hnh	\
hnj hnm hnv hny hoh hok hor hpa hpr hri hsc hsd htn htx hut hva hvt	\
hwa hwi hwv hwy


# deal with pums data 
.PHONY: clearstates

clearstates:
	rm -Rf $(STATES)

# generate tables to hold micro-data
.mkpumstabs: mkpumstabs.sh
	sh mkpumstabs.sh
	touch .mkpumstabs

# Download all the states data
.getacspums: getacspums.sh
	sh getacspums.sh
	touch .getacspums

# push data into database
.loadacspums: .getacspums loadacspums.sh
	sh loadacspums.sh
	touch .loadacspums

# postprocess loaded pums microdata
.postprocesspums: .loadacspums postprocesspums.sh 
	sh postprocesspums.sh
	touch .postprocesspums

# deal with geography data
