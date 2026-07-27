-- RF-COL-01 · Colección por defecto «Want to climb» para los perfiles anteriores a 00.0003.0000.
--
-- Los perfiles creados a partir de esta versión reciben la suya en la misma transacción que el perfil,
-- al consumir UserRegistered. Este script cubre solo a los que ya existían.
--
-- Es reejecutable: el NOT EXISTS evita duplicados y ux_collections_profile_default es la red final.
-- La colección se almacena en inglés; la traducción a «Quiero subir» es cosa de la interfaz.

INSERT INTO collections (id, profile_id, kind, name, description, created_at_utc, updated_at_utc)
SELECT
    UUID(),
    p.id,
    'WantToClimb',
    'Want to climb',
    NULL,
    UTC_TIMESTAMP(6),
    UTC_TIMESTAMP(6)
FROM profiles p
WHERE NOT EXISTS (
    SELECT 1
    FROM collections c
    WHERE c.profile_id = p.id
      AND c.kind = 'WantToClimb'
);
