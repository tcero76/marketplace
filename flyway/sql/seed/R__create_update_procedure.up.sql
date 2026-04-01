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

CREATE OR REPLACE FUNCTION scrap.actualizar_ts_ultimos()
RETURNS void
LANGUAGE plpgsql
AS $$
DECLARE
  v_id_job bigint;
BEGIN
  SELECT MAX(id_job)
  INTO v_id_job
  FROM scrap.ts;
  INSERT INTO marketplace.ts (
    id,
    id_job,
    portal,
    idpagina,
    nombre,
    edad,
    ciudad,
    servicios,
    servicios_adicionales,
    scraped_at,
    descripcion
  )
  SELECT
    id,
    id_job,
    portal,
    idpagina,
    nombre,
    edad,
    ciudad,
    servicios,
    servicios_adicionales,
    scraped_at,
    descripcion
  FROM scrap.ts
  WHERE id_job = v_id_job
  ON CONFLICT (id) DO UPDATE
    SET
    id_job = EXCLUDED.id_job,
    portal = EXCLUDED.portal,
    idpagina = EXCLUDED.idpagina,
    nombre = EXCLUDED.nombre,
    edad = EXCLUDED.edad,
    ciudad = EXCLUDED.ciudad,
    servicios = EXCLUDED.servicios,
    servicios_adicionales = EXCLUDED.servicios_adicionales,
    scraped_at = EXCLUDED.scraped_at,
    descripcion = EXCLUDED.descripcion,
    deleted_at  = NULL;
  UPDATE marketplace.ts m
  SET deleted_at = now()
  WHERE deleted_at IS NULL
    AND NOT EXISTS (
      SELECT 1
      FROM scrap.ts s
      WHERE s.id_job = v_id_job
        AND s.id = m.id
    );
END;
$$;