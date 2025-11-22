FROM postgres:16

COPY create-matrix-db.sql /docker-entrypoint-initdb.d/

RUN chmod 777 /docker-entrypoint-initdb.d/create-matrix-db.sql