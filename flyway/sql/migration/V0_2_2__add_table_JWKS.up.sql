CREATE TABLE marketplace.jwk_keys (
    kid        TEXT PRIMARY KEY,
    kty        TEXT NOT NULL,
    alg        TEXT NOT NULL,
    use        TEXT NOT NULL,
    private_jwk JSONB NOT NULL,
    public_jwk  JSONB NOT NULL,
    created_at TIMESTAMP NOT NULL,
    expires_at TIMESTAMP
);
