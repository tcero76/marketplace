CREATE TABLE IF NOT EXISTS marketplace.modelos(
	id integer,
    id_job double precision,
	modelo varchar(125) UNIQUE,
	descripcion text,
	created_at timestamp,
	PRIMARY KEY(id,id_job)
);

CREATE TABLE IF NOT EXISTS marketplace.posts(
	id integer,
	id_modelos integer,
    id_job double precision,
	descripcion text,
	modelo varchar(125),
	fechaRegistro timestamp,
	created_at timestamp,
	likes integer,
	PRIMARY KEY (id,id_job)
);