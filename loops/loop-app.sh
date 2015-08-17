#!/bin/sh

for a in $(seq 1 1000000); do
	# TODO: run an hello program modified to trace 10000 events.
	~/git/lttng-ust/tests/hello/hello
done
