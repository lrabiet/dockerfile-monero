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
    # TODO: if the config has "rpc-login=monero:changeme", change it automatically

    if [ -n "$TOR_HOSTNAME" ]; then
        # torsocks does not support name resolution so we do it here
        TORSOCKS_CONF_FILE=/etc/tor/torsocks.conf
        until [ -n "$TOR_PROXY_IP" ]; do
            TOR_PROXY_IP=$(getent hosts "$TOR_HOSTNAME" | cut -f1 -d' ')

            # TODO: max wait?
            if [ -z "$TOR_PROXY_IP" ]; then
                echo "Tor is not yet running at $TOR_HOSTNAME! Sleeping..."
                sleep 10
            fi
        done
        echo "TorAddress $TOR_PROXY_IP" >> "$TORSOCKS_CONF_FILE"

        # torify everything
        export TORSOCKS_CONF_FILE
        export LD_PRELOAD=/usr/lib/torsocks/libtorsocks.so

        # make monero work with Tor
        # https://github.com/monero-project/monero/blob/master/README.md#using-tor
        export DNS_PUBLIC=tcp
        export TORSOCKS_ALLOW_INBOUND=1
    fi

    # keep config outside the volume
    exec "$@" --config-file $HOME/bitmonero.conf
fi

# otherwise, don't get in their way
exec "$@"
