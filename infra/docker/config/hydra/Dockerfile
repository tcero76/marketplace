ARG HYDRA_VERSION AS prod
FROM oryd/hydra:${HYDRA_VERSION:-latest}

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]