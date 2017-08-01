# todo: use alpine linux to keep our images smaller
FROM bwstitt/debian:jessie

EXPOSE 18080 18081

ENTRYPOINT ["/entrypoint.sh"]
CMD ["monerod"]

HEALTHCHECK --interval=5m --timeout=3s \
    CMD monero-wallet-cli getinfo || exit 1

RUN docker-apt-install \
    bzip2 \
    ca-certificates \
    curl \
    torsocks

ENV MONERO_VERSION 0.10.3.1
ENV MONERO_SHA256 8db80f8cc4f80d4106db807432828df730a59eac78972ea81652aa6b9bac04ad
RUN curl -fSL -o monero.tar.bz2 "https://downloads.getmonero.org/cli/monero-linux-x64-v$MONERO_VERSION.tar.bz2" \
 && echo "$MONERO_SHA256 monero.tar.bz2" | sha256sum -c - \
 && tar -xjvf monero.tar.bz2 \
 && cp ./monero-v$MONERO_VERSION/* /usr/local/bin/ \
 && rm -rf monero*

ADD bitmonero.conf /home/abc/
RUN chown abc:abc /home/abc/bitmonero.conf

# this config will be setup by the entrypoint script if TOR_HOSTNAME is set
RUN touch /etc/tor/torsocks.conf \
 && chown abc:abc /etc/tor/torsocks.conf

# Use the default user that comes with the image
USER abc
ENV HOME /home/abc
WORKDIR /home/abc

# setup data volumes
RUN mkdir -p ~/.bitmonero
VOLUME /home/abc/.bitmonero

ADD entrypoint.sh /
