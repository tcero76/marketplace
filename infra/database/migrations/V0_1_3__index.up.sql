ALTER TABLE marketplace.posts ADD COLUMN descripcion_tsv tsvector;

CREATE OR REPLACE FUNCTION scrap.actualizar_items_ultimos()
RETURNS void AS $$
BEGIN
  TRUNCATE TABLE marketplace.modelos ;
  INSERT INTO marketplace.modelos
  SELECT *
  FROM scrap.modelos
  WHERE id_job = (SELECT MAX(id_job) FROM scrap.modelos);
  TRUNCATE TABLE marketplace.posts ;
  INSERT INTO marketplace.posts
  SELECT *
  FROM scrap.posts
  WHERE id_job = (SELECT MAX(id_job) FROM scrap.posts);
  UPDATE marketplace.posts SET descripcion_tsv = to_tsvector('spanish', descripcion);
END;
$$ LANGUAGE plpgsql;

CREATE INDEX idx_marketplace_descripcion_tsv ON marketplace.posts USING GIN (descripcion_tsv);