# Procesamiento en Paralelo de Archivos y Carpetas con PostgreSQL

Este proyecto está diseñado para procesar de manera eficiente una estructura de directorios y archivos, validando datos con una base de datos PostgreSQL y almacenando los resultados de forma eficiente. El programa se ejecuta en paralelo utilizando varios hilos para mejorar el rendimiento en la extracción y procesamiento de archivos.

## Características principales

1. **Procesamiento paralelo**: Se utilizan 8 hilos para procesar las carpetas de manera eficiente y reducir el tiempo de procesamiento.
2. **Verificación de UWI**: Valida la existencia de un UWI (Unique Well Identifier) en la base de datos antes de procesar una carpeta.
3. **Inserciones en lotes**: Los archivos se procesan en lotes de 500 registros, mejorando el rendimiento al interactuar con la base de datos.
4. **Registro de errores**: Si se encuentra un error (como un UWI inexistente), este se registra en la base de datos para su posterior revisión.
5. **Extensiones restringidas**: Se filtran archivos con extensiones temporales o innecesarias como `.dcm`, `.tmp`, `.swp`, etc.

---

## Seudo Código del Flujo de Trabajo

```plaintext
1. Definir parámetros globales:
   - Definir el tamaño del lote (BATCH_SIZE) como 500.
   - Definir el número de hilos (NUM_HILOS) como 8.
   - Definir las extensiones de archivo restringidas.

2. Función conectar_base_datos:
   - Intentar establecer una conexión con la base de datos.
   - Si la conexión falla, registrar el error.
   - Si la conexión es exitosa, devolver el objeto de conexión.

3. Función insertar_en_base_de_datos_batch:
   - Recibir un lote de registros para insertar en la tabla `directorios`.
   - Usar la función de inserción por lotes (`execute_batch`) para insertar los registros en la base de datos.
   - Si ocurre un error, deshacer la transacción (rollback).

4. Función registrar_error:
   - Recibir información sobre el UWI y la carpeta que generó el error.
   - Insertar el error en la tabla `errores` de la base de datos.
   - Deshacer la transacción si ocurre un error.

5. Función verificar_uwi:
   - Recibir un UWI y verificar si está presente en la tabla `pozos_epis_sgc`.
   - Devolver true si el UWI existe, de lo contrario devolver false.

6. Función procesar_archivos_subcarpeta:
   - Recibir la información del UWI y la subcarpeta a procesar.
   - Inicializar una lista para almacenar los archivos (lote).
   - Recorrer todos los archivos dentro de la subcarpeta.
     - Para cada archivo:
       - Si la extensión del archivo está en la lista de restringidos, omitir el archivo.
       - Obtener el nombre, tamaño, y fechas de creación/modificación del archivo.
       - Agregar la información del archivo a la lista (lote).
       - Si el tamaño del lote alcanza 500 registros, insertar en la base de datos.
   - Al final, si quedan registros en el lote, insertarlos en la base de datos.

7. Función procesar_carpeta:
   - Recibir la carpeta raíz a procesar.
   - Extraer el UWI y el nombre del pozo de la carpeta.
   - Verificar si el UWI existe en la base de datos:
     - Si no existe, registrar un error y saltar la carpeta.
     - Si existe, proceder a procesar las subcarpetas.
   - Recorrer todas las subcarpetas (productos) dentro de la carpeta raíz.
     - Para cada subcarpeta:
       - Enviar la subcarpeta a procesar de forma paralela.

8. Función procesar_carpetas_paralelo:
   - Establecer una conexión con la base de datos.
   - Obtener todas las carpetas raíz dentro de la ruta base.
   - Procesar cada carpeta raíz de forma paralela utilizando un pool de 8 hilos.
   - Asegurarse de cerrar la conexión a la base de datos al finalizar.

9. Función principal:
   - Definir la ruta base.
   - Iniciar el procesamiento llamando a `procesar_carpetas_paralelo`.
