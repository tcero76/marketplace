    FROM python:3.9-slim AS base

    RUN apt-get update && apt-get install -y --no-install-recommends \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        && rm -rf /var/lib/apt/lists/*
    
    WORKDIR /app/beat-service
    
    RUN python -m venv /venv
    ENV PATH="/venv/bin:$PATH"
    
    COPY beat-service/requirements.txt .
    
    RUN pip install --upgrade pip && \
        pip install --no-cache-dir -r requirements.txt
    
    
    FROM base AS dev
    
    RUN pip install watchdog
    
    USER root
    
    ENV PYTHONPATH="/app"

    ENTRYPOINT [ "celery", "-A", "main", "beat", "--loglevel=debug"]
    
    FROM base AS prod
    
    COPY --from=base /venv /venv
    ENV PATH="/venv/bin:$PATH"
    
    RUN useradd -m -r app
    USER app
    
    WORKDIR /app/beat-service
    
    COPY --chown=app:app beat-service/ /app/beat-service/
    COPY --chown=app:app rabbitmq/ /app/rabbitmq/

    ENV PYTHONPATH="/app"
    
    COPY beat-service/deploy/entrypoint.sh /entrypoint.sh
    
    ENTRYPOINT ["/entrypoint.sh"]
    