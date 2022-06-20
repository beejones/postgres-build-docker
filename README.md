# postgres-build-docker
Docker container to build postgres 14.3 with debugging options.

Only to use for testing and not in production.


# Build
```
docker build . -t postgres-build
```
# Run 
```
# eccomp:unconfined is needed to debug the container
docker run -dp 5432:5432 -dp 2223:22 --security-opt seccomp:unconfined -v $PWD/pg_waldump:/sandbox/postgres/build/src/bin/pg_waldump --name postgres-build postgres-build
```
# Visit container and run psql
```
docker exec -it postgres-build bash
/usr/local/pgsql/bin/psql
```
# Use ssh and login to the container
```
ssh -l root localhost
```

# Debugging pg_waldump
## Install C++ extension in VC

## install sshpass
```
sudo apt-get install sshpass
```
## run postgres
```
sshpass -p postgres ssh postgres@localhost -p 2223
/usr/local/pgsql/bin/postgres -D /sandbox/data/psql
```

## Set pgbench model in container
/sandbox/postgres/build/src/bin/pgbench/pgbench -i -s 5 postgres -U postgres

## run pg_waldump in container
/sandbox/postgres/build/src/bin/pg_waldump/pg_waldump -p /sandbox/data/psql/ -s 0/5000000
