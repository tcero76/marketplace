CREATE TABLE marketplace.posteos (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id uuid,
  texto TEXT,
  menciones TEXT[]
  eliminado_en TIMESTAMPTZ
  creado_en TIMESTAMPTZ DEFAULT NOW()
);
CREATE INDEX idx_posteos_menciones ON marketplace.posteos USING GIN (menciones);