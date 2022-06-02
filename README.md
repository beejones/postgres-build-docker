# postgres-build-docker
Docker container to build postgres 14.3 with debugging options.

Only to use for testing and not in production.


# Build
```
docker build . -t postgres-build
```
# Run 
```
docker run -dp 5432:5432 --name postgres-build postgres-build
```
# Visit container and run psql
```
docker exec -it postgres-build bash
/usr/local/pgsql/bin/psql
```
