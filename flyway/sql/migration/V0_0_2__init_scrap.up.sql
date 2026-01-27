--
-- Name: scrap; Type: SCHEMA; Schema: -; Owner: tcero
--

CREATE SCHEMA IF NOT EXISTS scrap;

ALTER SCHEMA scrap OWNER TO tcero;

CREATE TABLE IF NOT EXISTS scrap.explore (
	id integer,
	id_modelos integer,
    id_job bigint not null,
	modelo varchar(125),
	fechaRegistro timestamp,
	created_at timestamp,
	likes integer,
	PRIMARY KEY (id,id_job)
);

CREATE TABLE IF NOT EXISTS scrap.modelos(
    id serial,
    id_job bigint not null,
    modelo character varying(125),
    descripcion text,
    fecharegistro timestamp,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS scrap.posts (
    id serial,
    id_modelos integer,
    id_job bigint not null,
    descripcion text,
    modelo character varying(125),
    fecharegistro timestamp,
    created_at timestamp,
    likes integer,
    primary key (id)
);
