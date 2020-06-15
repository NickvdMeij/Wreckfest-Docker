#!/bin/bash

# force Umask
  umask 002

# export our wineprefix and setup our display
  Xvfb :0 -screen 0 1024x768x16 > /dev/null 2>&1 &

# prepare WINEPREFIX
  wineboot -i

# download/install steamcmd.exe
  if [ ! -f ${WINEPREFIX}/drive_c/Steam/steamcmd.exe ]; then
    wine cmd /c "mkdir C:\\Steam"
    curl -SL https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip | bsdtar -C /tmp -xf -
    wine cmd /c "copy Z:\\tmp\steamcmd.exe C:\\Steam"
  fi

# update/install Wreckfest
  wine cmd /c "C:\\Steam\\SteamCMD.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir C:\\Wreckfest +app_update 361580 -validate +quit"

# add initial config
  if [ ! -f ${WINEPREFIX}/drive_c/wreckfest/server_config.cfg ]; then
    cp ${WINEPREFIX}/drive_c/wreckfest/initial_server_config.cfg ${WINEPREFIX}/drive_c/wreckfest/server_config.cfg
  fi

# override all config with custom config #BIECHERS FTW

  cp /biechters/server_config.cfg ${WINEPREFIX}/drive_c/wreckfest/server_config.cfg

# run wreckfest
  cd ${WINEPREFIX}/drive_c/wreckfest; wine cmd /c "server\\Wreckfest.exe -s server_config=server_config.cfg"

