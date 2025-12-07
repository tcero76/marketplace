FROM mcr.microsoft.com/playwright/python:v1.50.0-noble AS base
  ENV PWDEBUG=0
  ENV PYTHONUNBUFFERED=1
  WORKDIR /app
  
  RUN groupadd -r app && useradd -r -g app -m app
  
  COPY scrap-service/requirements.txt /app/requirements.txt
  
  RUN apt-get update && apt-get install -y \
      libpq-dev gcc python3-dev python3-venv \
      && rm -rf /var/lib/apt/lists/*
  
  RUN python3 -m venv /venv
  ENV PATH="/venv/bin:$PATH"
  
  RUN pip install --upgrade pip && \
      pip install --no-cache-dir -r /app/requirements.txt
  
  
  FROM base AS dev
  
  COPY scrap-service/ /app/scrap-service/
  COPY rabbitmq/ /app/rabbitmq/
  
  RUN pip install debugpy watchdog watchfiles
  
  COPY scrap-service/deploy/entrypoint-dev.sh /entrypoint.sh
  RUN chmod +x /entrypoint.sh
  
  ENV PYTHONPATH="/app:${PYTHONPATH}"
  
  CMD ["/entrypoint.sh"]
  
  
  FROM base AS prod
  RUN playwright==1.50.0

  COPY --chown=app:app scrap-service/ /app/scrap-service/
  COPY --chown=app:app rabbitmq/ /app/rabbitmq/
  
  USER app
  
  HEALTHCHECK --interval=30s --timeout=5s --start-period=10s \
    CMD python -c "import sys; sys.exit(0)"
  
  USER root
  COPY scrap-service/deploy/entrypoint.sh /entrypoint.sh
  RUN chmod +x /entrypoint.sh

  ENV PYTHONPATH="/app"
  
  USER app
  ENTRYPOINT ["/entrypoint.sh"]
  
