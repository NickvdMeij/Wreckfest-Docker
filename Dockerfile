FROM ubuntu:16.04

ARG TZ="Europe/Amsterdam"
RUN sed -i 's/archive.ubuntu.com/au.archive.ubuntu.com/' /etc/apt/sources.list
RUN apt-get update  && apt-get dist-upgrade -y &&\
	apt-get install -y unzip p7zip-full curl wget lib32gcc1 iproute2 vim-tiny bzip2 jq software-properties-common apt-transport-https lib32stdc++6 && \
	apt-get clean
RUN echo "$TZ" > /etc/timezone
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime

RUN useradd -m steam

RUN mkdir -p /steam/steamcmd_linux

RUN chown -R steam /steam
USER steam


WORKDIR /steam/steamcmd_linux
RUN wget https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz 
RUN tar -xf steamcmd_linux.tar.gz


RUN ./steamcmd.sh +login anonymous +quit

USER root
RUN apt-get install -y software-properties-common apt-transport-https && dpkg --add-architecture i386 && wget https://dl.winehq.org/wine-builds/winehq.key && apt-key add winehq.key && apt-add-repository 'https://dl.winehq.org/wine-builds/ubuntu/'
RUN apt-get update && apt-get install -y --install-recommends winehq-staging xvfb


USER steam
WORKDIR /steam/steamcmd_linux
RUN mkdir -p /steam/wreckfest

RUN ./steamcmd.sh +login anonymous +@sSteamCmdForcePlatformType windows +force_install_dir ../wreckfest +app_update 361580  +quit

WORKDIR /steam/wreckfest
ADD start*.sh /steam/wreckfest/
CMD ["./start-wreckfest.sh"]