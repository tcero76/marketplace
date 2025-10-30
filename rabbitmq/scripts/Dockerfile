FROM rabbitmq:4.0-management

COPY ./init_rabbitmq.sh /init_rabbitmq.sh


ENTRYPOINT [ "sh", "/init_rabbitmq.sh" ]