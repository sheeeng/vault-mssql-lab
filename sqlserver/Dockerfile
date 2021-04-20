FROM mcr.microsoft.com/mssql/server:2019-CU10-ubuntu-20.04

USER root
RUN mkdir --parents /usr/src/app

WORKDIR /usr/src/app
COPY . /usr/src/app
RUN chmod +x /usr/src/app/import.sh
RUN chown --recursive mssql .

USER mssql
CMD [ "/bin/bash", "./entrypoint.sh" ]
