ALTER TABLE marketplace.posteos ADD COLUMN creado_en TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE marketplace.posteos ADD COLUMN eliminado_en TIMESTAMPTZ;
ALTER TABLE marketplace.posteos ADD COLUMN user_id uuid;
ALTER TABLE marketplace.posteos DROP COLUMN id;
ALTER TABLE marketplace.posteos ADD COLUMN id uuid PRIMARY KEY DEFAULT gen_random_uuid();