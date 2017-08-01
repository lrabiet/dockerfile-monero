# Monero

Run https://getmonero.org with just a couple commands.

Set TOR_HOSTNAME variable to point to another container running Tor on port 9050.

    docker run \
        --rm -it \
        -v monero_data:/home/abc/.bitmonero \
        bwstitt/monero

# Todo

 * [ ] write docs
 * [ ] more configurable Tor connection
