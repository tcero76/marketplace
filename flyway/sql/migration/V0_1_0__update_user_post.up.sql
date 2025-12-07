CREATE TYPE marketplace.relaciones AS ENUM ('CLICK');

CREATE TABLE marketplace.users_model(
    id serial, 
    id_user uuid, 
    model_nick varchar(255),
    magnitud integer,
    tipo marketplace.relaciones,
    PRIMARY KEY (id)
);


