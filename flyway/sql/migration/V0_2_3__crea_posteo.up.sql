CREATE TABLE marketplace.posteos (
  id SERIAL PRIMARY KEY,
  texto TEXT,
  menciones TEXT[]
);

CREATE INDEX idx_posteos_menciones ON marketplace.posteos USING GIN (menciones);