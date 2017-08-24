#!/bin/bash
#
# Copyright (C) - 2017 Jonathan Rajotte-Julien <jonathan.rajotte-julien@efficios.com>
#
# This library is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; version 2.1 of the License.
#
# This library is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this library; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA

DIR=$(dirname $0)
HELLO_PATH=${DIR}/../bin/hello/hello
APP_GENERATOR_PID=""
STRESS_PID=""

SESSIOND_MATCH=".*lttng-sess.*"
RUNAS_MATCH=".*lttng-runas.*"
CONSUMERD_MATCH=".*lttng-consumerd.*"

# Make sure to kill all background job if any
function cleanup ()
{
	pids="$(pgrep $SESSIOND_MATCH) $(pgrep $RUNAS_MATCH)"
	kill -9 $STRESS_PID $pids 2> /dev/null
	exit 0
}

trap cleanup INT TERM
trap "kill 0" EXIT

# Do not spawn automatically sessiond
export LTTNG_SESSIOND_PATH="/bin/true"

# Wait forever
export LTTNG_UST_REGISTER_TIMEOUT=-1
export LTTNG_NETWORK_SOCKET_TIMEOUT=-1
export LTTNG_APP_SOCKET_TIMEOUT=-1

ulimit -c unlimited

function app_generator()
{
	export LTTNG_UST_REGISTER_TIMEOUT=-1
	export LTTNG_NETWORK_SOCKET_TIMEOUT=-1
	export LTTNG_APP_SOCKET_TIMEOUT=-1
	trap "exit 0" SIGINT SIGTERM
	while :
	do
		${HELLO_PATH} 10 1> /dev/null 2>/dev/null
	done
}


function stop_lttng_sessiond ()
{
	local pids="$(pgrep $SESSIOND_MATCH) $(pgrep $RUNAS_MATCH)"
	local out=1
	kill $pids
	while [ -n "$out" ]; do
		out=$(pgrep ${SESSIOND_MATCH})
		sleep 0.5
	done
	out=1
	while [ -n "$out" ]; do
		out=$(pgrep $CONSUMERD_MATCH)
		sleep 0.5
	done
}

for (( i = 0; i < 100; i++ )); do
	app_generator &
done

stress --cpu 10 &
STRESS_PID=$!

for (( i = 0; i < 10000; i++ )); do
	eval lttng-sessiond --background
	lttng create testsession
	lttng enable-channel -u --subbuf-size $(getconf PAGE_SIZE) mychannel
	lttng enable-event -c mychannel -u -a
	lttng start
	stop_lttng_sessiond
	echo "------------------------------------------------------------------------------------"
done



