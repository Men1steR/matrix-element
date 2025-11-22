FROM vectorim/element-web:latest

COPY config.json /app/config.json.template
COPY docker-entrypoint.sh /docker-entrypoint.sh

USER root

RUN chmod 777 /docker-entrypoint.sh
RUN chmod 777 /app/config.json.template

USER root

ENTRYPOINT ["/docker-entrypoint.sh"]
