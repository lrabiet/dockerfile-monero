#!/bin/bash
set -ex

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
    # numa='numactl --interleave=all'
    # if $numa true &> /dev/null; then
    #     echo "numactl works"
    #     set -- $numa "$@"
    # else
    #     echo "Failed to setup numactl"
    # fi

    # keep config outside the volume
    exec --config-file $HOME/bitmonero.conf "$@"
fi

# otherwise, don't get in their way
exec "$@"
