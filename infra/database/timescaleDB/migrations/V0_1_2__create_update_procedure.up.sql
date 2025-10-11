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
END;
$$ LANGUAGE plpgsql;