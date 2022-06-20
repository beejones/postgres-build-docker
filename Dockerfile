FROM ubuntu:22.04

RUN apt-get update
# install build dependencies to build and debug 
RUN apt-get update \
    && apt-get install -y g++ build-essential make cmake gdb gdbserver \
       rsync zip openssh-server git 

RUN apt-get install git libreadline-dev libghc-zlib-dev libssl-dev  flex-doc bison-doc flex bison libxml2-utils -y

# configure SSH for communication with Visual Studio 
RUN mkdir -p /var/run/sshd

RUN echo 'root:root' | chpasswd \
    && sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd


# clone postgres and install build tools
WORKDIR /sandbox
RUN git clone https://github.com/postgres/postgres

WORKDIR /sandbox/postgres
RUN git checkout REL_14_3
WORKDIR /sandbox/postgres/build
RUN ../configure --enable-debug --with-openssl  
RUN make world-bin
COPY ./rsh.sh .

RUN make install

# Set postgres user
RUN useradd -ms /bin/bash postgres
RUN echo "postgres:postgres" | chpasswd
USER postgres

WORKDIR /sandbox/data/psql
RUN chown postgres /sandbox/data/psql

# Start postgres
RUN /usr/local/pgsql/bin/initdb -D /sandbox/data/psql
#RUN /sandbox/postgres/build/rsh.sh

USER root
CMD ["/usr/sbin/sshd", "-D"]

#CMD /usr/local/pgsql/bin/postgres -D /sandbox/data/psql
#ENTRYPOINT ["tail", "-f", "/dev/null"]
