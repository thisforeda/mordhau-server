FROM debian:stretch-slim

COPY entry /entry
COPY sources.list /etc/apt/sources.list

ENV STEAMAPPID  629800
ENV STEAMAPPDIR /home/steam/mordhau
ENV STEAMCMDDIR /home/steam/steamcmd
ENV STEAMCMDRES https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

RUN chmod 755 /entry

RUN useradd -m steam

RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        xdg-user-dirs \
        lib32stdc++6 \
        lib32gcc1 \
        wget \
        ca-certificates \
        procps \
        libcurl4-gnutls-dev \
        libcurl3-gnutls \
        libcurl3 \
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
        libxrandr2

RUN su steam -c \
        "mkdir -p ${STEAMCMDDIR} \
         && cd ${STEAMCMDDIR} \
         && wget -qO- $STEAMCMDRES | tar zxf -"

RUN su steam -c \
        "${STEAMCMDDIR}/steamcmd.sh \
         +login anonymous \
         +force_install_dir ${STEAMAPPDIR} \
         +app_update ${STEAMAPPID} validate \
         +quit"

RUN apt-get autoremove -y \
        && apt-get clean autoclean

USER steam
WORKDIR $STEAMAPPDIR
EXPOSE 7777 15000 27015

ENTRYPOINT /entry

