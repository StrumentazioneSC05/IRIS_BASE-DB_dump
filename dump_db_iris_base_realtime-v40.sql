--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO postgres;

--
-- Name: SCHEMA realtime; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA realtime IS 'Raccolta dati in tempo reale';


--
-- Name: cardinal2degree(text); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.cardinal2degree(text) RETURNS real
    LANGUAGE sql
    AS $_$
SELECT CASE
        WHEN $1 = 'N' THEN 0
	WHEN $1 = 'NNE' THEN 22.5
	WHEN $1 = 'NE' THEN 45
	WHEN $1 = 'ENE' THEN 67.5
	WHEN $1 = 'E' THEN 90
	WHEN $1 = 'ESE' THEN 112.5
	WHEN $1 = 'SE' THEN 135
	WHEN $1 = 'SSE' THEN 157.5
	WHEN $1 = 'S' THEN 180
	WHEN $1 = 'SSW' THEN 202.5
	WHEN $1 = 'SW' THEN 225
	WHEN $1 = 'WSW' THEN 247.5
	WHEN $1 = 'W' THEN 270
	WHEN $1 = 'WNW' THEN 292.5
	WHEN $1 = 'NW' THEN 315
	WHEN $1 = 'NNW' THEN 337.5
        ELSE NULL::real
        END
$_$;


ALTER FUNCTION realtime.cardinal2degree(text) OWNER TO postgres;

--
-- Name: degree2cardinal(real); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.degree2cardinal(real) RETURNS text
    LANGUAGE sql
    AS $_$
SELECT CASE
        WHEN $1 BETWEEN  348.75 AND 360  THEN 'N'::text
	WHEN $1 BETWEEN  0 AND 11.25  THEN 'N'::text
	WHEN $1 BETWEEN  11.25 AND 33.75  THEN 'NNE'::text
	WHEN $1 BETWEEN  33.75 AND 56.25  THEN 'NE'::text
	WHEN $1 BETWEEN  56.25 AND 78.75   THEN 'ENE'::text
	WHEN $1 BETWEEN  78.75 AND 101.25  THEN 'E'::text
	WHEN $1 BETWEEN  101.25 AND 123.75  THEN 'ESE'::text
	WHEN $1 BETWEEN  123.75 AND 146.25  THEN 'SE'::text
	WHEN $1 BETWEEN  146.25 AND 168.75   THEN 'SSE'::text
	WHEN $1 BETWEEN  168.75 AND 191.25  THEN 'S'::text
	WHEN $1 BETWEEN  191.25 AND 213.75   THEN 'SSW'::text
	WHEN $1 BETWEEN  213.75 AND 236.25   THEN 'SW'::text
	WHEN $1 BETWEEN  236.25 AND 258.75   THEN 'WSW'::text
	WHEN $1 BETWEEN  258.75 AND 281.25   THEN 'W'::text
	WHEN $1 BETWEEN  281.25 AND 303.75   THEN 'WNW'::text
	WHEN $1 BETWEEN  303.75 AND 326.25   THEN 'NW'::text
	WHEN $1 BETWEEN  326.25 AND 348.75   THEN 'NNW'::text
            ELSE NULL::text
        END
$_$;


ALTER FUNCTION realtime.degree2cardinal(real) OWNER TO postgres;

--
-- Name: radian2cardinal(real); Type: FUNCTION; Schema: realtime; Owner: postgres
--

CREATE FUNCTION realtime.radian2cardinal(real) RETURNS text
    LANGUAGE plpgsql
    AS $_$
declare
    degree numeric(5,2) := $1 / (2*pi()) *360;
    card text;
BEGIN
SELECT into card
    CASE
        WHEN degree BETWEEN  348.75 AND 360  THEN 'N'::text
	WHEN degree BETWEEN  0 AND 11.25  THEN 'N'::text
	WHEN degree BETWEEN  11.25 AND 33.75  THEN 'NNE'::text
	WHEN degree BETWEEN  33.75 AND 56.25  THEN 'NE'::text
	WHEN degree BETWEEN  56.25 AND 78.75   THEN 'ENE'::text
	WHEN degree BETWEEN  78.75 AND 101.25  THEN 'E'::text
	WHEN degree BETWEEN  101.25 AND 123.75  THEN 'ESE'::text
	WHEN degree BETWEEN  123.75 AND 146.25  THEN 'SE'::text
	WHEN degree BETWEEN  146.25 AND 168.75   THEN 'SSE'::text
	WHEN degree BETWEEN  168.75 AND 191.25  THEN 'S'::text
	WHEN degree BETWEEN  191.25 AND 213.75   THEN 'SSW'::text
	WHEN degree BETWEEN  213.75 AND 236.25   THEN 'SW'::text
	WHEN degree BETWEEN  236.25 AND 258.75   THEN 'WSW'::text
	WHEN degree BETWEEN  258.75 AND 281.25   THEN 'W'::text
	WHEN degree BETWEEN  281.25 AND 303.75   THEN 'WNW'::text
	WHEN degree BETWEEN  303.75 AND 326.25   THEN 'NW'::text
	WHEN degree BETWEEN  326.25 AND 348.75   THEN 'NNW'::text
            ELSE NULL::text
        END;
return card;
END;
$_$;


ALTER FUNCTION realtime.radian2cardinal(real) OWNER TO postgres;

--
-- Name: report_evento_insert(); Type: FUNCTION; Schema: realtime; Owner: radar
--

CREATE FUNCTION realtime.report_evento_insert() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
 UPDATE realtime.report_evento set the_geom = ST_SetSRID(ST_MakePoint(lon, lat), 4326) where gid = NEW.gid;
 RETURN NEW;
END;
$$;


ALTER FUNCTION realtime.report_evento_insert() OWNER TO radar;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: anomalie; Type: TABLE; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE TABLE realtime.anomalie (
    data_inizio timestamp without time zone NOT NULL,
    data_fine timestamp without time zone,
    id_sistema integer NOT NULL,
    autore character varying(50) NOT NULL,
    data_agg timestamp without time zone DEFAULT now() NOT NULL,
    descrizione character varying(250) NOT NULL,
    severita smallint DEFAULT 1 NOT NULL
);


ALTER TABLE realtime.anomalie OWNER TO postgres;

--
-- Name: TABLE anomalie; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON TABLE realtime.anomalie IS 'Tabella con le anomalie ai sistemi';


--
-- Name: COLUMN anomalie.autore; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON COLUMN realtime.anomalie.autore IS 'Autore che ha inserito l''anomalia';


--
-- Name: COLUMN anomalie.severita; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON COLUMN realtime.anomalie.severita IS 'grado di severita dell''anomalia: 1-lieve; 2-moderata; 3-grave anomalia.
Aggiungere ''1'' davanti per eventi senza impatti operativi';


--
-- Name: bis_stato; Type: TABLE; Schema: realtime; Owner: idro; Tablespace: 
--

CREATE TABLE realtime.bis_stato (
    gid integer NOT NULL,
    codice character varying(9),
    denominazione character varying(80),
    the_geom public.geometry(Point,23032),
    ultimovalore numeric(12,3),
    data date,
    dmv_base numeric(6,2),
    dmv_deroga numeric(6,2),
    stato smallint,
    soglia_allarme numeric(6,2),
    stato_allarme smallint
);


ALTER TABLE realtime.bis_stato OWNER TO idro;

--
-- Name: TABLE bis_stato; Type: COMMENT; Schema: realtime; Owner: idro
--

COMMENT ON TABLE realtime.bis_stato IS 'tabella creata tramite trigger su inserimento dei dati in BIS per valutare lo stato delle singole stazioni_bis in base al valore di portata e il DMV';


--
-- Name: COLUMN bis_stato.stato; Type: COMMENT; Schema: realtime; Owner: idro
--

COMMENT ON COLUMN realtime.bis_stato.stato IS '0-Q_media > DMV base; 1-Q_media < DMV base; 2-Q_media < DMV deroga; 3-soglie mancanti; -1-dati ultimo giorno mancanti; -2-portata<-999';


--
-- Name: COLUMN bis_stato.stato_allarme; Type: COMMENT; Schema: realtime; Owner: idro
--

COMMENT ON COLUMN realtime.bis_stato.stato_allarme IS '0-nessun superamento soglia_allarme; 1-superamento soglia_allarme';


--
-- Name: meteo_real_time; Type: TABLE; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE TABLE realtime.meteo_real_time (
    id_rete_monit character varying(2) NOT NULL,
    codice_istat_comune character varying(6) NOT NULL,
    progr_punto_com numeric(3,0) NOT NULL,
    data date NOT NULL,
    ora character varying(5) NOT NULL,
    id_parametro character varying(8) NOT NULL,
    id_aggregazione numeric(3,0) NOT NULL,
    valore_originale numeric(12,3),
    valore_validato numeric(12,3),
    tipologia_validaz character varying(3),
    flag_validaz_autom character varying(1),
    flag_gestore_sistema character varying(1),
    data_agg timestamp without time zone
);


ALTER TABLE realtime.meteo_real_time OWNER TO postgres;

--
-- Name: TABLE meteo_real_time; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON TABLE realtime.meteo_real_time IS 'Dati meteo realtime';


--
-- Name: report_evento; Type: TABLE; Schema: realtime; Owner: radar_rw; Tablespace: 
--

CREATE TABLE realtime.report_evento (
    gid integer NOT NULL,
    dataevento timestamp without time zone NOT NULL,
    localita character varying(255),
    lat numeric(11,4),
    lon numeric(11,4),
    raggio integer,
    tipo_evento integer,
    link_news character varying(255),
    the_geom public.geometry(Point,4326),
    autore character varying(255),
    data_agg timestamp without time zone DEFAULT now(),
    note character varying(1024)
);


ALTER TABLE realtime.report_evento OWNER TO radar_rw;

--
-- Name: TABLE report_evento; Type: COMMENT; Schema: realtime; Owner: radar_rw
--

COMMENT ON TABLE realtime.report_evento IS 'Tabella con i report relativi ad eventi documentati';


--
-- Name: report_evento_gid_seq; Type: SEQUENCE; Schema: realtime; Owner: radar_rw
--

CREATE SEQUENCE realtime.report_evento_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE realtime.report_evento_gid_seq OWNER TO radar_rw;

--
-- Name: report_evento_gid_seq; Type: SEQUENCE OWNED BY; Schema: realtime; Owner: radar_rw
--

ALTER SEQUENCE realtime.report_evento_gid_seq OWNED BY realtime.report_evento.gid;


--
-- Name: v_anomalie; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_anomalie AS
 SELECT anomalie_sistemi.id_sistema,
    anomalie_sistemi.descrizione AS sistema,
    anomalie.data_inizio,
    anomalie.data_fine,
    anomalie.descrizione,
    anomalie.autore,
    anomalie.data_agg,
    anomalie.severita,
    anomalie_severita.severita_descr,
    anomalie_severita.impatto_operativo,
    anomalie_severita.severita_colore
   FROM config.anomalie_sistemi,
    realtime.anomalie,
    config.anomalie_severita
  WHERE ((anomalie.id_sistema = anomalie_sistemi.id_sistema) AND (anomalie_severita.severita_idx = anomalie.severita))
  ORDER BY anomalie.data_inizio DESC;


ALTER TABLE realtime.v_anomalie OWNER TO postgres;

--
-- Name: VIEW v_anomalie; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_anomalie IS 'Anomalie riscontrate nelle apparecchiature radar - per WebGIS';


--
-- Name: v_last_idro; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_last_idro AS
 SELECT b.codice_istat_comune,
    b.progr_punto_com,
    b.denominazione,
    b.tipo_staz,
    b.gid,
    (b.the_geom)::public.geometry(Point,23032) AS the_geom,
    (foo.ultimovalore)::numeric(5,2) AS ultimovalore,
    foo.timeultimovalore,
    foo2.ultimovalore AS portata,
    foo.id_parametro,
        CASE
            WHEN (foo.ultimovalore >= c.codice3) THEN 3
            WHEN (foo.ultimovalore >= c.codice2) THEN 2
            WHEN (foo.ultimovalore >= c.codice1) THEN 1
            WHEN (c.codice1 IS NULL) THEN (-1)
            ELSE 0
        END AS stato
   FROM (((dati_di_base.rete_meteoidrografica b
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            meteo_real_time.id_parametro,
            to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) AS timeultimovalore,
            meteo_real_time.valore_originale AS ultimovalore
           FROM realtime.meteo_real_time
          WHERE ((((meteo_real_time.id_parametro)::text ~~ 'IDRO%'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND ((meteo_real_time.tipologia_validaz IS NULL) OR ((meteo_real_time.tipologia_validaz)::text !~~ 'A%'::text)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            meteo_real_time.id_parametro,
            to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) AS timeultimovalore,
            round(meteo_real_time.valore_validato) AS ultimovalore
           FROM realtime.meteo_real_time
          WHERE ((((meteo_real_time.id_parametro)::text ~~ 'PORTATA'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND ((meteo_real_time.tipologia_validaz IS NULL) OR ((meteo_real_time.tipologia_validaz)::text !~~ 'A%'::text)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo2 ON ((((foo2.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo2.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN dati_di_base.soglie_idrometriche c ON (((((c.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (c.progr_punto_com = b.progr_punto_com)) AND ((foo.id_parametro)::text = (c.id_parametro)::text))))
  WHERE (((b.tipo_staz)::text ~~ '%I%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_idro OWNER TO postgres;

--
-- Name: VIEW v_last_idro; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_last_idro IS 'ultimo dato registrato di livello IDRO per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_nivo; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_last_nivo AS
 SELECT b.codice_istat_comune,
    b.progr_punto_com,
    b.denominazione,
    b.quota_int,
    b.tipo_staz,
    b.gid,
    (b.the_geom)::public.geometry(Point,23032) AS the_geom,
    foo.ultimovalore,
    foo.timeultimovalore,
    'meteoidro'::text AS tipo_rete
   FROM (dati_di_base.rete_meteoidrografica b
     LEFT JOIN ( SELECT DISTINCT ON (a.codice_istat_comune, a.progr_punto_com) a.codice_istat_comune,
            a.progr_punto_com,
            a.id_parametro,
            (to_timestamp((a.data || (a.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text))::timestamp without time zone AS timeultimovalore,
            (((a.valore_originale * (100)::numeric) - (b_1.valore_originale * (100)::numeric)))::integer AS ultimovalore
           FROM realtime.meteo_real_time a,
            realtime.meteo_real_time b_1
          WHERE (((((((a.id_parametro)::text = 'NIVO'::text) AND (to_timestamp((a.data || (a.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND (to_timestamp((b_1.data || (b_1.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) = (((('now'::text)::date || ' '::text) || '08:00'::text))::timestamp without time zone)) AND ((a.codice_istat_comune)::text = (b_1.codice_istat_comune)::text)) AND (a.progr_punto_com = b_1.progr_punto_com)) AND ((b_1.id_parametro)::text = 'NIVO'::text))
          ORDER BY a.codice_istat_comune, a.progr_punto_com, to_timestamp((a.data || (a.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
  WHERE (((b.tipo_staz)::text ~~ '%N%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_nivo OWNER TO postgres;

--
-- Name: VIEW v_last_nivo; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_last_nivo IS 'ultimo dato registrato di neve a cui viene sottratto il dato delle 8 del mattino dello stesso giorno per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_pluv; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_last_pluv AS
 SELECT b.codice_istat_comune,
    b.progr_punto_com,
    b.denominazione,
    b.tipo_staz,
    b.gid,
    (b.the_geom)::public.geometry(Point,23032) AS the_geom,
    (foo.pluv3h)::numeric(5,2) AS ultimovalore,
    foo.timeultimovalore,
    foo.id_parametro,
    foo.data_agg
   FROM (dati_di_base.rete_meteoidrografica b
     LEFT JOIN ( SELECT meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            round(sum(meteo_real_time.valore_originale), 1) AS pluv3h,
            max(to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text)) AS timeultimovalore,
            max(meteo_real_time.data_agg) AS data_agg,
            max((meteo_real_time.id_parametro)::text) AS id_parametro
           FROM realtime.meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'PLUV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '03:00:00'::interval)))
          GROUP BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
  WHERE ((b.tipo_staz)::text ~~ '%P%'::text);


ALTER TABLE realtime.v_last_pluv OWNER TO postgres;

--
-- Name: VIEW v_last_pluv; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_last_pluv IS 'cumulata di pioggia ultime 3h per le stazioni di meteo_real_time - etichettatura per WebGIS';


--
-- Name: v_last_terma; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_last_terma AS
 WITH ultimo_dato AS (
         SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            meteo_real_time.id_parametro,
            (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text))::timestamp without time zone AS timeultimovalore,
            (meteo_real_time.valore_originale)::integer AS ultimovalore
           FROM realtime.meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'TERMA'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC
        )
 SELECT b.codice_istat_comune,
    b.progr_punto_com,
    b.denominazione,
    b.tipo_staz,
    b.gid,
    (b.the_geom)::public.geometry(Point,23032) AS the_geom,
    foo.ultimovalore,
    foo.timeultimovalore,
    'meteoidro'::text AS tipo_rete
   FROM (dati_di_base.rete_meteoidrografica b
     LEFT JOIN ultimo_dato foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
  WHERE (((b.tipo_staz)::text ~~ '%T%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_terma OWNER TO postgres;

--
-- Name: VIEW v_last_terma; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_last_terma IS 'ultimo dato registrato di temperatura per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_vento; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW realtime.v_last_vento AS
 SELECT b.gid,
    b.denominazione,
    b.codice_istat_comune,
    b.progr_punto_com,
    b.tipo_staz,
    (b.the_geom)::public.geometry(Point,23032) AS the_geom,
    COALESCE(foo2.ultimovalore, 0) AS dirultimo,
    COALESCE(foo.ultimovalore, ((-9999))::numeric) AS ventoultimo,
    foo.timeultimovalore
   FROM ((dati_di_base.rete_meteoidrografica b
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) AS timeultimovalore,
            (meteo_real_time.valore_originale)::numeric(4,1) AS ultimovalore
           FROM realtime.meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'VELV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            (meteo_real_time.valore_originale)::integer AS ultimovalore
           FROM realtime.meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'DIRV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo2 ON ((((foo2.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo2.progr_punto_com = b.progr_punto_com))))
  WHERE (((b.tipo_staz)::text ~~ '%V%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_vento OWNER TO postgres;

--
-- Name: VIEW v_last_vento; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW realtime.v_last_vento IS 'ultimo dato registrato di temperatura per le stazioni di meteo_real_time nella ultima 1,5ore - etichettatura per WebGIS';


--
-- Name: webgis_tickets; Type: TABLE; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE TABLE realtime.webgis_tickets (
    gid integer NOT NULL,
    data_apertura timestamp without time zone DEFAULT now() NOT NULL,
    autore character(8) NOT NULL,
    richiesta character varying(250) NOT NULL,
    tipo character varying(24) NOT NULL,
    browser_client character varying(32),
    so_client character varying(32),
    data_chiusura timestamp without time zone,
    webgis character varying(32) DEFAULT 'generico'::character varying,
    autore_chiusura character varying(12),
    note_chiusura character varying(250)
);


ALTER TABLE realtime.webgis_tickets OWNER TO postgres;

--
-- Name: TABLE webgis_tickets; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON TABLE realtime.webgis_tickets IS 'Raccolta delle richieste dei fruitori del servizio webgis';


--
-- Name: webgis_tickets_gid_seq; Type: SEQUENCE; Schema: realtime; Owner: postgres
--

CREATE SEQUENCE realtime.webgis_tickets_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE realtime.webgis_tickets_gid_seq OWNER TO postgres;

--
-- Name: webgis_tickets_gid_seq; Type: SEQUENCE OWNED BY; Schema: realtime; Owner: postgres
--

ALTER SEQUENCE realtime.webgis_tickets_gid_seq OWNED BY realtime.webgis_tickets.gid;


--
-- Name: gid; Type: DEFAULT; Schema: realtime; Owner: radar_rw
--

ALTER TABLE ONLY realtime.report_evento ALTER COLUMN gid SET DEFAULT nextval('realtime.report_evento_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.webgis_tickets ALTER COLUMN gid SET DEFAULT nextval('realtime.webgis_tickets_gid_seq'::regclass);


--
-- Data for Name: anomalie; Type: TABLE DATA; Schema: realtime; Owner: postgres
--

COPY realtime.anomalie (data_inizio, data_fine, id_sistema, autore, data_agg, descrizione, severita) FROM stdin;
\.


--
-- Data for Name: bis_stato; Type: TABLE DATA; Schema: realtime; Owner: idro
--

COPY realtime.bis_stato (gid, codice, denominazione, the_geom, ultimovalore, data, dmv_base, dmv_deroga, stato, soglia_allarme, stato_allarme) FROM stdin;
\.


--
-- Data for Name: report_evento; Type: TABLE DATA; Schema: realtime; Owner: radar_rw
--

COPY realtime.report_evento (gid, dataevento, localita, lat, lon, raggio, tipo_evento, link_news, the_geom, autore, data_agg, note) FROM stdin;
\.


--
-- Name: report_evento_gid_seq; Type: SEQUENCE SET; Schema: realtime; Owner: radar_rw
--

SELECT pg_catalog.setval('realtime.report_evento_gid_seq', 1, true);


--
-- Data for Name: webgis_tickets; Type: TABLE DATA; Schema: realtime; Owner: postgres
--

COPY realtime.webgis_tickets (gid, data_apertura, autore, richiesta, tipo, browser_client, so_client, data_chiusura, webgis, autore_chiusura, note_chiusura) FROM stdin;
\.


--
-- Name: webgis_tickets_gid_seq; Type: SEQUENCE SET; Schema: realtime; Owner: postgres
--

SELECT pg_catalog.setval('realtime.webgis_tickets_gid_seq', 1, false);


--
-- Name: bis_stato_codice_key; Type: CONSTRAINT; Schema: realtime; Owner: idro; Tablespace: 
--

ALTER TABLE ONLY realtime.bis_stato
    ADD CONSTRAINT bis_stato_codice_key UNIQUE (codice);


--
-- Name: bis_stato_pkey; Type: CONSTRAINT; Schema: realtime; Owner: idro; Tablespace: 
--

ALTER TABLE ONLY realtime.bis_stato
    ADD CONSTRAINT bis_stato_pkey PRIMARY KEY (gid);


--
-- Name: pk_anomalia; Type: CONSTRAINT; Schema: realtime; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY realtime.anomalie
    ADD CONSTRAINT pk_anomalia PRIMARY KEY (data_inizio, id_sistema);


--
-- Name: pk_meteo_real_time; Type: CONSTRAINT; Schema: realtime; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY realtime.meteo_real_time
    ADD CONSTRAINT pk_meteo_real_time PRIMARY KEY (id_rete_monit, codice_istat_comune, progr_punto_com, data, ora, id_parametro, id_aggregazione);


--
-- Name: report_evento_pkey; Type: CONSTRAINT; Schema: realtime; Owner: radar_rw; Tablespace: 
--

ALTER TABLE ONLY realtime.report_evento
    ADD CONSTRAINT report_evento_pkey PRIMARY KEY (gid);


--
-- Name: webgis_tickets_pkey; Type: CONSTRAINT; Schema: realtime; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY realtime.webgis_tickets
    ADD CONSTRAINT webgis_tickets_pkey PRIMARY KEY (gid);


--
-- Name: idx_webcam_geom; Type: INDEX; Schema: realtime; Owner: radar_rw; Tablespace: 
--

CREATE INDEX idx_webcam_geom ON realtime.report_evento USING gist (the_geom);


--
-- Name: meteo_real_time_idx_istat_progr; Type: INDEX; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE INDEX meteo_real_time_idx_istat_progr ON realtime.meteo_real_time USING btree (codice_istat_comune, progr_punto_com);


--
-- Name: after_insert_report_evento; Type: TRIGGER; Schema: realtime; Owner: radar_rw
--

CREATE TRIGGER after_insert_report_evento AFTER INSERT ON realtime.report_evento FOR EACH ROW EXECUTE PROCEDURE realtime.report_evento_insert();


--
-- Name: anomalie_id_sistema_fkey; Type: FK CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.anomalie
    ADD CONSTRAINT anomalie_id_sistema_fkey FOREIGN KEY (id_sistema) REFERENCES config.anomalie_sistemi(id_sistema) MATCH FULL;


--
-- Name: anomalie_severita_fkey; Type: FK CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY realtime.anomalie
    ADD CONSTRAINT anomalie_severita_fkey FOREIGN KEY (severita) REFERENCES config.anomalie_severita(severita_idx);


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA realtime FROM PUBLIC;
REVOKE ALL ON SCHEMA realtime FROM postgres;
GRANT ALL ON SCHEMA realtime TO postgres;
GRANT USAGE ON SCHEMA realtime TO PUBLIC;
GRANT USAGE ON SCHEMA realtime TO webgis_r;
GRANT ALL ON SCHEMA realtime TO radar_rw;


--
-- Name: TABLE anomalie; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.anomalie FROM PUBLIC;
REVOKE ALL ON TABLE realtime.anomalie FROM postgres;
GRANT ALL ON TABLE realtime.anomalie TO postgres;
GRANT SELECT ON TABLE realtime.anomalie TO webgis_r;
GRANT ALL ON TABLE realtime.anomalie TO radar_rw;


--
-- Name: TABLE bis_stato; Type: ACL; Schema: realtime; Owner: idro
--

REVOKE ALL ON TABLE realtime.bis_stato FROM PUBLIC;
REVOKE ALL ON TABLE realtime.bis_stato FROM idro;
GRANT ALL ON TABLE realtime.bis_stato TO idro;
GRANT SELECT ON TABLE realtime.bis_stato TO webgis_r;
GRANT ALL ON TABLE realtime.bis_stato TO radar_rw;


--
-- Name: TABLE meteo_real_time; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.meteo_real_time FROM PUBLIC;
REVOKE ALL ON TABLE realtime.meteo_real_time FROM postgres;
GRANT ALL ON TABLE realtime.meteo_real_time TO postgres;
GRANT SELECT ON TABLE realtime.meteo_real_time TO webgis_r;
GRANT ALL ON TABLE realtime.meteo_real_time TO radar_rw;


--
-- Name: TABLE report_evento; Type: ACL; Schema: realtime; Owner: radar_rw
--

REVOKE ALL ON TABLE realtime.report_evento FROM PUBLIC;
REVOKE ALL ON TABLE realtime.report_evento FROM radar_rw;
GRANT ALL ON TABLE realtime.report_evento TO radar_rw;
GRANT SELECT ON TABLE realtime.report_evento TO webgis_r;


--
-- Name: TABLE v_anomalie; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_anomalie FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_anomalie FROM postgres;
GRANT ALL ON TABLE realtime.v_anomalie TO postgres;
GRANT SELECT ON TABLE realtime.v_anomalie TO webgis_r;
GRANT ALL ON TABLE realtime.v_anomalie TO radar_rw;


--
-- Name: TABLE v_last_idro; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_last_idro FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_last_idro FROM postgres;
GRANT ALL ON TABLE realtime.v_last_idro TO postgres;
GRANT SELECT ON TABLE realtime.v_last_idro TO webgis_r;
GRANT ALL ON TABLE realtime.v_last_idro TO radar_rw;


--
-- Name: TABLE v_last_nivo; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_last_nivo FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_last_nivo FROM postgres;
GRANT ALL ON TABLE realtime.v_last_nivo TO postgres;
GRANT SELECT ON TABLE realtime.v_last_nivo TO webgis_r;
GRANT ALL ON TABLE realtime.v_last_nivo TO radar_rw;


--
-- Name: TABLE v_last_pluv; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_last_pluv FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_last_pluv FROM postgres;
GRANT ALL ON TABLE realtime.v_last_pluv TO postgres;
GRANT SELECT ON TABLE realtime.v_last_pluv TO webgis_r;


--
-- Name: TABLE v_last_terma; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_last_terma FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_last_terma FROM postgres;
GRANT ALL ON TABLE realtime.v_last_terma TO postgres;
GRANT SELECT ON TABLE realtime.v_last_terma TO webgis_r;
GRANT ALL ON TABLE realtime.v_last_terma TO radar_rw;


--
-- Name: TABLE v_last_vento; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.v_last_vento FROM PUBLIC;
REVOKE ALL ON TABLE realtime.v_last_vento FROM postgres;
GRANT ALL ON TABLE realtime.v_last_vento TO postgres;
GRANT SELECT ON TABLE realtime.v_last_vento TO webgis_r;
GRANT ALL ON TABLE realtime.v_last_vento TO radar_rw;


--
-- Name: TABLE webgis_tickets; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE realtime.webgis_tickets FROM PUBLIC;
REVOKE ALL ON TABLE realtime.webgis_tickets FROM postgres;
GRANT ALL ON TABLE realtime.webgis_tickets TO postgres;
GRANT SELECT ON TABLE realtime.webgis_tickets TO webgis_r;
GRANT ALL ON TABLE realtime.webgis_tickets TO radar_rw;


--
-- PostgreSQL database dump complete
--

