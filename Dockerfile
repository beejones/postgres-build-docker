FROM ubuntu:22.04

# clone postgres and install build tools
WORKDIR /sandbox
RUN apt-get update
RUN apt-get install git build-essential libreadline-dev libghc-zlib-dev libssl-dev  flex-doc bison-doc flex bison libxml2-utils -y

RUN git clone https://github.com/postgres/postgres

WORKDIR /sandbox/postgres
RUN git checkout REL_14_3
WORKDIR /sandbox/postgres/build
RUN ../configure --enable-debug --with-openssl  
RUN make world-bin

RUN useradd -ms /bin/bash postgres
RUN make install

USER postgres

WORKDIR /sandbox/data/psql
RUN chown postgres /sandbox/data/psql

RUN /usr/local/pgsql/bin/initdb -D /sandbox/data/psql

CMD /usr/local/pgsql/bin/postgres -D /sandbox/data/psql
#ENTRYPOINT ["tail", "-f", "/dev/null"]