--
-- Name: marketplace; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS marketplace;

ALTER SCHEMA marketplace OWNER TO tcero;

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA marketplace;

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;

--
-- Name: productos; Type: TABLE; Schema: marketplace; Owner: tcero
--

CREATE TABLE marketplace.productos (
    id integer,
    text text,
    author character varying(125),
    tags text,
    job_id uuid,
    processed_at timestamp without time zone
);

CREATE TABLE marketplace.users (
    user_id uuid,
    nombre text,
    password text,
    roles text,
    PRIMARY KEY (user_id)
);

CREATE TABLE IF NOT EXISTS marketplace.modelos(
	id integer,
    id_job bigint,
	modelo varchar(125) UNIQUE,
	descripcion text,
	created_at timestamp,
	deleted_at timestamptz null,
	PRIMARY KEY(id,id_job)
);

CREATE TABLE IF NOT EXISTS marketplace.posts(
	id integer,
	id_modelos integer,
    id_job bigint,
	descripcion text,
	modelo varchar(125),
	fechaRegistro timestamp,
	created_at timestamp,
	likes integer,
	PRIMARY KEY (id,id_job)
);

CREATE TABLE marketplace.ts (
    id UUID PRIMARY KEY,
    id_job bigint NOT NULL,
    portal marketplace.portal_enum NOT NULL,
    idpagina TEXT NOT NULL,
    nombre TEXT,
    edad INT,
    ciudad TEXT,
    servicios text[],
    servicios_adicionales text[],
    scraped_at TIMESTAMP DEFAULT NOW(),
    descripcion TEXT,
	descripcion_tsv tsvector GENERATED ALWAYS AS (
    to_tsvector('spanish', coalesce(descripcion, ''))
) STORED,
    deleted_at TIMESTAMP DEFAULT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (portal, idpagina)
);

CREATE INDEX idx_ts_descripcion_fts_gin ON marketplace.ts USING GIN (descripcion_tsv);
CREATE INDEX ON marketplace.modelos (deleted_at);
CREATE INDEX ON scrap.modelos (id_job, id);
