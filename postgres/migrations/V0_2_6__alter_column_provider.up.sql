CREATE TYPE OAuthProvider AS ENUM ('google');

ALTER TABLE marketplace.users 
    ALTER COLUMN provider TYPE OAuthProvider USING provider::text::OAuthProvider;
