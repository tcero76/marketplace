
CREATE TYPE marketplace.relaciones AS ENUM ('CLICK');

CREATE TABLE marketplace.users_posts(
    id serial, 
    id_user integer, 
    id_posts integer,
    tipo marketplace.relaciones,
    PRIMARY KEY (id));
