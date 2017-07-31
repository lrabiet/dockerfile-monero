#!/bin/bash
set -e

# this if will check if the first argument is a flag
# but only works if all arguments require a hyphenated flag
# -v; -SL; -f arg; etc will work, but not arg1 arg2
if [ "${1:0:1}" = '-' ]; then
    set -- monerod "$@"
fi

# check for the expected command
if [ "$1" = 'monerod' ]; then
    # make efficient use of memory
    # TODO: benchmark how much this helps
    numa='numactl --interleave=all'
    if $numa true &> /dev/null; then
        set -- $numa "$@"
    else
        echo "Failed to setup numactl"
    fi

    exec "$@" --rpc-bind-ip=0.0.0.0 --confirm-external-bind
fi

# otherwise, don't get in their way
exec "$@"
