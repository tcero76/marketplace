CREATE OR REPLACE FUNCTION scrap.actualizar_items_ultimos()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_id_job bigint;
BEGIN
  SELECT MAX(id_job)
  INTO v_id_job
  FROM scrap.modelos;

  INSERT INTO marketplace.modelos (
    id,
    id_job,
    modelo,
    descripcion,
    deleted_at
  )
  SELECT
    id,
    v_id_job,
    modelo,
    descripcion,
    NULL
  FROM scrap.modelos
  WHERE id_job = v_id_job
  ON CONFLICT (id) DO UPDATE
  SET
    id_job      = EXCLUDED.id_job,
    modelo      = EXCLUDED.modelo,
    descripcion = EXCLUDED.descripcion,
    deleted_at  = NULL;

  UPDATE marketplace.modelos m
  SET deleted_at = now()
  WHERE deleted_at IS NULL
    AND NOT EXISTS (
      SELECT 1
      FROM scrap.modelos s
      WHERE s.id_job = v_id_job
        AND s.id = m.id
    );
END;
$$;