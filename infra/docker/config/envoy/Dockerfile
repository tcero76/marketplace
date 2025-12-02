    FROM envoyproxy/envoy:v1.28.0 AS base

    COPY envoy/entrypoint.sh /entrypoint.sh
    RUN chmod +x /entrypoint.sh
    
    RUN apt-get update && apt-get install -y gettext
    
    WORKDIR /tmpl
    
    FROM base AS dev
    COPY envoy/envoy.dev.yaml /tmpl/envoy.yaml
    ENTRYPOINT [ "/entrypoint.sh" ]
    
    FROM base AS prod
    COPY envoy/envoy.prod.yaml /tmpl/envoy.yaml
    ENTRYPOINT [ "/entrypoint.sh" ]
    