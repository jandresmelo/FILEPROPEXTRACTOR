
-- Base de datos Lito_Virtual
---- Generar base de datos "lito_virtual"

--- Crear extension postgis
CREATE EXTENSION postgis; -- 

--- Verificar la instalación de PostGIS
SELECT PostGIS_Version();

-- Cargar shapefile desde la linea de comando cmd de windows
DROP TABLE public.pozos_epis_sgc;

---- C:\Program Files\PostgreSQL\XX\bin\
---- shp2pgsql" -I "D:\BUSQUEDA\POZOS_EPIS_SGC\POZOS_EPIS_SGC_2024_09_12.shp" pozos_epis_sgc | psql -U postgres -h localhost -d lito_virtual

--- Verificación 
SELECT * FROM pozos_epis_sgc LIMIT 10;

SELECT COUNT(*)
FROM public.pozos_epis_sgc; -- 25.682 Registros.

---- Buscar y eliminar uwi repetidos

SELECT uwi, COUNT(*)
FROM public.pozos_epis_sgc
GROUP BY uwi
HAVING COUNT(*) > 1;


SELECT a.*
FROM public.pozos_epis_sgc a
JOIN (
    SELECT uwi, MIN(gid) AS gid_min
    FROM public.pozos_epis_sgc
    GROUP BY uwi
) b
ON a.uwi = b.uwi
WHERE a.gid > b.gid_min;

DELETE FROM public.pozos_epis_sgc a
USING (
    SELECT gid, uwi, creat_date
    FROM (
        SELECT gid, uwi, creat_date,
               ROW_NUMBER() OVER (PARTITION BY uwi ORDER BY creat_date DESC) AS fila
        FROM public.pozos_epis_sgc
    ) AS subquery
    WHERE subquery.fila > 1  -- Mantiene el registro más reciente (fila = 1)
) b
WHERE a.gid = b.gid
returning *;

--- asignar la variable uwi como llave

ALTER TABLE public.pozos_epis_sgc
ADD CONSTRAINT uwi_unique UNIQUE (uwi);


-- Crear tabla directorios
DROP TABLE public.directorios;

CREATE TABLE public.directorios (
   	id SERIAL PRIMARY KEY,
    uwi_upi VARCHAR(50) NOT NULL,
    nombre_pozo VARCHAR(100) NULL,
    tipo_producto VARCHAR(100) NULL,
    ruta_archivo TEXT NOT NULL,
    nombre_archivo VARCHAR(255) NOT NULL,
    tamano_archivo BIGINT NULL,
    fecha_creacion TIMESTAMP NULL,
    fecha_modificacion TIMESTAMP NULL,
    extension_archivo VARCHAR(10) NOT NULL,
    
    -- Campos adicionales que se llenarán a través de un UPDATE
    numero_paginas INTEGER NULL,       -- Para archivos PDF y DOCX
    ancho_resolucion INTEGER NULL,     -- Para imágenes (JPG, TIFF, PSD)
    alto_resolucion INTEGER NULL,      -- Para imágenes (JPG, TIFF, PSD)
    dpi INTEGER NULL,                  -- Resolución de las imágenes
    numero_palabras INTEGER NULL,      -- Para archivos DOCX
    numero_columnas INTEGER NULL,      -- Para archivos XLSX (Excel)
    numero_filas INTEGER NULL,         -- Para archivos XLSX (Excel)
    
    -- Metadatos opcionales
    titulo VARCHAR(255) NULL,          -- Título de los archivos PDF o DOCX
    autor VARCHAR(255) NULL            -- Autor de los archivos PDF o DOCX
);

CREATE INDEX idx_uwi_upi ON public.directorios(uwi_upi);
CREATE INDEX idx_extension_archivo ON public.directorios(extension_archivo);

TRUNCATE TABLE directorios;

select *
from directorios;

---- consulta

select distinct 
extension_archivo
from directorios;