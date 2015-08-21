#!/bin/bash

NUM=$1

for a in $(seq 1 1000000); do
	echo "Viewer loop begin"
	#babeltrace -v -i lttng-live net://localhost/host/${HOSTNAME}/testrelay${NUM} > /dev/null
	babeltrace -v -i lttng-live net://localhost/host/${HOSTNAME}/testrelay${NUM} > /dev/null
	# TODO: also test with sleep
	#sleep 1
	# TODO: also test without -v (for speed)
	#babeltrace -i lttng-live net://localhost/host/${HOSTNAME}/testrelay${NUM}
done
