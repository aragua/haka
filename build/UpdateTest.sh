#!/bin/bash

export HAKA_TEST_FIX=$(pwd)/haka-test-fix

for i in $(seq $1 $2)
do
	CONTINUE=1
	while [ $CONTINUE = 1 ]; do
		rm -f $HAKA_TEST_FIX
		ctest -V -I $i,$i

		if [ $? = 0 ]; then
			CONTINUE=0
		else
			if [ -f "$HAKA_TEST_FIX" ]; then
				cat $HAKA_TEST_FIX
				read -p "Update test? (y/n) " -n 1 -r
				echo
				case $REPLY in
				"y") bash -c "$(cat $HAKA_TEST_FIX)";;
				*) echo ERROR: Test not updated; CONTINUE=0;;
				esac
			else
				echo ERROR: Test failed
				CONTINUE=0
			fi
		fi
	done
	
	echo $i
done
