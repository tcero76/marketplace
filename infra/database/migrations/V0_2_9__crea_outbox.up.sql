CREATE TABLE marketplace.outbox (
    id BIGSERIAL PRIMARY KEY,
    aggregate_type TEXT NOT NULL,   -- Tipo de entidad que genera el evento
    aggregate_id TEXT NOT NULL,     -- ID de la entidad
    event_type TEXT NOT NULL,       -- Tipo de evento (por ejemplo: 'UserCreated')
    payload JSONB NOT NULL,         -- Datos del evento
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    processed BOOLEAN NOT NULL DEFAULT FALSE -- Si ya se envió al bus de mensajes
);

CREATE INDEX idx_outbox_processed_created_at
ON marketplace.outbox (processed, created_at);
