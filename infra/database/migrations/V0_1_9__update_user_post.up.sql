DROP TABLE marketplace.users_posts;

CREATE TABLE marketplace.users_model(
    id serial, 
    id_user uuid, 
    model_nick varchar(255),
    magnitud integer,
    tipo marketplace.relaciones,
    PRIMARY KEY (id)
);

INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('123e4567-e89b-12d3-a456-426614174000','11DulceDahian11', 'CLICK',3);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('123e4567-e89b-12d3-a456-426614174000','milenkuaz', 'CLICK',9);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('123e4567-e89b-12d3-a456-426614174000','FlaviaTantrasensual', 'CLICK',5);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('123e4567-e89b-12d3-a456-426614174000','Stefiii13', 'CLICK',7);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('123e4567-e89b-12d3-a456-426614174000','Gabrielaaa_', 'CLICK',9);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('550e8400-e29b-41d4-a716-446655440000','11DulceDahian11', 'CLICK',0);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('550e8400-e29b-41d4-a716-446655440000','milenkuaz', 'CLICK',3);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('550e8400-e29b-41d4-a716-446655440000','FlaviaTantrasensual', 'CLICK',5);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('550e8400-e29b-41d4-a716-446655440000','Stefiii13', 'CLICK',7);
INSERT INTO marketplace.users_model (id_user, model_nick, tipo,magnitud) VALUES ('550e8400-e29b-41d4-a716-446655440000','Gabrielaaa_', 'CLICK',9);


