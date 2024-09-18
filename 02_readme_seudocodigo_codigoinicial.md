# Procesamiento de Directorios y Archivos con Almacenamiento en PostgreSQL

Este proyecto tiene como objetivo procesar una estructura de directorios y archivos, validando la existencia de ciertos identificadores únicos (UWI) en una base de datos PostgreSQL y almacenando la información relevante en la misma. Además, se registran los errores cuando el UWI no se encuentra en la base de datos y se omiten los archivos innecesarios o temporales.

## Características principales

1. **Procesamiento de archivos**: Recorrer directorios y subdirectorios a partir de una ruta base especificada.
2. **Verificación del UWI**: Validar la existencia del UWI (Identificador Único de Pozo) en la base de datos PostgreSQL.
3. **Inserciones en lotes**: Procesar e insertar archivos en lotes de 500 registros para optimizar la interacción con la base de datos.
4. **Registro de errores**: Si no se encuentra el UWI en la base de datos, se registra el error y se omite la carpeta.
5. **Manejo de extensiones restringidas**: Omitir archivos con extensiones temporales o irrelevantes (como `.dcm`, `.tmp`, `.swp`, etc.).

---

## Seudo Código del Proyecto

```plaintext
1. Definir parámetros globales:
   - Definir el tamaño del lote (BATCH_SIZE) como 500.
   - Definir la ruta base (RUTA_BASE) desde la que se iniciará el recorrido de las carpetas.
   - Definir una lista de extensiones de archivo restringidas (ej. .dcm, .tmp, etc.).

2. Función conectar_base_datos:
   - Intentar establecer una conexión con la base de datos PostgreSQL.
   - Si la conexión falla, imprimir un mensaje de error y devolver None.
   - Si la conexión es exitosa, devolver el objeto de conexión.

3. Función insertar_en_base_de_datos_batch:
   - Recibir una conexión a la base de datos y un lote de registros para insertar.
   - Ejecutar una consulta SQL para insertar múltiples filas a la vez en la tabla `directorios`.
   - Si ocurre un error durante la inserción, hacer rollback para deshacer los cambios.

4. Función registrar_error:
   - Recibir la información sobre el UWI y la carpeta que generó un error.
   - Insertar un registro de error en la tabla `errores`.
   - Si ocurre un error, hacer rollback.

5. Función verificar_uwi:
   - Recibir un UWI (identificador único de pozo).
   - Ejecutar una consulta SQL para verificar si el UWI existe en la tabla `pozos_epis_sgc`.
   - Si el UWI existe, devolver True.
   - Si el UWI no existe, devolver False.

6. Función procesar_carpetas:
   - Conectarse a la base de datos.
   - Iniciar el procesamiento de las carpetas y archivos a partir de la ruta base.
   - Recorrer todas las carpetas y subcarpetas dentro de la ruta base.

7. Para cada carpeta:
   - Obtener el nombre de la carpeta.
   - Separar el nombre de la carpeta en `uwi_upi` (identificador único) y `nombre_pozo` (nombre del pozo).
   - Si la carpeta no sigue el formato esperado, imprimir un mensaje de error y saltarla.
   - Verificar si el UWI existe en la base de datos:
     - Si el UWI no existe, registrar un error y saltar la carpeta completa.
     - Si el UWI existe, continuar procesando las subcarpetas.

8. Para cada subcarpeta:
   - Tratar la subcarpeta como un tipo de producto.
   - Recorrer todos los archivos dentro de la subcarpeta.

9. Para cada archivo:
   - Obtener la ruta del archivo, nombre, tamaño y fechas de creación/modificación.
   - Verificar si el archivo tiene una extensión restringida:
     - Si el archivo tiene una extensión restringida, saltarlo.
   - Si el archivo es válido, agregar su información al lote (batch).
   - Si el lote alcanza el tamaño definido (500 registros):
     - Insertar el lote completo en la base de datos.
     - Limpiar el lote para seguir agregando nuevos archivos.

10. Al finalizar el procesamiento de archivos:
    - Si queda algún archivo en el lote que no alcanzó el tamaño mínimo (500):
      - Insertar los registros restantes en la base de datos.

11. Manejo de interrupciones:
    - Si el usuario interrumpe el procesamiento manualmente (ej. con un Ctrl+C), imprimir un mensaje y cerrar la conexión de manera segura.

12. Función principal (main):
    - Definir la ruta base de las carpetas a procesar.
    - Iniciar el procesamiento llamando a la función `procesar_carpetas`.
    - Imprimir un mensaje cuando el procesamiento haya terminado.
