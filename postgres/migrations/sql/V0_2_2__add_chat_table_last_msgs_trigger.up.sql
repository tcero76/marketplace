CREATE SCHEMA chat;

CREATE TABLE chat.chats (
  id SERIAL PRIMARY KEY,
  user_origin UUID NOT NULL,
  user_destination UUID NOT NULL,
  is_public BOOLEAN NOT NULL DEFAULT FALSE,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE chat.last_chats (
  id SERIAL PRIMARY KEY,
  user_origin UUID NOT NULL,
  user_destination UUID NOT NULL,
  is_public BOOLEAN NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);
