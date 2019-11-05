FROM shel1/steamcmd

COPY entry /entry
COPY sources.list /etc/apt/sources.list

ENV STEAMAPPID   629800
ENV STEAMAPPDIR  /home/steam/mordhau

RUN apt-get update && apt-get install -y --no-install-recommends --no-install-suggests \
        procps \
        libcurl4-gnutls-dev \
        libfontconfig1 \
        libpangocairo-1.0-0 \
        libnss3 \
        libgconf2-4 \
        libxi6 \
        libxcursor1 \
        libxss1 \
        libxcomposite1 \
        libasound2 \
        libxdamage1 \
        libxtst6 \
        libatk1.0-0 \
        libxrandr2 \
        && apt-get autoremove -y \
        && apt-get clean autoclean \
        && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
        && chmod 755 /entry \
        && su steam -c \
            "${STEAMCMDDIR}/steamcmd.sh \
             +login anonymous \
             +force_install_dir ${STEAMAPPDIR} \
             +app_update ${STEAMAPPID} validate \
             +quit"

USER steam
WORKDIR /home/steam

EXPOSE 7777
EXPOSE 15000 
EXPOSE 27015

ENTRYPOINT /entry
