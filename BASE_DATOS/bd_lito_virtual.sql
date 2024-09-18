--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 16.2

-- Started on 2024-09-12 15:00:20

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 2 (class 3079 OID 253454)
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- TOC entry 4268 (class 0 OID 0)
-- Dependencies: 2
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry and geography spatial types and functions';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 223 (class 1259 OID 254617)
-- Name: directorios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.directorios (
    id integer NOT NULL,
    uwi_upi character varying(50) NOT NULL,
    nombre_pozo character varying(100),
    tipo_producto character varying(100),
    otros character varying(255),
    ruta_archivo text,
    nombre_archivo character varying(255),
    extension_archivo character varying(10),
    tamano_archivo bigint,
    fecha_creacion timestamp without time zone,
    fecha_captura timestamp without time zone,
    fecha_modificacion timestamp without time zone,
    nombre_programa character varying(255),
    autor character varying(255),
    propietario character varying(255),
    nombre_equipo character varying(255),
    guardado_por character varying(255),
    numero_revision integer,
    numero_version integer,
    organizacion character varying(255),
    administrador character varying(255),
    tipo_elemento character varying(255),
    ancho_resolucion integer,
    alto_resolucion integer
);


ALTER TABLE public.directorios OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 254616)
-- Name: directorios_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.directorios_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directorios_id_seq OWNER TO postgres;

--
-- TOC entry 4269 (class 0 OID 0)
-- Dependencies: 222
-- Name: directorios_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.directorios_id_seq OWNED BY public.directorios.id;


--
-- TOC entry 221 (class 1259 OID 254588)
-- Name: pozos_epis_sgc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pozos_epis_sgc (
    gid integer NOT NULL,
    uwi character varying(254),
    well_name character varying(254),
    well_count character varying(254),
    departamen character varying(254),
    well_cou_1 character varying(254),
    well_tvd numeric,
    well_kb_el numeric,
    rotary_ele numeric,
    well_drill numeric,
    well_groun numeric,
    field_abre character varying(254),
    geologic_p character varying(254),
    contrato character varying(254),
    well_longi numeric,
    well_latit numeric,
    well_x_coo numeric,
    well_y_coo numeric,
    well_x_c_1 numeric,
    well_y_c_1 numeric,
    well_x_dep numeric,
    well_y_dep numeric,
    datum character varying(254),
    well_spud_ date,
    coord_qual character varying(254),
    documento character varying(254),
    comment_ character varying(254),
    well_compl date,
    well_cla_1 character varying(254),
    well_sta_1 character varying(254),
    welltype character varying(254),
    fecha_actu date,
    entitlemen character varying(254),
    actualizad character varying(254),
    creat_date date,
    operator_w character varying(254),
    company_co character varying(254),
    carga_sgc character varying(10),
    cont_epis character varying(150),
    relacionad integer,
    clas_final character varying(100),
    formacion_ character varying(100),
    formacion1 character varying(100),
    estructura character varying(100),
    well_alias character varying(250),
    visible character varying(2),
    geom public.geometry(PointZM)
);


ALTER TABLE public.pozos_epis_sgc OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 254587)
-- Name: pozos_epis_sgc_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pozos_epis_sgc_gid_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pozos_epis_sgc_gid_seq OWNER TO postgres;

--
-- TOC entry 4270 (class 0 OID 0)
-- Dependencies: 220
-- Name: pozos_epis_sgc_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pozos_epis_sgc_gid_seq OWNED BY public.pozos_epis_sgc.gid;


--
-- TOC entry 4103 (class 2604 OID 254620)
-- Name: directorios id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directorios ALTER COLUMN id SET DEFAULT nextval('public.directorios_id_seq'::regclass);


--
-- TOC entry 4102 (class 2604 OID 254591)
-- Name: pozos_epis_sgc gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pozos_epis_sgc ALTER COLUMN gid SET DEFAULT nextval('public.pozos_epis_sgc_gid_seq'::regclass);


--
-- TOC entry 4113 (class 2606 OID 254624)
-- Name: directorios directorios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directorios
    ADD CONSTRAINT directorios_pkey PRIMARY KEY (id);


--
-- TOC entry 4109 (class 2606 OID 254595)
-- Name: pozos_epis_sgc pozos_epis_sgc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pozos_epis_sgc
    ADD CONSTRAINT pozos_epis_sgc_pkey PRIMARY KEY (gid);


--
-- TOC entry 4111 (class 2606 OID 254615)
-- Name: pozos_epis_sgc uwi_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pozos_epis_sgc
    ADD CONSTRAINT uwi_unique UNIQUE (uwi);


--
-- TOC entry 4114 (class 1259 OID 254630)
-- Name: idx_directorios_uwi_upi; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_directorios_uwi_upi ON public.directorios USING btree (uwi_upi);


--
-- TOC entry 4107 (class 1259 OID 254596)
-- Name: pozos_epis_sgc_geom_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX pozos_epis_sgc_geom_idx ON public.pozos_epis_sgc USING gist (geom);


--
-- TOC entry 4115 (class 2606 OID 254625)
-- Name: directorios fk_uwi_upi; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.directorios
    ADD CONSTRAINT fk_uwi_upi FOREIGN KEY (uwi_upi) REFERENCES public.pozos_epis_sgc(uwi) ON UPDATE CASCADE ON DELETE CASCADE;


-- Completed on 2024-09-12 15:00:20

--
-- PostgreSQL database dump complete
--

