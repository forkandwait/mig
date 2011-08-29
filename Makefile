# -*- mode: makefile-gmake -*-

.PHONY: pop
pop: pop.sh pop.txt

pop.txt : pop.sh
	sh pop.sh > pop.txt 2>pop.err

# mig: mig.sh mig.txt
# 	sh mig.sh > mig.txt 2>mig.err

# matrix: matrix.sh pop.txt mig.txt
# 	sh matrix.sh > matrix.txt 2>matrix.err
