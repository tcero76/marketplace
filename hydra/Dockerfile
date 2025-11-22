ARG HYDRA_VERSION
FROM oryd/hydra:${HYDRA_VERSION:-latest}

COPY ./hydra/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]