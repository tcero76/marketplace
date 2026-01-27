CREATE SCHEMA IF NOT EXISTS posts;

-- CREATE TABLE IF NOT EXISTS posts.services (
--     id              UUID PRIMARY KEY DEFAULT marketplace.uuid_generate_v4(),
--     provider_id     TEXT NOT NULL,
--     provider_nick   TEXT NOT NULL,
--     name            TEXT NOT NULL,
--     category        TEXT NOT NULL,
--     created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),

--     UNIQUE (provider_id, provider_nick)
-- );

CREATE TABLE IF NOT EXISTS posts.posts (
    id              UUID PRIMARY KEY DEFAULT marketplace.uuid_generate_v4(),
    content         TEXT NOT NULL,
    content_tsv     tsvector GENERATED ALWAYS AS (
        to_tsvector('spanish', content)
    ) STORED,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
    reply_to_id     UUID NULL,

    CONSTRAINT fk_reply_post
        FOREIGN KEY (reply_to_id)
        REFERENCES posts.posts(id)
        ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS posts.post_modelos (
    post_id     UUID NOT NULL,
    modelos_id  integer NOT NULL,

    PRIMARY KEY (post_id, modelos_id),

    CONSTRAINT fk_ps_post
        FOREIGN KEY (post_id)
        REFERENCES posts.posts(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_ps_service
        FOREIGN KEY (modelos_id)
        REFERENCES marketplace.modelos(id)
        ON DELETE CASCADE
);
