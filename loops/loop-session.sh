#!/bin/bash

NUM=$1

for a in $(seq 1 1000000); do
	lttng create testrelay${NUM} -U net://localhost --live
	# TODO: test with no rotation.
	#lttng enable-channel -u -s testrelay${NUM} chan1
	# TODO: test with more files in rotation.
	#lttng enable-channel -u -s testrelay${NUM} --subbuf-size 4096 -C 4096 -W 32 chan1
	lttng enable-channel -u -s testrelay${NUM} --subbuf-size 4096 -C 4096 -W 2 chan1
	lttng enable-event -u -a -c chan1 -s testrelay${NUM}
	lttng start testrelay${NUM}
	# TODO: also test without sleep
	sleep 1
	lttng destroy testrelay${NUM}
done
