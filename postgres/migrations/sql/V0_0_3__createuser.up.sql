CREATE TABLE marketplace.users (
    user_id uuid,
    nombre text,
    password text,
    video_code uuid,
    PRIMARY KEY (user_id)
);

insert into marketplace.users(user_id, nombre, password, video_code) values('123e4567-e89b-12d3-a456-426614174000', 'leonardo', 'Waves6_', '7a8f9b2c-d3e4-4f5a-9b6c-7d8e9f0a1b2c');