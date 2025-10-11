CREATE TABLE IF NOT EXISTS scrap.explore (
	id integer,
	id_modelos integer,
    id_job double precision,
	modelo varchar(125),
	fechaRegistro timestamp,
	created_at timestamp,
	likes integer,
	PRIMARY KEY (id,id_job)
);