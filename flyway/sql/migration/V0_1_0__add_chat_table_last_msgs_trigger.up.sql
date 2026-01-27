CREATE SCHEMA IF NOT EXISTS chat;

CREATE TABLE IF NOT EXISTS chat.chats (
  id SERIAL PRIMARY KEY,
  user_origin UUID NOT NULL,
  user_destination UUID NOT NULL,
  is_public BOOLEAN NOT NULL DEFAULT FALSE,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE IF NOT EXISTS chat.last_chats (
  id SERIAL PRIMARY KEY,
  user_origin UUID NOT NULL,
  user_destination UUID NOT NULL,
  is_public BOOLEAN NOT NULL,
  message TEXT NOT NULL,
  created_at TIMESTAMPTZ NOT NULL
);
