ARG HYDRA_VERSION
FROM oryd/hydra:${HYDRA_VERSION:-latest} AS dev

ARG HYDRA_VERSION
FROM oryd/hydra:${HYDRA_VERSION:-latest} AS prod

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
    