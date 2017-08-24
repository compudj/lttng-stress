#!/bin/bash

dir=$(dirname $0)
hello_path=${dir}/../bin/hello/hello

for a in $(seq 1 1000000); do
	${hello_path}
done
