FROM rabbitmq:4.0-management

COPY ./init_rabbitmq.sh /init_rabbitmq.sh
RUN apt-get update && apt-get install -y netcat-openbsd


ENTRYPOINT [ "sh", "/init_rabbitmq.sh" ]