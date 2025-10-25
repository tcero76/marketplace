CREATE TABLE IF NOT EXISTS scrap.modelos(
    id serial,
    id_job double precision  not null,
    modelo character varying(125),
    descripcion text,
    created_at timestamp,
    primary key (id)
);

CREATE TABLE IF NOT EXISTS scrap.posts (
    id serial,
    id_modelos integer,
    id_job double precision not null,
    descripcion text,
    modelo character varying(125),
    fecharegistro timestamp,
    created_at timestamp,
    likes integer,
    primary key (id)
);

DROP TABLE scrap.items;