# FileProp Extractor: Sistema de Extracción y Gestión de Propiedades de Archivos para Optimización de Consultas en Base de Datos

## Objetivo General
Desarrollar un sistema automatizado para la extracción, transformación y almacenamiento de propiedades de archivos desde carpetas y archivos estructurados, con el fin de construir una base de datos optimizada que permita la gestión eficiente y la mejora en las consultas de la información almacenada.

### Objetivos Específicos
A. Extraer y transformar datos automáticamente desde archivos y carpetas almacenados en un servidor, capturando propiedades clave como el nombre, tamaño, tipo de archivo, fechas de creación y modificación, y organizar esta información en una estructura coherente.  
B. Verificar la integridad de los datos mediante la validación de identificadores únicos, registrando errores y excepciones de manera eficiente en una base de datos separada para mantener la calidad de los datos.  
C. Optimizar la consulta de los datos almacenados en la base de datos PostgreSQL, mediante la creación de índices y estructuras de datos adecuadas, permitiendo consultas rápidas y eficaces de la información relevante.

## Justificación
En proyectos que manejan grandes volúmenes de datos y múltiples tipos de productos almacenados en archivos y carpetas, identificar y gestionar esta información de manera eficiente se convierte en un desafío. La variedad de tipos de productos y la complejidad de las estructuras de carpetas dificultan el acceso rápido y organizado a los datos relevantes. Además, es crucial garantizar la integridad de los datos y validar que la estructura de carpetas sigue los lineamientos del proyecto.

Este sistema de extracción y gestión de propiedades de archivos aborda estos problemas al automatizar el proceso de extracción de datos, facilitando la identificación precisa de los archivos almacenados, su tipo de producto y otras propiedades clave, como el nombre del pozo y el UWI. La incorporación de mecanismos de validación garantiza que los datos almacenados mantengan su integridad, mientras que el registro de errores asegura el seguimiento de cualquier discrepancia en la estructura.

Finalmente, la optimización de las consultas mediante una base de datos bien estructurada e indexada permite acceder rápidamente a la información, agilizando las búsquedas y mejorando la toma de decisiones. De esta manera, el proyecto no solo centraliza la información, sino que también mejora la eficiencia operativa y el control de calidad en la gestión de archivos y datos relacionados con pozos petroleros.

## Metodología
El desarrollo del sistema de extracción, transformación y carga (ETL) de propiedades de archivos y optimización de la base de datos sigue estas fases:

1. **Fase de Extracción de Datos**: Basada en el modelo de procesos ETL, esta fase se apoya en la exploración de sistemas de archivos distribuidos para recuperar propiedades clave de archivos, como nombre, tamaño y fechas asociadas.
2. **Fase de Gestión de Calidad y Normalización de Datos**: Se verifica la integridad de los datos mediante la validación de los UWI y otros identificadores, registrando errores y excepciones en una base de datos dedicada.
3. **Fase de Carga y Optimización**: La información transformada se carga en una base de datos PostgreSQL, aplicando técnicas de indexación y normalización para mejorar la eficiencia en la consulta de grandes volúmenes de datos.
4. **Fase de Control de Calidad y Mejora Continua**: Se monitorizan los errores y se realizan validaciones periódicas de la integridad de los datos, implementando mejoras en los algoritmos de extracción y carga.

## Resultados

### 5.1. Base de Datos del Sistema
El sistema utiliza una base de datos PostgreSQL complementada con PostGIS, lo que permite gestionar información espacial relacionada con los pozos petroleros. Las tablas clave incluyen:
- **Tabla pozos_epis_sgc**: Almacena información espacial y geoespacial.
- **Tabla recepción**: Contiene metadatos sobre la recepción .
- **Tabla directorios**: Captura los resultados del recorrido de archivos y carpetas, almacenando propiedades clave.
- **Tabla errores**: Registra carpetas o archivos que no cumplen con la estructura esperada.

### 5.2. Script Generado
Este sistema se implementa mediante un script que automatiza la extracción de datos desde directorios de red, gestionando los archivos en una base de datos PostgreSQL. Las áreas clave son:
- **Instalación de Librerías**: 
  - `pip install pillow psycopg2 exifread`: Instala las librerías necesarias para manipular imágenes, interactuar con PostgreSQL y extraer metadatos EXIF.
  - `pip install pywin32`: Facilita la interacción con las API de Windows para operaciones como el mapeo de red.
  - `pip install psycopg2`: Instala el adaptador para conectarse a bases de datos PostgreSQL.
  
- **Mapeo de Red y Acceso a Carpetas**: Verifica si una carpeta de red es accesible y cuenta las carpetas en la primera posición para identificar proyectos.
  
- **Descripción de Funciones del Código de Extracción**: 
  - **`conectar_base_datos()`**: Se conecta a PostgreSQL.
  - **`insertar_en_base_de_datos_batch(conn, batch)`**: Inserta filas en la tabla `directorios` en lotes.
  - **`registrar_error(conn, uwi_upi, nombre_pozo, ruta_archivo)`**: Registra errores en la tabla `errores`.
  - **`verificar_uwi(conn, uwi_upi)`**: Verifica si el UWI está en la tabla `pozos_epis_sgc`.
  - **`procesar_carpetas(carpeta_base)`**: Recorrerá los directorios de la red, procesando archivos y subcarpetas. Se excluyen archivos con extensiones temporales o `.dcm`, y se insertan datos válidos en lotes.

## Instalación

1. Clonar el repositorio:
   ```bash
   git clone https://github.com/tu-usuario/FilePropExtractor.git
