FROM zalaare/x86_64.wreckfest-server:latest

COPY ./server_config.cfg /biechters/server_config.cfg
COPY ./entrypoint.sh /biechters/entrypoint.sh
CMD ["/biechters/entrypoint.sh"]
