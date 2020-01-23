FROM debian:stretch-slim

ENV STEAMAPPID  ${STEAMAPPID}
ENV STEAMAPPDIR /home/steam
ENV STEAMCMDDIR /home/steam/steamcmd
ENV STEAMCMDRES https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz
ENV PATH "${STEAMAPPDIR}:${PATH}"

RUN useradd -m steam
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends --no-install-suggests \
        xdg-user-dirs \
        lib32stdc++6 \
        lib32gcc1 \
        wget \
        ca-certificates \
        iputils-ping \
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
COPY entry ${STEAMAPPDIR}/entry
WORKDIR $STEAMAPPDIR
USER steam
