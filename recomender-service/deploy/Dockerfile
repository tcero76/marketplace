FROM python:3.9-slim AS base

WORKDIR /app/recomender-service

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libxml2-dev \
        libxslt1-dev \
        zlib1g-dev \
        libgomp1 && \
    rm -rf /var/lib/apt/lists/*

# Actualizar pip
RUN pip install --upgrade pip

FROM base AS builder

COPY recomender-service/requirements.txt .
RUN pip install --prefix=/install -r requirements.txt

FROM base AS dev

RUN apt-get update && apt-get install -y \
      git curl vim iputils-ping && \
    rm -rf /var/lib/apt/lists/*

COPY recomender-service/requirements.txt .

RUN pip install -r requirements.txt

COPY recomender-service/ .

ENV PYTHONPATH="/app:${PYTHONPATH}"

CMD ["python", "main.py"]

FROM base AS prod

COPY --from=builder /install /usr/local

COPY recomender-service/ .

ENV PYTHONPATH="/app:${PYTHONPATH}"

CMD ["python", "main.py"]
