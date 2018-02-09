--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = dati_di_base, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: rete_meteoidrografica; Type: TABLE; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE TABLE rete_meteoidrografica (
    codice_istat_comune character varying(6),
    progr_punto_com numeric(3,0),
    codice_stazione character varying(6),
    denominazione character varying(80),
    indirizzo character varying(80),
    utm_x numeric(7,0),
    utm_y numeric(7,0),
    tipo_staz character varying(13),
    proprietario character varying(100),
    modello_stazione character varying(10),
    flag_rupar character varying(1),
    quota_stazione numeric(6,2),
    quota_sito numeric(6,2),
    data_validita date,
    id_rete_monit character varying(2),
    meteo_tab character varying(16),
    gid integer NOT NULL,
    the_geom public.geometry,
    flag_idro boolean DEFAULT false,
    flag_po boolean DEFAULT false,
    quota_int integer,
    data_inizio_pubblicazione date,
    data_fine_pubblicazione date,
    CONSTRAINT enforce_dims_the_geom CHECK ((public.st_ndims(the_geom) = 2)),
    CONSTRAINT enforce_geotype_the_geom CHECK (((public.geometrytype(the_geom) = 'POINT'::text) OR (the_geom IS NULL))),
    CONSTRAINT enforce_srid_the_geom CHECK ((public.st_srid(the_geom) = 23032))
);


ALTER TABLE dati_di_base.rete_meteoidrografica OWNER TO postgres;

--
-- Name: TABLE rete_meteoidrografica; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON TABLE rete_meteoidrografica IS 'rete meteoidrografica in linea con Oracle, tavola "stazione_misura". Porre ''meteo_tab=Z'' per DISATTIVARE una stazione!';


--
-- Name: COLUMN rete_meteoidrografica.tipo_staz; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON COLUMN rete_meteoidrografica.tipo_staz IS 'alcune lettere poco parlanti: X-sezione fluviale; Y-TERMN';


--
-- Name: COLUMN rete_meteoidrografica.meteo_tab; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON COLUMN rete_meteoidrografica.meteo_tab IS 'Classi per tematizzazione su WebGIS:"Meteorologica","Idrometrica","IdrometricaQ" con portata,"Nivometrica","Z" se disattivata';


--
-- Name: COLUMN rete_meteoidrografica.quota_int; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON COLUMN rete_meteoidrografica.quota_int IS 'E'' la quota_sito ricalcolata come numero intero';


--
-- Name: rete_meteoidrografica_2_gid_seq; Type: SEQUENCE; Schema: dati_di_base; Owner: postgres
--

CREATE SEQUENCE rete_meteoidrografica_2_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dati_di_base.rete_meteoidrografica_2_gid_seq OWNER TO postgres;

--
-- Name: rete_meteoidrografica_2_gid_seq; Type: SEQUENCE OWNED BY; Schema: dati_di_base; Owner: postgres
--

ALTER SEQUENCE rete_meteoidrografica_2_gid_seq OWNED BY rete_meteoidrografica.gid;


--
-- Name: soglie_gamma; Type: TABLE; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE TABLE soglie_gamma (
    codice_istat_comune character varying(6) NOT NULL,
    progr_punto_com numeric(3,0) NOT NULL,
    id_parametro character varying(6) NOT NULL,
    codice2 numeric(12,3),
    codice3 numeric(12,3)
);


ALTER TABLE dati_di_base.soglie_gamma OWNER TO postgres;

--
-- Name: TABLE soglie_gamma; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON TABLE soglie_gamma IS 'soglie_gamma in linea con Oracle, tavola "soglie_gamma"';


--
-- Name: soglie_idrometriche; Type: TABLE; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE TABLE soglie_idrometriche (
    codice_istat_comune character varying(6) NOT NULL,
    progr_punto_com numeric(3,0) NOT NULL,
    id_parametro character varying(8) NOT NULL,
    codice1 numeric(6,1),
    codice2 numeric(6,1),
    codice3 numeric(6,1),
    data_agg date,
    autore_agg character varying(30),
    q_equilibrio numeric(6,2),
    dmv_base numeric(6,2),
    dmv_deroga numeric(6,2),
    zero_idrometrico numeric(6,2)
);


ALTER TABLE dati_di_base.soglie_idrometriche OWNER TO postgres;

--
-- Name: TABLE soglie_idrometriche; Type: COMMENT; Schema: dati_di_base; Owner: postgres
--

COMMENT ON TABLE soglie_idrometriche IS 'soglie idrometriche per le stazioni idro, livelli e portata. Da Db Oracle e da Graziadei-Zaccagnino';


SET search_path = realtime, pg_catalog;

--
-- Name: meteo_real_time; Type: TABLE; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE TABLE meteo_real_time (
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

COMMENT ON TABLE meteo_real_time IS 'Dati meteo realtime ricaricati ogni 6 ore. Dati presi da Interreg, procedura su radarop. NON MODIFICARE la struttura della tabella in quanto il caricamento da .csv e'' fatto dritto per dritto';


--
-- Name: anomalie; Type: TABLE; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE TABLE anomalie (
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

COMMENT ON TABLE anomalie IS 'Tabella con le anomalie ai sitemi';


--
-- Name: COLUMN anomalie.autore; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON COLUMN anomalie.autore IS 'Autore che ha inserito l''anomalia';


--
-- Name: COLUMN anomalie.severita; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON COLUMN anomalie.severita IS 'grado di severita dell''anomalia: 1-lieve; 2-moderata; 3-grave anomalia.
Aggiungere ''1'' davanti per eventi senza impatti operativi';


--
-- Name: bis_stato; Type: TABLE; Schema: realtime; Owner: idro; Tablespace: 
--

CREATE TABLE bis_stato (
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

COMMENT ON TABLE bis_stato IS 'tabella creata tramite trigger su inserimento dei dati in BIS per valutare lo stato delle singole stazioni_bis in base al valore di portata e il DMV';


--
-- Name: COLUMN bis_stato.stato; Type: COMMENT; Schema: realtime; Owner: idro
--

COMMENT ON COLUMN bis_stato.stato IS '0-Q_media > DMV base; 1-Q_media < DMV base; 2-Q_media < DMV deroga; 3-soglie mancanti; -1-dati ultimo giorno mancanti; -2-portata<-999';


--
-- Name: COLUMN bis_stato.stato_allarme; Type: COMMENT; Schema: realtime; Owner: idro
--

COMMENT ON COLUMN bis_stato.stato_allarme IS '0-nessun superamento soglia_allarme; 1-superamento soglia_allarme';


--
-- Name: v_anomalie; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_anomalie AS
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
    anomalie,
    config.anomalie_severita
  WHERE ((anomalie.id_sistema = anomalie_sistemi.id_sistema) AND (anomalie_severita.severita_idx = anomalie.severita))
  ORDER BY anomalie.data_inizio DESC;


ALTER TABLE realtime.v_anomalie OWNER TO postgres;

--
-- Name: VIEW v_anomalie; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW v_anomalie IS 'Anomalie riscontrate nelle apparecchiature radar - per WebGIS';


--
-- Name: v_last_idro; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_last_idro AS
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
           FROM meteo_real_time
          WHERE ((((meteo_real_time.id_parametro)::text ~~ 'IDRO%'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND ((meteo_real_time.tipologia_validaz IS NULL) OR ((meteo_real_time.tipologia_validaz)::text !~~ 'A%'::text)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            meteo_real_time.id_parametro,
            to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) AS timeultimovalore,
            round(meteo_real_time.valore_validato) AS ultimovalore
           FROM meteo_real_time
          WHERE ((((meteo_real_time.id_parametro)::text ~~ 'PORTATA'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND ((meteo_real_time.tipologia_validaz IS NULL) OR ((meteo_real_time.tipologia_validaz)::text !~~ 'A%'::text)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo2 ON ((((foo2.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo2.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN dati_di_base.soglie_idrometriche c ON (((((c.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (c.progr_punto_com = b.progr_punto_com)) AND ((foo.id_parametro)::text = (c.id_parametro)::text))))
  WHERE (((b.tipo_staz)::text ~~ '%I%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_idro OWNER TO postgres;

--
-- Name: VIEW v_last_idro; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW v_last_idro IS 'ultimo dato registrato di livello IDRO per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_nivo; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_last_nivo AS
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
           FROM meteo_real_time a,
            meteo_real_time b_1
          WHERE (((((((a.id_parametro)::text = 'NIVO'::text) AND (to_timestamp((a.data || (a.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval))) AND (to_timestamp((b_1.data || (b_1.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) = (((('now'::text)::date || ' '::text) || '08:00'::text))::timestamp without time zone)) AND ((a.codice_istat_comune)::text = (b_1.codice_istat_comune)::text)) AND (a.progr_punto_com = b_1.progr_punto_com)) AND ((b_1.id_parametro)::text = 'NIVO'::text))
          ORDER BY a.codice_istat_comune, a.progr_punto_com, to_timestamp((a.data || (a.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
  WHERE (((b.tipo_staz)::text ~~ '%N%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_nivo OWNER TO postgres;

--
-- Name: VIEW v_last_nivo; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW v_last_nivo IS 'ultimo dato registrato di neve a cui viene sottratto il dato delle 8 del mattino dello stesso giorno per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_pluv; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_last_pluv AS
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
           FROM meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'PLUV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '03:00:00'::interval)))
          GROUP BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
  WHERE ((b.tipo_staz)::text ~~ '%P%'::text);


ALTER TABLE realtime.v_last_pluv OWNER TO postgres;

--
-- Name: VIEW v_last_pluv; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW v_last_pluv IS 'cumulata di pioggia ultime 3h per le stazioni di meteo_real_time - etichettatura per WebGIS';


--
-- Name: v_last_terma; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_last_terma AS
 WITH ultimo_dato AS (
         SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            meteo_real_time.id_parametro,
            (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text))::timestamp without time zone AS timeultimovalore,
            (meteo_real_time.valore_originale)::integer AS ultimovalore
           FROM meteo_real_time
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

COMMENT ON VIEW v_last_terma IS 'ultimo dato registrato di temperatura per le stazioni di meteo_real_time nella ultima ora - etichettatura per WebGIS';


--
-- Name: v_last_vento; Type: VIEW; Schema: realtime; Owner: postgres
--

CREATE VIEW v_last_vento AS
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
           FROM meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'VELV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo ON ((((foo.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo.progr_punto_com = b.progr_punto_com))))
     LEFT JOIN ( SELECT DISTINCT ON (meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com) meteo_real_time.codice_istat_comune,
            meteo_real_time.progr_punto_com,
            (meteo_real_time.valore_originale)::integer AS ultimovalore
           FROM meteo_real_time
          WHERE (((meteo_real_time.id_parametro)::text = 'DIRV'::text) AND (to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) > (now() - '01:30:00'::interval)))
          ORDER BY meteo_real_time.codice_istat_comune, meteo_real_time.progr_punto_com, to_timestamp((meteo_real_time.data || (meteo_real_time.ora)::text), 'YYYY-MM-DDHH24:MI:SS'::text) DESC) foo2 ON ((((foo2.codice_istat_comune)::text = (b.codice_istat_comune)::text) AND (foo2.progr_punto_com = b.progr_punto_com))))
  WHERE (((b.tipo_staz)::text ~~ '%V%'::text) AND ((b.meteo_tab)::text <> 'Z'::text));


ALTER TABLE realtime.v_last_vento OWNER TO postgres;

--
-- Name: VIEW v_last_vento; Type: COMMENT; Schema: realtime; Owner: postgres
--

COMMENT ON VIEW v_last_vento IS 'ultimo dato registrato di temperatura per le stazioni di meteo_real_time nella ultima 1,5ore - etichettatura per WebGIS';


SET search_path = dati_di_base, pg_catalog;

--
-- Name: gid; Type: DEFAULT; Schema: dati_di_base; Owner: postgres
--

ALTER TABLE ONLY rete_meteoidrografica ALTER COLUMN gid SET DEFAULT nextval('rete_meteoidrografica_2_gid_seq'::regclass);


--
-- Data for Name: rete_meteoidrografica; Type: TABLE DATA; Schema: dati_di_base; Owner: postgres
--

COPY rete_meteoidrografica (codice_istat_comune, progr_punto_com, codice_stazione, denominazione, indirizzo, utm_x, utm_y, tipo_staz, proprietario, modello_stazione, flag_rupar, quota_stazione, quota_sito, data_validita, id_rete_monit, meteo_tab, gid, the_geom, flag_idro, flag_po, quota_int, data_inizio_pubblicazione, data_fine_pubblicazione) FROM stdin;
002129	500	\N	SALUSSOLA ELVO	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1064	\N	f	f	\N	\N	\N
004124	900	116	MOMBARCARO	SAN MICHELE ARCANGELO	427336	4924499	HRTV	ARPAPIEMONTE	SP200	S	906.00	896.00	1988-07-27	17	Meteorologica	786	0101000020F85900000000000020151A41000000C014C95241	f	f	896	1988-07-27	\N
006136	901	243	PONZONE CIMAFERLE	CIMAFERLE-VASCA ACQUEDOTTO	459757	4933690	PT	ARPAPIEMONTE	SP200	S	693.00	693.00	2001-05-29	17	Meteorologica	878	0101000020F859000000000000B40F1C41000000800ED25241	f	f	693	2001-05-30	\N
004180	900	S3924	STAFFARDA GHIANDONE	PONTE SP89	375850	4954068	I	PROVINCIADICUNEO	SPM20	S	267.00	267.00	2005-03-03	17	Idrometrica	964	0101000020F859000000000000A8F0164100000000F5E55241	f	f	267	2008-01-01	2013-12-31
006024	900	227	BRIGNANO FRASCATA	MONTECUCCO	502476	4961288	HPT	ARPAPIEMONTE	SP200	S	512.00	512.00	1993-07-09	17	Meteorologica	583	0101000020F85900000000000030AB1E410000000002ED5241	f	f	512	1993-07-09	\N
004053	900	294	CASTELMAGNO	SANMAGNO	354208	4918133	NPT	ARPAPIEMONTE	SPM20	S	1755.00	1755.00	1996-09-19	17	Nivometrica	635	0101000020F859000000000000809E154100000040DDC25241	f	f	1755	1996-09-20	\N
004091	900	106	MONTE MALANOTTE	MONTE MALANOTTE	403783	4901595	PV	ARPAPIEMONTE	SPM20	S	1735.00	1735.00	1988-02-04	17	Meteorologica	799	0101000020F8590000000000001CA51841000000C0B6B25241	f	f	1735	1988-02-04	\N
001288	900	239	PIAMPRATO	PIAMPRATO	388706	5045997	HNPT	ARPAPIEMONTE	SP200	S	1555.00	1555.00	1993-07-08	17	Nivometrica	848	0101000020F85900000000000088B9174100000040BB3F5341	f	f	1555	1993-07-08	\N
004175	900	314	PRIERO	CASCINA BORGNIA	429031	4914348	HNPT	AUTOSTRADATO-SV	SP200	S	610.00	610.00	1993-04-08	17	Nivometrica	893	0101000020F8590000000000009C2F1A41000000002BBF5241	f	f	610	1993-04-08	\N
006022	900	141	CAPANNE MARCAROLO	CAPANNE MARCAROLO-CASCINA VIOLA	481677	4934651	HNPT	ARPAPIEMONTE	SPM20	S	780.00	780.00	1989-07-06	17	Nivometrica	609	0101000020F85900000000000034661D41000000C0FED25241	f	f	780	1989-07-06	\N
004088	900	327	FEISOGLIO	BRIC DELLA CHIESA	429551	4933078	HNPT	ARPAPIEMONTE	SP200	S	770.00	770.00	1995-11-22	17	Nivometrica	700	0101000020F859000000000000BC371A410000008075D15241	f	f	770	1995-11-22	\N
007045	900	S2614	NUS-PORLIOD	PORLIOD	382973	5073325	NPT	REGIONEVALLED'AOSTA	SPM20	S	1890.00	1890.00	2001-09-19	VA	Z	822	0101000020F859000000000000F45F1741000000406B5A5341	f	f	1890	\N	\N
033025	900	F3354	GROPPARELLO	GROPPARELLO	557444	4964446	P	REGIONEEMILIAROMAGNA	\N	N	359.00	359.00	2003-11-12	EM	Meteorologica	736	0101000020F859000000000000080321410000008017F05241	f	f	359	\N	\N
004078	901	S2891	CUNEO CAMERA COMMERCIO	CUNEO-VIA E.FILIBERTO 3	384371	4916196	BPRVT	ARPAPIEMONTE	SPM20	S	550.00	550.00	2002-05-30	17	Meteorologica	684	0101000020F859000000000000CC75174100000000F9C05241	f	f	550	2002-05-31	\N
012091	900	F2023	PONTEVEDANO	PONTEVEDANO	489872	5069647	IPT	REGIONELOMBARDIA	SPM20	N	360.00	360.00	2003-11-12	LO	Z	872	0101000020F8590000376ED05887E61D41E2E9AD419B565341	f	f	360	\N	\N
004091	901	310	BORELLO	BORELLO-CASECANE	406884	4897585	PT	ARPAPIEMONTE	SPM20	S	1005.00	1005.00	1997-10-14	17	Meteorologica	573	0101000020F85900000000000090D5184100000040CCAE5241	f	f	1005	1997-10-17	\N
004201	900	325	BERGALLI	BERGALLI	434957	4917579	BGHPRTV	ARPAPIEMONTE	SPM20	S	385.00	385.00	1990-02-14	17	Meteorologica	561	0101000020F859000000000000348C1A41000000C052C25241	f	f	385	1990-02-14	\N
003150	900	637	MOTTAC	MOTTAC	454003	5101241	PT	ARPAPIEMONTE	SPM20-RIL	S	1695.00	1695.00	1989-04-01	17	Meteorologica	810	0101000020F859000000000000CCB51B4100000040AE755341	f	f	1695	2000-01-01	\N
003151	900	638	SAMBUGHETTO	SAMBUGHETTO	446665	5084060	P	ARPAPIEMONTE	SP200	S	742.00	742.00	1989-11-28	17	Meteorologica	931	0101000020F85900000000000024431B4100000000E7645341	f	f	742	2001-01-01	\N
004001	900	133	ACCEGLIO	COLOMBATA	339567	4927939	HNPT	ARPAPIEMONTE	SP200	S	1610.00	1610.00	1989-06-14	17	Nivometrica	516	0101000020F859000000000000BCB91441000000C070CC5241	f	f	1610	1989-06-14	\N
004038	900	357	CANOSIO	CANOSIO	347840	4924337	PT	ARPAPIEMONTE	SP200	S	1220.00	1220.00	1999-07-16	17	Meteorologica	605	0101000020F859000000000000003B154100000040ECC85241	f	f	1220	1999-07-17	\N
004006	900	298	ARGENTERA	ARGENTERA	335978	4918048	NPT	ARPAPIEMONTE	SP200	S	1680.00	1680.00	1996-09-17	17	Nivometrica	536	0101000020F859000000000000A881144100000000C8C25241	f	f	1680	1996-09-18	\N
004010	900	332	BALDISSERO D'ALBA	APRATO	414707	4956203	HPTV	ARPAPIEMONTE	SPM20	S	265.00	265.00	1997-04-22	17	Meteorologica	548	0101000020F859000000000000CC4F1941000000C00AE85241	f	f	265	1997-04-23	\N
004029	900	317	BRA	MUSEOCRAVERI	409096	4950597	BHNPRTV	ARPAPIEMONTE	SPM20	S	298.00	285.00	1993-05-05	17	Nivometrica	579	0101000020F85900000000000020F818410000004091E25241	f	f	285	1993-05-05	\N
004031	900	308	UPEGA	UPEGA	398111	4887247	GHPT	ARPAPIEMONTE	SP200	S	1310.00	1310.00	1996-11-15	17	Meteorologica	992	0101000020F8590000000000007C4C1841000000C0B3A45241	f	f	1310	1996-11-16	\N
003142	900	635	MOTTARONE-BAITA CAI	MOTTARONE-BAITACAI	457172	5081082	PT	ARPAPIEMONTE	SP200	S	1302.00	1302.00	1986-03-01	17	Meteorologica	812	0101000020F85900000000000050E71B4100000080FE615341	f	f	1302	2000-01-01	\N
002123	900	438	SABBIA	MUNICIPIO	440818	5078628	P	ARPAPIEMONTE	SPM20	S	600.00	600.00	1996-05-29	17	Meteorologica	926	0101000020F859000000000000C8E71A4100000000995F5341	f	f	600	2001-01-01	\N
003059	900	159	CURSOLO	MONTEPRATINI	466641	5105305	HPT	ARPAPIEMONTE	SPM20	S	940.00	940.00	1993-05-26	17	Meteorologica	686	0101000020F859000000000000447B1C4100000040A6795341	f	f	940	1993-05-26	\N
001270	901	146	PIETRASTRETTA	PIETRASTRETTA	347088	5000758	HPRTV	SITAFS.P.A.	SP200	S	520.00	520.00	1990-12-05	17	Meteorologica	857	0101000020F859000000000000402F1541000000808D135341	f	f	520	1990-12-05	\N
001291	901	258	BARCENISIO	BARCENISIO	341798	5006429	HNPTV	SITAFS.P.A.	SP300	S	1525.00	1525.00	1994-11-17	17	Nivometrica	551	0101000020F85900000000000098DC14410000004017195341	f	f	1525	1994-11-17	\N
003010	900	154	ALPE DEVERO	ALPE DEVERO	443114	5129624	HNPT	ARPAPIEMONTE	SPM20	S	1634.00	1634.00	1991-10-29	17	Nivometrica	527	0101000020F859000000000000A80B1B410000000066915341	f	f	1634	1991-10-29	\N
003024	900	130	BORGOMANERO	PIOVALE-DEPURATORE COMUNALE	458054	5059749	HPRT	ARPAPIEMONTE	SPM20	S	300.00	300.00	1989-02-28	17	Meteorologica	575	0101000020F85900000000000018F51B4100000040294D5341	f	f	300	1989-02-28	\N
004095	901	122	COLLE SAN BERNARDO	COLLE SAN BERNARDO	423980	4892286	HPRTV	ARPAPIEMONTE	SPM20	S	980.00	980.00	1988-03-10	17	Meteorologica	668	0101000020F859000000000000B0E01941000000809FA95241	f	f	980	1988-03-10	\N
004075	900	140	COSTIGLIOLE SALUZZO	RIO TALU'-DEPURATORE COMUNALE	380628	4935110	HPRT	ARPAPIEMONTE	SPM20	S	440.00	440.00	1989-03-23	17	Meteorologica	673	0101000020F859000000000000503B17410000008071D35241	f	f	440	1989-03-23	\N
003057	900	156	CRODO	ISTITUTO AGRARIO	447933	5119640	HPT	ARPAPIEMONTE	SPM20	S	560.00	560.00	1991-10-30	17	Meteorologica	682	0101000020F859000000000000F4561B4100000000A6875341	f	f	560	1991-10-31	\N
003063	900	129	DRUOGNO	RIO SASSEGLIO	455744	5109311	HPT	ARPAPIEMONTE	SP200	S	831.00	831.00	1989-04-11	17	Meteorologica	697	0101000020F85900000000000000D11B41000000C08F7D5341	f	f	831	1989-04-12	\N
004095	902	312	MONTE BERLINO	MONTE BERLINO	414855	4895385	HPT	COMUNITA'MONTANAVALLIMONGIA,CEVETTAELANGACEBANA	SP200	S	1765.00	1765.00	1995-11-16	17	Meteorologica	796	0101000020F8590000000000001C52194100000040A6AC5241	f	f	1765	1995-11-16	\N
002029	900	182	CARCOFORO	CARCOFORO	426444	5084376	PT	ARPAPIEMONTE	SPM20	S	1290.00	1290.00	1996-11-06	17	Meteorologica	610	0101000020F85900000000000030071A410000000036655341	f	f	1290	1996-11-07	\N
002057	900	437	FOBELLO	FOBELLO	434800	5082809	P	ARPAPIEMONTE	SPM20	S	873.00	873.00	1996-05-29	17	Meteorologica	705	0101000020F859000000000000C0891A4100000040AE635341	f	f	873	2001-01-01	\N
002095	900	191	PIEDICAVALLO	PIEDICAVALLO	418813	5060264	NPT	ARPAPIEMONTE	SPM20	S	1040.00	1040.00	1996-11-09	17	Nivometrica	856	0101000020F859000000000000F48F194100000000AA4D5341	f	f	1040	1996-11-09	\N
001013	900	142	AVIGLIANA	GRANGIA	373774	4994834	HPRTV	SITAFS.P.A.	SP300	S	340.00	340.00	1991-01-09	17	Meteorologica	542	0101000020F8590000591DD0CFE3CF1641AE9A3344C40D5341	f	f	340	1991-01-09	\N
001022	900	152	PRERICHARD	PRERICHARD	320334	4994017	BHNPRTV	SITAFS.P.A.	SP300	S	1353.00	1353.00	1990-12-06	17	Nivometrica	892	0101000020F859000000000000388D134100000040F80C5341	f	f	1353	1990-12-06	\N
001093	900	255	PRAROTTO	PRAROTTO	361575	5000935	HPTV	SITAFS.P.A.	SP300	S	1440.00	1440.00	1997-09-09	17	Meteorologica	886	0101000020F8590000000000009C111641000000C0B9135341	f	f	1440	1997-09-10	\N
001114	900	149	VAL CLAREA	VALCLAREA	340068	5000850	HNPT	IRIDES.P.A.	SP200	S	1135.00	1135.00	1996-09-02	17	Nivometrica	994	0101000020F85900000000000090C1144100000080A4135341	f	f	1135	1996-09-03	\N
001134	900	125	BERTODASCO	BERTODASCO	375704	5033193	HPT	ARPAPIEMONTE	SP200	S	1120.00	1120.00	1989-05-26	17	Meteorologica	563	0101000020F85900000000000060EE1641000000403A335341	f	f	1120	1989-05-26	\N
001010	900	346	ANDRATE PINALBA	PINALBA	413632	5046071	PRT	ARPAPIEMONTE	SP200	S	1580.00	1580.00	1999-09-08	17	Meteorologica	532	0101000020F859000000000000003F1941000000C0CD3F5341	f	f	1580	1999-09-09	\N
001139	900	105	LUSERNA S.GIOVANNI	PRALAFERA	361006	4963859	HPT	ARPAPIEMONTE	SPM20	S	475.00	475.00	1988-01-12	17	Meteorologica	767	0101000020F859000000000000B8081641000000C084EF5241	f	f	475	1988-01-12	\N
001139	901	418	LUSERNA S.GIOVANNI PELLICE	AIRALI	361219	4963667	I	ARPAPIEMONTE	SP200	S	478.00	478.00	1990-06-28	17	Idrometrica	768	0101000020F8590000000000000C0C1641000000C054EF5241	f	f	478	2003-01-01	2008-12-31
001156	900	273	BAUDUCCHI	BAUDUCCHI	398228	4979528	HPRTV	ARPAPIEMONTE	SPM20	S	226.00	226.00	1993-06-16	17	Meteorologica	557	0101000020F859000000000000504E184100000000D2FE5241	f	f	226	1993-06-16	\N
033007	900	F2939	CADEO CHIAVENNA	SALICETO	569016	4983219	I	ARPA EMILIA ROMAGNA	\N	N	68.00	68.00	2003-11-03	EM	Idrometrica	1054	0101000020F8590000F15D48C6BB58214146520A12DC015341	f	f	68	\N	\N
001191	900	268	TALUCCO	TALUCCO	365228	4978893	P	ARPAPIEMONTE	SP200	S	776.00	776.00	1996-11-13	17	Meteorologica	968	0101000020F859000000000000B04A16410000004033FE5241	f	f	776	1996-11-14	\N
002003	900	112	ALBANO VERCELLESE	VIVAIO FORESTALE FENALE	452241	5031988	HNPT	ARPAPIEMONTE	SPM20	S	155.00	155.00	1988-04-08	17	Nivometrica	523	0101000020F859000000000000449A1B41000000000D325341	f	f	155	1988-04-09	\N
001059	900	195	CARMAGNOLA	ISTITUTO AGRARIA	396316	4971343	BHPRTV	ARPAPIEMONTE	SPM20	S	232.00	232.00	1993-06-10	17	Meteorologica	614	0101000020F85900000000000070301841000000C0D3F65241	f	f	232	1993-06-10	\N
001026	900	003	COLLE BARANT	COLLE BARANT-GIARDINOALPINOPEYRONEL	346624	4959923	GNPTV	ARPAPIEMONTE	SPM20	S	2294.00	2294.00	1987-09-25	17	Nivometrica	663	0101000020F85900000000000000281541000000C0ACEB5241	f	f	2294	1987-09-26	\N
001074	900	257	COLLE BERCIA	COLLE BERCIA	325119	4976764	GHNPRTV	ARPAPIEMONTE	SPM20	S	2200.00	2200.00	1996-10-18	17	Nivometrica	664	0101000020F859000000000000FCD71341000000001FFC5241	f	f	2200	1996-10-19	\N
001073	900	237	LAGO AGNEL	LAGO AGNEL	354620	5036811	GNPT	ARPAPIEMONTE	SP200	S	2304.00	2304.00	1996-10-10	17	Nivometrica	748	0101000020F859000000000000F0A41541000000C0C2365341	f	f	2304	1996-10-11	\N
005060	900	S3228	LOAZZOLO	SANTA LIBERA	439310	4947239	HPT	ARPAPIEMONTE	SPM20	S	600.00	600.00	2002-04-17	17	Meteorologica	763	0101000020F85900000000000038D01A41000000C049DF5241	f	f	600	2002-04-18	\N
001144	900	274	MARENTINO	VILLA MONT PLAISIR	411791	4988907	HPT	ARPAPIEMONTE	SPM20	S	345.00	345.00	1995-12-06	17	Meteorologica	775	0101000020F8590000000000003C221941000000C0FA075341	f	f	345	1995-12-06	\N
002074	900	272	MASSAZZA	CASCINA ARTIGLIA	435193	5036020	HPRTV	ARPAPIEMONTE	SPM20	S	226.00	226.00	1993-06-17	17	Meteorologica	778	0101000020F859000000000000E48F1A4100000000FD355341	f	f	226	1993-06-17	\N
001151	900	124	MEUGLIANO	VIVAIO FORESTALE GARAVOT	404848	5036493	HPT	ARPAPIEMONTE	SPM20	S	650.00	650.00	1988-05-06	17	Meteorologica	781	0101000020F859000000000000C0B518410000004073365341	f	f	650	1988-05-06	\N
002012	900	123	OROPA	SANTUARIO DI OROPA	420668	5053282	BHPTV	ARPAPIEMONTE	SPM20	S	1186.00	1186.00	1988-05-19	17	Meteorologica	825	0101000020F859000000000000F0AC194100000080D8465341	f	f	1186	1988-05-20	\N
006146	900	222	ROCCAFORTE LIGURE	CORTI	501905	4947444	PT	ARPAPIEMONTE	SP200	S	770.00	770.00	1996-08-27	17	Meteorologica	911	0101000020F85900000000000044A21E41000000007DDF5241	f	f	770	1996-08-28	\N
006154	900	176	SAN SALVATORE MONFERRATO	CAMPANONE	465907	4982455	PT	ARPAPIEMONTE	SP200	S	251.00	251.00	1998-02-26	17	Meteorologica	939	0101000020F859000000000000CC6F1C41000000C0AD015341	f	f	251	1998-02-27	\N
018033	900	510	CASEI GEROLA PO	CASEIGEROLA	492537	4990297	I	AGENZIAINTERREGIONALEDELPO	SP200	S	71.00	71.00	1997-10-30	MP	Idrometrica	624	0101000020F859000000000000E40F1E410000004056095341	f	f	71	\N	\N
018073	900	425	GODIASCO STAFFORA	GODIASCO	504323	4971190	I	REGIONE LOMBARDIA	SP200	N	197.00	197.00	1998-01-01	LO	Idrometrica	1056	0101000020F8590000F2834298D5C41E41C9BE555265F75241	f	f	197	\N	\N
007021	901	S2615	COGNE-VALNONTEY	VALNONTEY	370379	5049553	PT	REGIONEVALLED'AOSTA	SPM20	S	1682.00	1682.00	2001-10-11	VA	Meteorologica	662	0101000020F8590000000000002C9B16410000004034435341	f	f	1682	\N	\N
007057	900	S2623	ROISAN-MOULIN-BUTHIER	CLOSELLINAZ	368415	5071921	I	REGIONEVALLED'AOSTA	SPM20	S	745.00	745.00	2001-10-24	VA	Idrometrica	918	0101000020F8590000000000007C7C1641000000400C595341	f	f	745	\N	\N
007033	900	S2625	GRESSONEY-S.J.-CAPOLUOGO-LYS	BIELCIUKEN	409302	5069074	I	REGIONEVALLED'AOSTA	SPM20	S	1373.00	1373.00	2001-09-19	VA	Idrometrica	731	0101000020F85900000000000058FB18410000008044565341	f	f	1373	\N	\N
010051	900	398	ROSSIGLIONE	GHIDOMO	472982	4936010	PT	REGIONELIGURIA	SP200	S	289.00	289.00	2001-07-12	RL	Meteorologica	922	0101000020F85900000000000058DE1C410000008052D45241	f	f	289	2001-10-01	\N
033005	900	426	BOBBIO TREBBIA	PONTE S.S.45	545279	4958053	IPT	REGIONEEMILIAROMAGNA	\N	N	437.00	437.00	1993-01-15	EM	Idrometrica	570	0101000020F85900001227A8523833204162C678CC7BE75241	f	f	437	\N	\N
005025	900	174	CASTELL'ALFERO	SCUOLE MEDIE COMUNALI "G.B.DEROLANDIS"	438822	4982122	PT	ARPAPIEMONTE	SPM20	S	140.00	140.00	1998-02-25	17	Meteorologica	630	0101000020F85900000000000098C81A41000000805A015341	f	f	140	1998-02-26	\N
007018	900	S2621	CHAMPORCHER-RIFUGIODONDENA	RIFUGIO DONDENA	387168	5052194	NPT	REGIONEVALLED'AOSTA	SPM20	S	2181.00	2181.00	2001-09-19	VA	Nivometrica	650	0101000020F85900000000000080A1174100000080C8455341	f	f	2181	\N	\N
007016	900	S2620	CHAMOIS-LAGODILOU	LAC DEL OU	393147	5077893	PT	REGIONEVALLED'AOSTA	SPM20	S	2020.00	2020.00	2001-09-25	VA	Meteorologica	647	0101000020F859000000000000ECFE174100000040E15E5341	f	f	2020	\N	\N
006159	900	211	CREA	SANTUARIO DI CREA	443245	4993811	GHPTV	ARPAPIEMONTE	SPM20	S	385.00	385.00	1997-10-17	17	Meteorologica	678	0101000020F859000000000000B40D1B41000000C0C40C5341	f	f	385	1997-10-18	\N
005075	900	139	MONTECHIARO D'ASTI	ROVANELLO-BOREGNA-DEPURATORE COMUNALE	429242	4984323	HPRT	ARPAPIEMONTE	SP200	S	200.00	200.00	1989-04-06	17	Meteorologica	804	0101000020F859000000000000E8321A41000000C080035341	f	f	200	1989-04-07	\N
006081	900	306	GAVI	GAVI	483932	4949150	PT	ARPAPIEMONTE	SP200	S	215.00	215.00	2001-02-15	17	Meteorologica	722	0101000020F85900000000000070891D410000008027E15241	f	f	215	2001-10-01	\N
004160	900	363	PAROLDO	BRICPALUCO	426972	4921992	PT	ARPAPIEMONTE	SP200	S	810.00	810.00	2001-05-16	17	Meteorologica	837	0101000020F859000000000000700F1A4100000000A2C65241	f	f	810	2001-05-17	\N
007069	900	395	VALPELLINE-CHOZOD	CHOZOD	371116	5076358	NPT	REGIONEVALLED'AOSTA	SPM20	S	1029.00	1029.00	2001-09-27	VA	Nivometrica	999	0101000020F859000000000000B0A6164100000080615D5341	f	f	1029	\N	\N
007021	900	396	COGNE-LILLAZCENTRALE	LILLAZ	374621	5050540	NPT	REGIONEVALLED'AOSTA	SPM20	S	1613.00	1613.00	2001-10-25	VA	Nivometrica	661	0101000020F85900000000000074DD1641000000002B445341	f	f	1613	\N	\N
010006	900	397	BUSALLA	CAMPOSPORTIVO-VIASCRIVIA	495830	4934073	PT	REGIONELIGURIA	SMP20	S	358.00	358.00	2001-07-09	RL	Meteorologica	586	0101000020F85900000000000058431E41000000406ED25241	f	f	358	2004-01-01	\N
007041	900	400	LATHUILE-VILLARET	VILLARET	340981	5063942	NPT	REGIONEVALLED'AOSTA	SPM20	S	1488.00	1488.00	2001-10-23	VA	Nivometrica	747	0101000020F859000000000000D4CF14410000008041515341	f	f	1488	\N	\N
009015	901	S2582	MONTENOTTE INFERIORE	MONTENOTTEINFERIORE	453196	4917300	PT	REGIONELIGURIA	SPM20	S	564.00	564.00	2001-09-20	RL	Meteorologica	805	0101000020F85900000000000030A91B41000000000DC25241	f	f	564	2001-10-01	\N
009046	900	S2587	OSIGLIA	BARBERIS	436589	4904264	PT	REGIONELIGURIA	SPM20	S	620.00	620.00	2002-02-27	RL	Meteorologica	826	0101000020F859000000000000B4A51A410000000052B55241	f	f	620	2002-02-27	\N
003011	900	162	ANZINO	ANZINO	434710	5093118	PT	ARPAPIEMONTE	SP200	S	669.00	669.00	2000-11-24	17	Meteorologica	534	0101000020F85900000000000058881A4100000080BF6D5341	f	f	669	2000-11-25	\N
001003	900	250	ALA DI STURA	VIVAIO FORESTALE LA FABBRICA	367642	5019242	HPT	ARPAPIEMONTE	SPM20	S	1006.00	1006.00	1993-07-22	17	Meteorologica	520	0101000020F85900000000000068701641000000809A255341	f	f	1006	1993-07-22	\N
007005	900	S3271	ARVIER-CHAMENCON-DVALGRISENCHE	PONTE SUL DORA VALGRISENCHE	352690	5060255	IPT	REGIONEVALLED'AOSTA	\N	S	1238.00	1238.00	2004-08-03	VA	Idrometrica	538	0101000020F859000000000000C8861541000000C0A74D5341	f	f	1238	\N	\N
006003	901	178	ALESSANDRIA BORMIDA	PONTE S.S.10	472097	4972713	I	ARPAPIEMONTE	SP200	S	96.00	96.00	1998-05-19	17	Idrometrica	524	0101000020F85900000000000084D01C41000000402AF85241	f	f	96	2000-01-01	2012-12-31
003155	901	S2889	ALPE VEGLIA	ALBERGO MONTELEONE	433921	5125172	NPT	ARPAPIEMONTE	SPM20	S	1740.00	1740.00	2002-08-01	17	Nivometrica	529	0101000020F859000000000000047C1A41000000000D8D5341	f	f	1740	2002-08-02	\N
003010	901	S4059	BACENO DEVERO	PRESSO AREA RICREATIVA	447267	5123602	I	PROVINCIAVERBANOCUSIOOSSOLA	SPM20	S	625.00	625.00	2004-06-23	17	Idrometrica	546	0101000020F8590000000000008C4C1B4100000080848B5341	f	f	625	2007-01-01	2012-12-31
004018	900	316	BELVEDERE LANGHE	I PIANI	418603	4928137	HPT	ARPAPIEMONTE	SP200	S	550.00	550.00	1995-11-16	17	Meteorologica	560	0101000020F859000000000000AC8C194100000040A2CC5241	f	f	550	1995-11-16	\N
007022	900	S2599	COURMAYEUR-LEXBLANCHE	VAL VENYLEXBLANCHE	331991	5070560	PT	REGIONEVALLED'AOSTA	SPM20	S	2162.00	2162.00	2001-08-02	VA	Meteorologica	675	0101000020F8590000000000005C43144100000000B8575341	f	f	2162	\N	\N
004162	900	136	PERLO	FORNACA-CASCINA BRICCO	427006	4909165	HPT	ARPAPIEMONTE	SP200	S	700.00	700.00	1989-05-23	17	Meteorologica	843	0101000020F859000000000000F80F1A41000000401BBA5241	f	f	700	1989-05-23	\N
004089	900	323	FOSSANO	MADONNA DI LORETO	403729	4932637	BHPRTV	AUTOSTRADATO-SV	SPM20	S	403.00	403.00	1993-04-08	17	Meteorologica	712	0101000020F85900004142D5038FA418412338C44C05D15241	f	f	403	1993-04-08	\N
005110	900	209	TONENGO	REGIONE SANTA MARIA	421859	4996460	P	ARPAPIEMONTE	SP200	S	480.00	480.00	1996-08-29	17	Meteorologica	972	0101000020F8590000000000008CBF1941000000005B0F5341	f	f	480	1996-08-30	\N
006009	900	213	ARQUATA SCRIVIA	ARQUATA SCRIVIA	490646	4947889	BHPRTV	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	325.00	325.00	1998-04-08	17	Meteorologica	537	0101000020F85900000000000058F21D4100000040ECDF5241	f	f	325	1998-04-09	\N
004178	900	322	PRUNETTO	BRIC DELLE FORCHE	433557	4929030	HPT	ARPAPIEMONTE	SP200	S	751.00	751.00	1995-12-13	17	Meteorologica	894	0101000020F85900000000000054761A410000008081CD5241	f	f	751	1995-12-13	\N
004196	900	324	RODELLO	CASCINA MOSSIO	424991	4943560	HPT	ARPAPIEMONTE	SP200	S	415.00	415.00	1995-11-15	17	Meteorologica	917	0101000020F8590000000000007CF0194100000000B2DB5241	f	f	415	1995-11-15	\N
002156	900	132	VARALLO	VIVAIO FORESTALE CROSA	443670	5074457	HPT	ARPAPIEMONTE	SPM20	S	470.00	470.00	1989-03-01	17	Meteorologica	1004	0101000020F85900000000000058141B4100000040865B5341	f	f	470	1989-03-01	\N
001292	900	256	VENARIA CERONDA	PASSERELLA PEDONALE	392460	4998970	IPT	PROVINCIADITORINO	SP200	S	253.00	253.00	1997-12-23	17	Idrometrica	1011	0101000020F85900000000000030F4174100000080CE115341	f	f	253	1997-12-24	\N
001094	900	245	PIANO AUDI	PIANO AUDI CASERUI	383959	5023497	P	ARPAPIEMONTE	SPM20	S	1150.00	1150.00	1996-10-22	17	Meteorologica	854	0101000020F8590000000000005C6F174100000040C2295341	f	f	1150	1996-10-23	\N
001192	900	120	PINO TORINESE	OSSERVATORIO ASTRONOMICO	402828	4988482	BHPRTV	ARPAPIEMONTE	SPM20	S	619.00	608.00	1988-05-19	17	Meteorologica	860	0101000020F859000000000000309618410000008090075341	f	f	608	1988-05-19	\N
001203	900	102	PRALORMO	LAGO DELLA SPINA	414152	4967469	HPT	ARPAPIEMONTE	SPM20	S	295.00	295.00	1988-01-28	17	Meteorologica	884	0101000020F85900000000000020471941000000400BF35241	f	f	295	1988-01-28	\N
001114	901	020	RIFUGIO VACCARONE	RIFUGIO VACCARONE	336309	5002391	HNTV	IRIDES.P.A.	SPM20	S	2745.00	2745.00	1996-09-06	17	Nivometrica	904	0101000020F85900002FE5F28A31871441C80BD2D221155341	f	f	2745	1996-09-07	\N
001263	900	262	SESTRIERE	PRINCIPI DI PIEMONTE	332444	4979926	BHNPT	ARPAPIEMONTE	SP200	S	2020.00	2020.00	1996-09-10	17	Nivometrica	951	0101000020F859000000000000704A14410000008035FF5241	f	f	2020	1996-09-11	\N
001293	900	110	VEROLENGO	VIVAIO FORESTALE VIGNOLI	422382	5004180	HPRTVG	ARPAPIEMONTE	SP200	S	163.00	163.00	1988-04-07	17	Meteorologica	1015	0101000020F859000000000000B8C7194100000000E5165341	f	f	163	1988-04-07	\N
001224	900	S3214	FORZO	FORZO	381912	5041306	PT	ARPAPIEMONTE	SPM20	S	1162.00	1162.00	2002-05-16	17	Meteorologica	711	0101000020F859000000000000604F174100000080263B5341	f	f	1162	2002-07-26	\N
006045	900	219	CASTELLANIA	CASTELLANIA	494634	4960771	P	ARPAPIEMONTE	SP200	S	390.00	390.00	1996-08-28	17	Meteorologica	631	0101000020F859000000000000A8301E41000000C080EC5241	f	f	390	1996-08-29	\N
006069	900	228	FRACONALTO	FRACONALTO	490535	4937821	GP	ARPAPIEMONTE	SP200	S	725.00	725.00	1996-08-27	17	Meteorologica	715	0101000020F8590000000000009CF01D410000004017D65241	f	f	725	1996-08-28	\N
006087	900	220	ISOLA S.ANTONIO	STICOZZA	488564	4985460	BGHPRTV	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	77.00	77.00	1993-06-30	17	Meteorologica	740	0101000020F859000000000000D0D11D41000000009D045341	f	f	77	1993-06-30	\N
006121	900	230	OVADA	CAPPELLETTE	471188	4944033	HPT	ARPAPIEMONTE	SP200	S	230.00	230.00	1997-10-29	17	Meteorologica	828	0101000020F85900000000000050C21C410000004028DC5241	f	f	230	1997-10-30	\N
006136	900	127	PONZONE BRIC BERTON	BRIC BERTON	463454	4929755	BHNPRTV	ARPAPIEMONTE	SPM20	S	773.00	773.00	1989-10-05	17	Nivometrica	877	0101000020F85900000000000078491C41000000C036CE5241	f	f	773	1989-10-05	\N
005104	900	135	SEROLE BRIC PUSCHERA	BRIC PUSCHERA	441174	4934872	HPT	ARPAPIEMONTE	SP200	S	765.00	765.00	1989-04-05	17	Meteorologica	949	0101000020F85900000000000058ED1A410000000036D35241	f	f	765	1989-04-06	\N
004233	900	303	VALDIERI	TERME DI VALDIERI	361709	4896272	HNPT	ARPAPIEMONTE	SP200	S	1390.00	1390.00	1993-07-29	17	Nivometrica	995	0101000020F859000000000000B41316410000000084AD5241	f	f	1390	1993-07-29	\N
006179	900	175	VIGNALE MONFERRATO	CASCINA PERVASINO	453465	4985357	PT	ARPAPIEMONTE	SP200	S	308.00	308.00	1998-02-25	17	Meteorologica	1020	0101000020F85900000000000064AD1B410000004083045341	f	f	308	1998-02-26	\N
007049	900	287	POLLEIN-DORA BALTEA	POLLEIN	372489	5066184	IPT	REGIONEVALLED'AOSTA	SPM20	S	545.00	545.00	2001-09-27	VA	Idrometrica	864	0101000020F85900000000000024BC16410000000072535341	f	f	545	\N	\N
007051	900	304	PONTEY-DORA BALTEA	PONTEY	392534	5066380	IP	REGIONEVALLED'AOSTA	SPM20	S	445.00	445.00	2001-09-27	VA	Idrometrica	876	0101000020F85900000000000058F5174100000000A3535341	f	f	445	\N	\N
004207	900	S2570	SAN DAMIANO MACRA	CHIABRERI	360992	4929871	PT	ARPAPIEMONTE	SPM20	S	1095.00	1095.00	2001-09-07	17	Meteorologica	935	0101000020F85900000000000080081641000000C053CE5241	f	f	1095	2001-10-04	\N
004083	900	S2572	ELVA	MARTINI	348294	4934502	NPT	ARPAPIEMONTE	SPM20	S	1770.00	1770.00	2001-09-06	17	Nivometrica	698	0101000020F8590000000000001842154100000080D9D25241	f	f	1770	2001-10-01	\N
001131	900	S2578	LEMIE	OLMETTI	364567	5009893	PT	ARPAPIEMONTE	SPM20	S	995.00	995.00	2001-04-17	17	Meteorologica	758	0101000020F8590000000000005C40164100000040791C5341	f	f	995	2001-10-01	\N
002002	901	S2435	ALAGNA MINIERE	ALAGNA MINIERE	417511	5080844	TPN	Arpa Piemonte	SPM20	S	1347.00	1347.00	2001-06-14	17	Nivometrica	1061	0101000020F8590000055999A7177B1941C3E56D98BE615341	f	f	1347	2001-06-15	\N
001089	900	260	COAZZE	RUATA	361760	4989322	HPT	ARPAPIEMONTE	SP200	S	1130.00	1130.00	1993-07-15	17	Meteorologica	658	0101000020F859000000000000801416410000008062085341	f	f	1130	1993-07-15	\N
004195	900	329	RODDINO	POZZETTI	421386	4936815	HPT	ARPAPIEMONTE	SP200	S	500.00	500.00	1997-04-28	17	Meteorologica	916	0101000020F85900000000000028B81941000000C01BD55241	f	f	500	1997-04-29	\N
005074	900	103	MONTALDO SCARAMPI	CASTELLO	441508	4964453	HPTV	ARPAPIEMONTE	SPM20	S	295.00	295.00	1988-02-03	17	Meteorologica	795	0101000020F85900000000000090F21A410000004019F05241	f	f	295	1988-02-04	\N
004028	900	107	BOVES	CASCINABORELLI	385442	4910296	BHNPTV	ARPAPIEMONTE	SPM20	S	575.00	575.00	1988-01-14	17	Nivometrica	578	0101000020F859000000000000888617410000000036BB5241	f	f	575	1988-01-15	\N
002014	900	343	BOCCIOLETO	RONCHI	431070	5076272	HPT	ARPAPIEMONTE	SP200	S	800.00	800.00	1999-11-25	17	Meteorologica	572	0101000020F859000000000000784F1A41000000004C5D5341	f	f	800	1999-11-26	\N
002092	900	345	PETTINENGO	PIAZZO	430102	5051091	PT	ARPAPIEMONTE	SP200	S	725.00	725.00	1999-09-01	17	Meteorologica	845	0101000020F85900000000000058401A41000000C0B4445341	f	f	725	1999-09-02	\N
001289	900	351	VARISELLA	FILIE'	379872	5005760	PT	ARPAPIEMONTE	SP200	S	615.00	615.00	1999-09-02	17	Meteorologica	1008	0101000020F859000000000000802F17410000000070185341	f	f	615	1999-09-03	\N
001145	900	352	MASSELLO	PORTE	347455	4980522	PT	ARPAPIEMONTE	SP200	S	1388.00	1388.00	1999-08-04	17	Meteorologica	779	0101000020F859000000000000FC34154100000080CAFF5241	f	f	1388	1999-08-05	\N
001011	900	353	VACCERA	VACCERA	358034	4970850	PT	ARPAPIEMONTE	SP200	S	1435.00	1435.00	1999-08-05	17	Meteorologica	993	0101000020F85900000000000048DA15410000008058F65241	f	f	1435	1999-08-06	\N
001282	900	349	MALCIAUSSIA	MALCIAUSSIA	354672	5007898	NPT	ARPAPIEMONTE	SP200	S	1800.00	1800.00	2000-06-15	17	Nivometrica	771	0101000020F859000000000000C0A5154100000080861A5341	f	f	1800	2000-06-16	\N
004012	900	354	BARGE	VALLE INFERNOTTO	361481	4954853	PT	ARPAPIEMONTE	SP200	S	961.00	961.00	1999-08-05	17	Meteorologica	554	0101000020F8590000000000002410164100000040B9E65241	f	f	961	1999-08-06	\N
006067	900	334	CALDIROLA	CALDIROLA COLONIA PROVINCIALE	512080	4951835	HPT	ARPAPIEMONTE	SP200	S	1190.00	1190.00	1999-11-23	17	Meteorologica	593	0101000020F85900000000000040411F41000000C0C6E35241	f	f	1190	1999-11-24	\N
002149	901	344	CAMPARIENT	ALPE CAMPARIENT	428882	5064888	NPT	ARPAPIEMONTE	SP200	S	1515.00	1515.00	1999-09-09	17	Nivometrica	599	0101000020F859000000000000482D1A41000000002E525341	f	f	1515	1999-09-10	\N
003034	900	339	CANNOBIO	DEPURATORE CONSORTILE	476204	5101570	PT	ARPAPIEMONTE	SPM20	S	201.00	201.00	1999-11-11	17	Meteorologica	603	0101000020F859000000000000B0101D410000008000765341	f	f	201	1999-11-12	\N
001091	900	347	COLLERETTO	SANTA ELISABETTA	395253	5033160	NPT	ARPAPIEMONTE	SPM20	S	1240.00	1240.00	1999-09-02	17	Nivometrica	669	0101000020F859000000000000D41F18410000000032335341	f	f	1240	1999-09-03	\N
002064	900	S3212	GRAGLIA	SANCARLO	418148	5046913	HNPT	PROVINCIADIBIELLA	SPM20	S	1005.00	1005.00	2002-05-28	17	Nivometrica	726	0101000020F8590000000000009085194100000040A0405341	f	f	1005	2002-05-29	\N
002094	900	S2888	BIELMONTE	BIELMONTE POGGIOBIELLA	428083	5057024	NPT	ARPAPIEMONTE	SPM20	S	1480.00	1480.00	2002-05-29	17	Nivometrica	566	0101000020F859000000000000CC201A4100000000804A5341	f	f	1480	2002-05-31	\N
007010	900	S3362	BIONAZ-PLACEMOULIN	PLACE MOULIN	383099	5084205	NPTR	REGIONEVALLED'AOSTA	SPM20	S	1979.00	1979.00	2002-10-24	VA	Nivometrica	567	0101000020F859000000000000EC611741000000400B655341	f	f	1979	\N	\N
001064	900	S3098	CASTAGNETO PO	CASTAGNETO PO	412336	5000464	PT	ARPAPIEMONTE	SPM20	S	540.00	540.00	2002-05-16	17	Meteorologica	628	0101000020F859000000000000C02A19410000000044135341	f	f	540	2002-05-17	\N
003049	900	S3217	CERANO	CASCINA BAGNO	484546	5029197	PT	ARPAPIEMONTE	SPM20	S	125.00	125.00	2002-09-24	17	Meteorologica	641	0101000020F85900000000000008931D4100000040532F5341	f	f	125	2002-09-26	\N
007017	900	S3389	CHAMPDEPRAZ-CHEVRERE	PARCO DEL MONTE AVIC	392103	5060011	PT	REGIONEVALLED'AOSTA	SPM20	S	1260.00	1260.00	2002-11-29	VA	Meteorologica	648	0101000020F8590000000000009CEE1741000000C06A4D5341	f	f	1260	\N	\N
004144	900	S3215	MOROZZO	CANTATORE	395961	4919317	PT	ARPAPIEMONTE	SPM20	S	440.00	440.00	2002-04-18	17	Meteorologica	809	0101000020F859000000000000E42A18410000004005C45241	f	f	440	2002-04-19	\N
006025	901	S4103	CABELLA LIGURE	PONTE SUL BORBERA	507377	4946916	PT	ARPAPIEMONTE	SPM20	S	480.00	480.00	2006-11-14	17	Meteorologica	591	0101000020F859000000000000C4F71E4100000000F9DE5241	f	f	480	2006-11-16	\N
007064	901	S4496	COLLE GRAND S.BERNARDO	ALPEGGIO BAOU	356688	5081296	NPT	REGIONEVALLED'AOSTA	\N	S	2360.00	2360.00	2007-07-24	VA	Nivometrica	666	0101000020F85900000000000040C515410000000034625341	f	f	2360	\N	\N
007022	901	S2611	COURMAYEUR-PRE'DEBARD	VAL FERRET PRE' DE BARD	349915	5083135	NPT	REGIONEVALLED'AOSTA	SPM20	S	2040.00	2040.00	2001-08-02	VA	Nivometrica	677	0101000020F8590000000000006C5B1541000000C0FF635341	f	f	2040	\N	\N
001114	902	S4669	GRANGE MARTINA	BERGA MARTINA	340922	5002656	HNT	ARPAPIEMONTE	SPM20-RIL	S	1967.00	1967.00	2006-09-19	17	Nivometrica	728	0101000020F859000000000000E8CE14410000000068155341	f	f	1967	2006-09-20	\N
007032	902	S3272	GRESSONEY-L.T.-COURTLYS-T.LYS	ALPE COURT LYS	407521	5080341	IPT	REGIONEVALLED'AOSTA	\N	S	1992.00	1992.00	2004-08-05	VA	Idrometrica	732	0101000020F85900000000000084DF18410000004045615341	f	f	1992	\N	\N
006038	900	S4109	LAVAGNINA LAGO	DIGA LAVAGNINA	480616	4939369	PT	ARPAPIEMONTE	SPM20	S	356.00	356.00	2006-11-14	17	Meteorologica	755	0101000020F859000000000000A0551D41000000409AD75241	f	f	356	2006-11-16	\N
003086	906	S4895	MACUGNAGA RIFUGIO ZAMBONI	RIFUGIO ZAMBONI	416151	5089413	BHNPRT	ARPAPIEMONTE	SPM20	S	2075.00	2075.00	2007-07-05	17	Nivometrica	770	0101000020F8590000000000005C66194100000040216A5341	f	f	2075	2007-07-26	\N
003103	900	S3218	NEBBIUNO	MONTE CORNAGGIA	461722	5075088	GPT	ARPAPIEMONTE	SPM20	S	865.00	865.00	2002-07-19	17	Meteorologica	814	0101000020F859000000000000682E1C4100000000245C5341	f	f	865	2002-07-20	\N
003110	900	S4114	OMEGNA LAGO D'ORTA	MOLO DEL LAGO D'ORTA	454220	5080460	IPT	ARPAPIEMONTE	SPM20	S	292.00	292.00	2007-02-27	17	Idrometrica	824	0101000020F85900000000000030B91B410000000063615341	f	f	292	2007-03-01	\N
003114	900	S4115	PARUZZARO	PIAZZA MUNICIPIO 1	462140	5066473	PT	ARPAPIEMONTE	SPM20	S	332.00	332.00	2007-01-23	17	Meteorologica	838	0101000020F859000000000000F0341C4100000040BA535341	f	f	332	2007-01-25	\N
007062	900	S2947	ST-OYEN-MOULIN-T.ARTANAVAZ	MOULIN DI SAINT-OYEN	360932	5075905	IT	REGIONEVALLED'AOSTA	\N	S	1310.00	1310.00	2004-08-04	VA	Idrometrica	962	0101000020F8590000000000009007164100000040F05C5341	f	f	1310	\N	\N
007064	900	S2612	ST.RHEMY-CREVACOLARPDEJEUX	CREVACOL ARPDEJEUX	356850	5076908	NPT	REGIONEVALLED'AOSTA	SPM20	S	2018.00	2018.00	2001-09-19	VA	Nivometrica	963	0101000020F859000000000000C8C7154100000000EB5D5341	f	f	2018	\N	\N
033043	900	F3266	BOBBIANO	MONTICELLO DI BOBBIANO	538855	4969953	P	REGIONEEMILIAROMAGNA	\N	N	567.00	567.00	2003-11-12	EM	Meteorologica	568	0101000020F859000000000000CE7120410000004078F55241	f	f	567	\N	\N
010062	900	F2075	DIGA DEL BRUGNETO	DIGA DEL BRUGNETO	516556	4930329	PT	REGIONELIGURIA	\N	N	777.00	777.00	2003-11-12	RL	Meteorologica	689	0101000020F85900000000000030871F4100000040C6CE5241	f	f	777	\N	\N
033019	901	F4525	GROPPALLO	SANTUARIO DI GROPPALLO	547380	4949496	P	REGIONEEMILIAROMAGNAUFFICIOREGIONALE	\N	N	995.00	995.00	2007-03-15	EM	Meteorologica	735	0101000020F85900000000000068B42041000000007EE15241	f	f	995	\N	\N
001219	900	S3948	RIVOLI LA PEROSA	LA PEROSA	381938	4993117	PTV	SITAFS.P.A.	SPM20	S	362.00	362.00	2004-07-13	17	Meteorologica	908	0101000020F8590000E200F9B2EE51174198C2B063320C5341	f	f	362	2004-07-14	\N
033028	900	F2933	SAN MICHELE	SAN MICHELE	556148	4956904	PT	REGIONEEMILIAROMAGNA	\N	N	670.00	670.00	2003-11-12	EM	Meteorologica	938	0101000020F859000000000000E8F8204100000000BAE85241	f	f	670	\N	\N
010056	900	F612	SANTO STEFANO D'AVETO	SANTO STEFANOD'AVETO	535529	4932287	PT	REGIONELIGURIA	\N	N	1322.00	1322.00	2003-11-12	RL	Meteorologica	944	0101000020F859000000000000D2572041000000C0AFD05241	f	f	1322	\N	\N
001022	907	S5612	SOMMEILLER	COLLE SOMMEILLER	330443	5000033	HNT	ARPAPIEMONTE	SPM20	S	2981.00	2981.00	2009-09-22	17	Nivometrica	958	0101000020F8590000000000002C2B144100000040D8125341	f	f	2981	\N	\N
033028	901	F3355	TERUZZI	I LONGHI DI TERUZZI	554255	4949358	BHPRTV	REGIONE LOMBARDIA	\N	N	1110.00	1110.00	2003-11-12	EM	Meteorologica	970	0101000020F8590000B63C36FD79EA2041E7C0AD005AE15241	f	f	1110	\N	\N
001272	906	S3447	TORINO VIA DELLA CONSOLATA	VIA DELLA CONSOLATA 10	396054	4992433	HPRTV	ARPAPIEMONTE	SPM20	S	290.00	290.00	2003-12-18	17	Meteorologica	981	0101000020F8590000BEB8F102F52B1841C014FC3B640B5341	f	f	290	2003-12-19	\N
004249	900	S3949	VIOLA	MADONNA DELLA NEVE	416610	4904372	HPT	ARPAPIEMONTE	SPM20	S	1050.00	1050.00	2004-05-19	17	Meteorologica	1027	0101000020F859000000000000886D1941000000006DB55241	f	f	1050	2004-05-20	\N
003002	900	S4113	MONTE MESMA	MONTE MESMA	456546	5069173	PT	ARPAPIEMONTE	SPM20	S	540.00	540.00	2006-06-06	17	Meteorologica	800	0101000020F85900000000000088DD1B41000000405D565341	f	f	540	2006-08-11	\N
003106	900	S4193	NOVARA	VIA CELLE BECCARI	471388	5032237	BGHPRTV	ARPAPIEMONTE	SPM20	S	151.00	151.00	2005-04-06	17	Meteorologica	819	0101000020F85900000000000070C51C41000000404B325341	f	f	151	2005-04-08	\N
004157	901	S4151	PAESANA ERASCA	SS26 KM20+600	362475	4949299	PT	PROVINCIADICUNEO	SPM20	S	638.00	638.00	2005-04-21	17	Meteorologica	830	0101000020F859000000000000AC1F1641000000C04CE15241	f	f	638	2008-01-01	\N
007052	900	S3363	PONT-ST-MARTIN-CIRCONVALLAZIONE-LYS	PONT ST.MARTIN	406151	5050032	I	REGIONEVALLED'AOSTA	SPM20	S	330.00	330.00	2003-08-06	VA	Idrometrica	867	0101000020F8590000000000001CCA184100000000AC435341	f	f	330	\N	\N
007053	901	S2949	PRE-ST-DIDIER-DORA LA THUILLE	PRE' ST.DIDIER	343841	5069871	IPT	REGIONEVALLED'AOSTA	\N	S	1000.00	1014.00	2004-08-04	VA	Idrometrica	889	0101000020F85900000000000084FC1441000000C00B575341	f	f	1014	\N	\N
001134	902	S4119	ROSONE	CENTRALE IDROELETTRICA	376375	5032521	NPT	ARPAPIEMONTE	SPM20	S	701.00	701.00	2005-05-11	17	Nivometrica	920	0101000020F859000000000000DCF816410000004092325341	f	f	701	2005-05-15	\N
018110	900	F614	PAVIA	PAVIA	511894	5003761	IPT	REGIONELOMBARDIA	\N	N	77.00	77.00	2003-11-12	LO	Idrometrica	841	0101000020F8590000F284707AE0391F41E4F6AE72FC155341	f	f	77	\N	\N
006022	901	S6159	BRIC CASTELLARO	BRIC CASTELLARO	483451	4943500	BNPTV	COMUNITA'MONTANAALTAVALDILEMME	SPM20	S	415.00	415.00	2010-08-04	17	Nivometrica	582	0101000020F859000000000000EC811D4100000000A3DB5241	f	f	415	2010-08-04	\N
007021	903	S4295	COGNE GRAND CROT	GRAND CROT	372945	5049915	NPTV	REGIONEVALLED'AOSTA	\N	S	2279.00	2279.00	2006-12-07	VA	Nivometrica	659	0101000020F85900000000000044C31641000000C08E435341	f	f	2279	\N	\N
001118	900	253	FORNO ALPI GRAIE	FORNO ALPI GRAIE	361004	5024732	NPT	ARPAPIEMONTE	SP200	S	1215.00	1215.00	1996-10-12	17	Nivometrica	709	0101000020F859000000000000B008164100000000F72A5341	f	f	1215	1996-10-12	\N
007041	901	S1847	LATHUILE-LAGRANTETE	PLAN DEL SUCHE	337727	5061120	BHNPRTV	REGIONEVALLED'AOSTA	SPM20	S	2430.00	2430.00	1997-09-26	VA	Nivometrica	746	0101000020F859000000000000FC9C144100000000804E5341	f	f	2430	\N	\N
001232	901	019	LESELLE	GRAN BOSCO DI SALBERTRAND-LE SELLE	336091	4991300	BHNPRTV	SITAFS.P.A.	SP300	S	1980.00	1980.00	1991-07-26	17	Nivometrica	757	0101000020F8590000000000006C83144100000000510A5341	f	f	1980	1991-07-26	\N
009055	900	305	SASSELLO	SASSELLO CAMPO SPORTIVO	459016	4924790	PT	REGIONELIGURIA	SP200	S	385.00	385.00	2001-02-15	RL	Meteorologica	946	0101000020F85900000000000020041C41000000805DC95241	f	f	385	2001-10-01	\N
003053	900	340	CICOGNA	CICOGNA	460716	5094778	PT	ARPAPIEMONTE	SP200	S	696.00	696.00	1999-11-12	17	Meteorologica	656	0101000020F859000000000000B01E1C41000000805E6F5341	f	f	696	1999-11-13	\N
004213	900	S6521	SANTO STEFANO BELBO	PONTE SP592	440454	4951389	I	PROVINCIA DI ASTI	SPM20	S	167.00	167.00	2013-07-29	17	Idrometrica	1031	0101000020F8590000B358B71E17E21A416BAC7B5955E35241	f	f	167	\N	\N
006001	900	101	ACQUI TERME	STRADA PIAN D'ENDICE	458845	4947584	BHPRT	ARPAPIEMONTE	SPM20	S	215.00	215.00	1988-01-26	17	Meteorologica	518	0101000020F85900000000000074011C4100000000A0DF5241	f	f	215	1988-01-27	\N
002147	900	S2564	TRICERRO	TRICERRO	447480	5009461	GPT	ARPAPIEMONTE	SPM20	S	139.00	139.00	2000-12-11	17	Meteorologica	989	0101000020F859000000000000E04F1B41000000400D1C5341	f	f	139	2001-10-01	\N
003145	900	S2565	ARVOGNO	ARVOGNO	458123	5113049	PT	ARPAPIEMONTE	SPM20	S	1240.00	1240.00	2001-09-20	17	Meteorologica	539	0101000020F8590000000000002CF61B410000004036815341	f	f	1240	2001-10-01	\N
001296	900	S2567	VIALFRE'	VIALFRE'	407466	5026023	PT	ARPAPIEMONTE	SPM20	S	459.00	459.00	2000-12-11	17	Meteorologica	1017	0101000020F859000000000000A8DE1841000000C0392C5341	f	f	459	2001-10-01	\N
002012	901	S2566	BIELLA	BIELLA-VIA DON STURZO 20 ASL12	426445	5045652	GPRT	ARPAPIEMONTE	SPM20	S	405.00	405.00	2000-12-13	17	Meteorologica	565	0101000020F85900000000000034071A4100000000653F5341	f	f	405	2001-10-01	\N
009015	900	399	CAIRO MONTENOTTE	PASSERELLA G.MILANO	442673	4915502	PT	REGIONELIGURIA	SPM20	S	388.00	388.00	2001-09-20	RL	Meteorologica	592	0101000020F859000000000000C4041B41000000804BC05241	f	f	388	2001-10-01	\N
033016	900	F3356	PERINO	PERINO	539416	4964310	P	REGIONEEMILIAROMAGNA	\N	N	250.00	250.00	2003-11-12	EM	Meteorologica	842	0101000020F8590000000000003076204100000080F5EF5241	f	f	250	\N	\N
004050	900	246	CASTELLETTO UZZONE	CASTELLETTO UZZONE	435529	4927156	PT	ARPAPIEMONTE	SPM20	S	423.00	423.00	2001-05-11	17	Meteorologica	633	0101000020F85900000000000024951A4100000000ADCB5241	f	f	423	2001-05-27	\N
007032	900	394	GRESSONEY-L.T.-ESELBODE	LA TRINITE'	408890	5076090	NPT	REGIONEVALLED'AOSTA	SPM20	S	1642.00	1642.00	2001-09-19	VA	Nivometrica	730	0101000020F859000000000000E8F41841000000801E5D5341	f	f	1642	\N	\N
003156	902	S4124	UNCHIO TROBASO	UNCHIO	463782	5089947	PT	ARPAPIEMONTE	SPM20	S	302.00	302.00	2006-08-01	17	Meteorologica	991	0101000020F859000000000000984E1C41000000C0A66A5341	f	f	302	2006-08-02	\N
009036	900	S2588	MALLARE	DEPURATORE COMUNALE-VIA AL PONTE	444192	4904195	PT	REGIONELIGURIA	SPM20	S	467.00	467.00	2002-02-27	RL	Meteorologica	772	0101000020F859000000000000801C1B41000000C040B55241	f	f	467	2002-02-27	\N
009055	901	S2047	PIAMPALUDO	BUSCHIAZZI PIAMPALUDO	466585	4922864	PT	REGIONELIGURIA	SPM20	S	882.00	882.00	2001-05-29	RL	Meteorologica	847	0101000020F859000000000000647A1C41000000007CC75241	f	f	882	2001-10-01	\N
006034	900	S2562	PIANI DI CARREGA	PIANI DI CARREGA	514956	4940241	GNPT	ARPAPIEMONTE	SPM20	S	1245.00	1245.00	2001-05-30	17	Nivometrica	853	0101000020F859000000000000306E1F410000004074D85241	f	f	1245	2001-10-01	\N
004163	900	S3099	PRADEBONI	TETTI GALLINA	391476	4906152	PT	ARPAPIEMONTE	SPM20	S	985.00	985.00	2002-04-18	17	Meteorologica	881	0101000020F859000000000000D0E41741000000002AB75241	f	f	985	2002-04-19	\N
004099	900	280	GOVONE	CASCINA CANOVA	429922	4959859	PTW	SATAPS.P.A.	SP200	S	310.00	310.00	2001-05-15	17	MeteorologicaW	725	0101000020F859000000000000883D1A41000000C09CEB5241	f	f	310	2001-05-16	\N
001201	902	095	PRAGELATO-TRAMPOLINO A VALLE	PRAGELATO-TRAMPOLINO A VALLE	337847	4986187	HNPTV	ARPAPIEMONTE	SPM20	S	1525.00	1525.00	2000-12-20	17	Nivometrica	883	0101000020F859000000000000DC9E1441000000C052055341	f	f	1525	2000-12-20	\N
003124	900	S2575	PREMIA	SAN ROCCO	451503	5128211	PT	ARPAPIEMONTE	SPM20	S	755.00	755.00	2001-06-11	17	Meteorologica	891	0101000020F859000000000000BC8E1B41000000C004905341	f	f	755	2001-10-01	\N
005094	900	244	ROCCAVERANO	REGIONE CARAMELLO-BRIC DEGLI OLMI	444625	4940132	PT	ARPAPIEMONTE	SP200	S	640.00	640.00	2001-05-11	17	Meteorologica	913	0101000020F85900000000000044231B410000000059D85241	f	f	640	2001-05-27	\N
001272	904	249	TORINO VALLERE	VALLERE SMAT	395596	4985890	HPRT	ITALGASS.P.A.	SP200	S	239.00	239.00	2001-05-17	17	Meteorologica	980	0101000020F8590000D5509DA116251841F727A25209055341	f	f	239	2001-05-18	\N
004203	900	S2583	SALUZZO	SANLORENZO	379371	4943428	PT	ARPAPIEMONTE	SPM20	S	535.00	535.00	2001-01-18	17	Meteorologica	930	0101000020F859000000000000AC2717410000000091DB5241	f	f	535	2001-10-01	\N
001267	900	S2584	SPARONE	BISDONIO	386141	5029706	BPT	ARPAPIEMONTE	SPM20	S	550.00	550.00	2001-04-18	17	Meteorologica	960	0101000020F8590000000000007491174100000080D22F5341	f	f	550	2001-10-01	\N
018064	900	F1805	FORTUNAGO	POLINAGO	515392	4973619	PT	REGIONELOMBARDIA	\N	N	483.00	483.00	2003-11-12	LO	Meteorologica	710	0101000020F85900000000000000751F41000000C00CF95241	f	f	483	\N	\N
018142	900	F1816	CASANOVA	CASANOVA	519209	4958571	PT	REGIONELOMBARDIA	\N	N	757.00	757.00	2003-11-12	LO	Meteorologica	621	0101000020F85900004B6E30E28CAD1F41B6749AA738E95241	f	f	757	\N	\N
012092	900	F2019	LUINO	MOLODILUINO	480211	5094145	IPT	REGIONELOMBARDIA	SPM20	N	230.00	230.00	2003-11-12	LO	Idrometrica	766	0101000020F8590000000000004C4F1D4100000040C06E5341	f	f	230	\N	\N
012062	900	F2058	CUVEGLIO	CUVEGLIO	480051	5084732	PT	REGIONELOMBARDIA	\N	N	310.00	310.00	2003-11-12	LO	Meteorologica	687	0101000020F859000000000000CC4C1D41000000008F655341	f	f	310	\N	\N
018177	900	F2062	VIGEVANO	VIGEVANO	490641	5020699	IPT	REGIONELOMBARDIA	SPM20	N	111.00	111.00	2003-11-12	LO	Idrometrica	1018	0101000020F859000081F03BD555F21D41BBD5FB295D275341	f	f	111	\N	\N
018083	900	F2953	LOMELLO	LOMELLO	484116	4996240	IPT	REGIONELOMBARDIA	\N	N	98.00	98.00	2003-11-12	LO	Idrometrica	764	0101000020F85900002CA575F81D8F1D4104BACE3ECC0F5341	f	f	98	\N	\N
018182	900	F2978	VOGHERA	VOGHERA	501379	4983012	IPT	REGIONELOMBARDIA	\N	N	103.00	103.00	2003-11-12	LO	Idrometrica	1029	0101000020F8590000000000000C9A1E410000000039025341	f	f	103	\N	\N
018128	900	F3335	ROMAGNESE	ROMAGNESE	526365	4966125	P	REGIONELOMBARDIA	\N	N	589.00	589.00	2003-11-12	LO	Meteorologica	919	0101000020F8590000000000003A10204100000040BBF15241	f	f	589	\N	\N
033020	900	F613	FERRIERE PLUVIO	FERRIERE	539653	4943605	P	REGIONEEMILIAROMAGNA	\N	N	801.00	801.00	2003-11-12	EM	Meteorologica	703	0101000020F8590000000000000A78204100000040BDDB5241	f	f	801	\N	\N
033033	900	F2090	PIANELLO VAL TIDONE	COSTALANDA	531772	4973679	PT	REGIONEEMILIAROMAGNA	\N	N	400.00	400.00	2003-11-12	EM	Meteorologica	852	0101000020F859000000000000783A2041000000C01BF95241	f	f	400	\N	\N
033020	901	F2921	SELVA FERRIERE	SELVA	538298	4937950	PT	REGIONEEMILIAROMAGNA	\N	N	1135.00	1135.00	2003-11-12	EM	Meteorologica	948	0101000020F859000000000000746D20410000008037D65241	f	f	1135	\N	\N
033020	902	F2923	CASSIMORENO	CASSIMORENO	545953	4943647	PT	REGIONEEMILIAROMAGNA	\N	N	885.00	885.00	2003-11-12	EM	Meteorologica	626	0101000020F85900000000000042A92041000000C0C7DB5241	f	f	885	\N	\N
001094	901	428	CORIO	CORIO	386008	5018529	P	ARPAPIEMONTE	SPM20	S	562.00	562.00	1996-05-28	17	Meteorologica	670	0101000020F859000000000000608F174100000040E8245341	f	f	562	2001-01-01	\N
006114	900	225	NOVI LIGURE	DEPURATORE	480884	4959362	PT	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	162.00	162.00	1998-02-24	17	Meteorologica	821	0101000020F859000000000000D0591D410000008020EB5241	f	f	162	1998-02-25	\N
012003	900	F2020	ANGERA	PIAZZA GARIBALDI	467283	5069724	P	REGIONELOMBARDIA	\N	N	262.00	262.00	2003-11-12	LO	Meteorologica	533	0101000020F8590000000000004C851C4100000000E7565341	f	f	262	\N	\N
012004	900	F2061	ARCISATE	CONTRADA LOGACCIO	491502	5077175	PT	REGIONELOMBARDIA	\N	N	370.00	370.00	2003-11-12	LO	Meteorologica	535	0101000020F859000000000000B8FF1D41000000C02D5E5341	f	f	370	\N	\N
001026	901	S2586	BOBBIO PELLICE	SERRE DELLA SARSENA'	351091	4964711	PT	ARPAPIEMONTE	SPM20	S	1312.00	1312.00	2001-09-03	17	Meteorologica	569	0101000020F859000000000000CC6D1541000000C059F05241	f	f	1312	2001-10-01	\N
012026	900	F2965	BUSTO ARSIZIO	SCUOLE ELEMENTARI	486271	5052710	PT	REGIONELOMBARDIA	SPM20	N	242.00	242.00	2003-11-12	LO	Meteorologica	588	0101000020F859000000000000FCAD1D410000008049465341	f	f	242	\N	\N
001047	900	S2573	CALUSO	CABINA ITALGAS-SP85 KM2.5	409921	5015808	NPTV	ARPAPIEMONTE	SPM20	S	257.00	257.00	2001-04-19	17	Nivometrica	596	0101000020F859000000000000040519410000000040225341	f	f	257	2001-10-01	\N
001155	900	S2569	CHIAVES	CHIAVES MENULLA	375704	5021638	PT	ARPAPIEMONTE	SPM20	S	1617.00	1617.00	2001-04-19	17	Meteorologica	653	0101000020F85900000000000060EE164100000080F1275341	f	f	1617	2001-10-01	\N
004079	902	S2571	DEMONTE	DEMONTE-AZIENDA IMALPI	365481	4908591	PT	ARPAPIEMONTE	SPM20	S	765.00	765.00	2001-05-17	17	Meteorologica	688	0101000020F859000000000000A44E1641000000C08BB95241	f	f	765	2001-10-01	\N
004082	900	342	DRONERO	PRATAVECCHIA	373632	4923430	PT	ARPAPIEMONTE	SP200	S	575.00	575.00	1999-07-14	17	Meteorologica	695	0101000020F85900000000000000CE16410000008009C85241	f	f	575	1999-07-15	\N
004084	901	295	DIGA LA PIASTRA	DIGA LA PIASTRA	371391	4898519	PT	ARPAPIEMONTE	SP200	S	950.00	950.00	2001-01-17	17	Meteorologica	691	0101000020F859000000000000FCAA1641000000C0B5AF5241	f	f	950	2001-10-01	\N
015146	901	F2121	MILANO	PROTEZIONE CIVILE	519541	5035782	P	REGIONELOMBARDIA	SPM20	N	122.00	122.00	2003-11-12	LO	Meteorologica	783	0101000020F859000000000000D4B51F4100000080C1355341	f	f	122	\N	\N
004077	901	S2580	PIAN GIASSET	PIAN GIASSET	351790	4950356	NPT	ARPAPIEMONTE	SPM20	S	2150.00	2150.00	2001-09-20	17	Nivometrica	850	0101000020F859000000000000B87815410000000055E25241	f	f	2150	2001-10-01	\N
002111	900	S2581	RIMA	PONTE DELLE QUARE	423210	5081369	PT	ARPAPIEMONTE	SPM20	S	1289.00	1289.00	2001-06-14	17	Meteorologica	906	0101000020F859000000000000A8D419410000004046625341	f	f	1289	2001-10-01	\N
001074	901	S2619	SAN SICARIO	SAN SICARIO SOLEIL BOEUF	329444	4981815	HNPTV	ARPAPIEMONTE	SPM20	S	2087.00	2087.00	2001-08-28	17	Nivometrica	941	0101000020F859000000000000901B1441000000C00D015341	f	f	2087	2001-10-02	\N
033020	903	F2938	SALSOMINORE	RUFFINATI	532383	4943565	IPT	REGIONEEMILIAROMAGNA	\N	N	421.00	421.00	2003-11-12	EM	Idrometrica	929	0101000020F8590000EBE1E8BE043E2041E29CB30B98DA5241	f	f	421	\N	\N
003154	900	S2585	VARALLO POMBIA	VARALLO POMBIA	471170	5058127	PT	ARPAPIEMONTE	SPM20	S	268.00	268.00	2000-12-11	17	Meteorologica	1006	0101000020F85900000000000008C21C41000000C0934B5341	f	f	268	2001-10-10	\N
012133	900	F2977	VARESE	VIA APPIANI ANDREA 15	486299	5075301	PT	REGIONELOMBARDIA	\N	N	404.00	404.00	2003-11-12	LO	Meteorologica	1007	0101000020F8590000000000006CAE1D4100000040595C5341	f	f	404	\N	\N
018171	900	F1804	VARZI	VIA MAZZINI	515657	4964208	PT	REGIONELOMBARDIA	SPM20	N	410.00	410.00	2003-11-12	LO	Meteorologica	1009	0101000020F85900000000000024791F4100000000DCEF5241	f	f	410	\N	\N
001036	900	241	CAVALLARIA	CAVALLARIA	407006	5041287	PT	CITTA'DIBORGOFRANCOD'IVREA	SP200	S	1270.00	1270.00	1997-11-04	17	Meteorologica	638	0101000020F85900000000000078D71841000000C0213B5341	f	f	1270	1998-02-04	\N
001030	900	113	BORGOFRANCO D'IVREA	MONTEBUONO	410087	5040929	BGHPTV	ARPAPIEMONTE	SPM20	S	337.00	337.00	1988-05-05	17	Meteorologica	574	0101000020F8590000000000009C07194100000040C83A5341	f	f	337	1988-05-05	\N
003020	900	157	PIZZANCO	PIZZANCO	436556	5108355	HPT	ARPAPIEMONTE	SP200	S	1142.00	1142.00	1991-10-31	17	Meteorologica	862	0101000020F85900000000000030A51A41000000C0A07C5341	f	f	1142	1991-11-01	\N
006174	900	217	CASTELLAR PONZANO	CASTELLARPONZANO	487962	4963974	BHPRTV	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	146.00	146.00	1998-04-09	17	Meteorologica	632	0101000020F85900000000000068C81D4100000080A1EF5241	f	f	146	1998-04-10	\N
001278	900	240	TRAVERSELLA	SUCCINTO	399204	5042642	PT	ARPAPIEMONTE	SP200	S	1165.00	1165.00	1996-10-09	17	Meteorologica	987	0101000020F859000000000000905D184100000080743C5341	f	f	1165	1996-10-09	\N
001202	900	264	PRALY	VILLA	346730	4974411	HNPT	ARPAPIEMONTE	SPM20	S	1385.00	1385.00	1993-07-27	17	Nivometrica	885	0101000020F859000000000000A8291541000000C0D2F95241	f	f	1385	1993-07-27	\N
001128	900	111	LANZO	FUA	381885	5016336	HPT	ARPAPIEMONTE	SPM20	S	580.00	580.00	1989-08-24	17	Meteorologica	752	0101000020F859000000000000F44E174100000000C4225341	f	f	580	1989-08-24	\N
004248	901	126	NERAISSA	NERAISSA	352702	4909786	HPT	ARPAPIEMONTE	SP200	S	1433.00	1433.00	1989-06-15	17	Meteorologica	815	0101000020F859000000000000F886154100000080B6BA5241	f	f	1433	1989-06-16	\N
001032	900	143	BORGONE	PONTEDORA	361958	4997582	HPRTV	SITAFS.P.A.	SP300	S	400.00	400.00	1991-01-10	17	Meteorologica	576	0101000020F859000000000000981716410000008073105341	f	f	400	1991-01-10	\N
003142	901	326	SOMERARO	SOMERARO	462213	5082028	HPT	AUTOSTRADES.P.A.	SP200	S	425.00	425.00	1990-07-26	17	Meteorologica	957	0101000020F85900000000000014361C4100000000EB625341	f	f	425	1990-07-26	\N
006039	900	119	CASALE MONFERRATO	ISTITUTO DI PIOPPICOLTURA	461092	4997958	BHPRTV	ARPAPIEMONTE	SPM20	S	136.00	118.00	1988-05-20	17	Meteorologica	619	0101000020F85900000000000090241C4100000080D1105341	f	f	118	1988-05-21	\N
004068	900	307	CHIUSA PESIO	MADONNA D'ARDUA	393085	4898867	PT	ARPAPIEMONTE	SPM20	S	935.00	935.00	1996-09-18	17	Meteorologica	654	0101000020F859000000000000F4FD1741000000C00CB05241	f	f	935	1996-09-19	\N
001097	900	109	CUMIANA	PIEVE-SCUOLE COMUNALI	373174	4980375	BHPRTV	ARPAPIEMONTE	SPM20	S	327.00	327.00	1988-01-27	17	Meteorologica	683	0101000020F859000000000000D8C61641000000C0A5FF5241	f	f	327	1988-01-27	\N
001201	900	261	CLOT DELLA SOMA	CLOT DELLA SOMA	337795	4983288	HNPRTVY	ARPAPIEMONTE	SPM20	S	2150.00	2150.00	1996-10-23	17	Nivometrica	657	0101000020F8590000000000000C9E1441000000007E025341	f	f	2150	1996-10-24	\N
003061	900	117	DOMODOSSOLA	NOSERE-DEPURATORE COMUNALE	446156	5105927	BGHPRTV	ARPAPIEMONTE	SPM20	S	252.00	252.00	1988-05-04	17	Meteorologica	693	0101000020F859000000000000303B1B41000000C0417A5341	f	f	252	1988-05-05	\N
003020	901	642	LAGO PAIONE	LAGO PAIONE SUPERIORE	437588	5114118	HPRTV	ARPAPIEMONTE	SPM20	S	2269.00	2269.00	1996-06-15	17	Meteorologica	750	0101000020F85900000000000050B51A410000008041825341	f	f	2269	2000-01-01	\N
004115	900	319	MANGO	CASCINA FONDA	432530	4951081	HPT	ARPAPIEMONTE	SP200	S	425.00	425.00	1995-11-17	17	Meteorologica	773	0101000020F85900000000000048661A41000000400AE35241	f	f	425	1995-11-17	\N
002075	900	201	MASSERANO	CASCINA BARAGGIA	441949	5045398	BHPT	ARPAPIEMONTE	SPM20	S	243.00	243.00	1990-11-20	17	Meteorologica	780	0101000020F85900000000000074F91A4100000080253F5341	f	f	243	1990-11-20	\N
004130	900	315	MONDOVI'	ISTITUTO AGRARIO	405350	4916698	HPT	ARPAPIEMONTE	SPM20	S	422.00	422.00	1993-07-13	17	Meteorologica	793	0101000020F85900000000000098BD18410000008076C15241	f	f	422	1993-07-13	\N
001263	902	108	MONTE FRAITEVE	MONTE FRAITEVE	331440	4982806	BHTV	ARPAPIEMONTE	SPM20	S	2701.00	2701.00	1988-11-18	17	Meteorologica	798	0101000020F859000000000000C03A14410000008005025341	f	f	2701	1988-12-30	\N
004157	900	277	PAESANA	BRIC BARSAIA	362370	4947015	HNPT	ARPAPIEMONTE	SP200	S	1265.00	1265.00	1993-05-12	17	Nivometrica	829	0101000020F859000000000000081E1641000000C011DF5241	f	f	1265	1993-05-12	\N
001019	900	004	RIFUGIO GASTALDI	RIFUGIO GASTALDI	354502	5017939	NPTV	ARPAPIEMONTE	SPM20	S	2659.00	2659.00	1987-09-25	17	Nivometrica	902	0101000020F859000017BCA36146A3154113C48B7352245341	f	f	2659	1987-09-26	\N
004190	900	309	RIFUGIO MONDOVI'	RIFUGIO HAWIS DE GIORGIO MONDOVI'	398757	4894142	HNPTV	ARPAPIEMONTE	SPM20	S	1760.00	1760.00	1997-10-15	17	Nivometrica	903	0101000020F85900000000000094561841000000806FAB5241	f	f	1760	1997-10-16	\N
006157	900	229	SARDIGLIANO	CAMPO SPORTIVO	492695	4956060	BHPRTV	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	320.00	320.00	1998-07-10	17	Meteorologica	945	0101000020F8590000000000005C121E4100000000E7E75241	f	f	320	1998-07-11	\N
001258	900	158	SAUZE CESANA	VALLE ARGENTERA	335756	4973540	NPT	SITAFS.P.A.	SP200	S	1840.00	1840.00	1998-10-07	17	Nivometrica	947	0101000020F859000000000000307E144100000000F9F85241	f	f	1840	1998-10-08	\N
004230	900	320	TREISO	CASCINA MONTARSINO	427326	4947726	BHPRT	ARPAPIEMONTE	SPM20	S	376.00	376.00	1990-11-23	17	Meteorologica	988	0101000020F859000000000000F8141A4100000080C3DF5241	f	f	376	1990-11-23	\N
002149	900	189	TRIVERO	CASCINA PILOTA	433695	5058489	P	ARPAPIEMONTE	SP200	S	1108.00	1108.00	1996-11-08	17	Meteorologica	990	0101000020F8590000000000007C781A4100000040EE4B5341	f	f	1108	1996-11-08	\N
004246	900	281	VILLANOVA SOLARO	BEALERA DEL MULINO-DEPURATORE COMUNALE	386845	4954671	HPRTV	ARPAPIEMONTE	SPM20	S	267.00	267.00	1993-07-21	17	Meteorologica	1024	0101000020F859000000000000749C1741000000C08BE65241	f	f	267	1993-07-21	\N
003067	901	336	FORMAZZA BRUGGI	BRUGGI	456129	5133034	GHNPT	ARPAPIEMONTE	SPM20	S	1226.00	1226.00	1999-09-09	17	Nivometrica	708	0101000020F85900000000000004D71B4100000080BA945341	f	f	1226	1999-09-10	\N
003086	901	338	MACUGNAGA PECETTO	PECETTO	419334	5091685	NPT	ARPAPIEMONTE	SP200	S	1360.00	1360.00	1999-11-10	17	Nivometrica	769	0101000020F8590000000000001898194100000040596C5341	f	f	1360	1999-11-11	\N
003101	901	337	LARECCHIO	DIGA DI LARECCHIO	456225	5117160	HNPTV	ARPAPIEMONTE	SP200	S	1860.00	1860.00	1999-09-10	17	Nivometrica	754	0101000020F85900000000000084D81B41000000003A855341	f	f	1860	1999-09-11	\N
003147	900	361	MONTE CARZA	MONTE CARZA	475300	5099029	PT	ARPAPIEMONTE	SPM20	S	1110.00	1110.00	1999-11-12	17	Meteorologica	797	0101000020F85900000000000090021D410000004085735341	f	f	1110	1999-11-13	\N
001313	900	350	NIQUIDETTO	NIQUIDETTO MUANDEFRESTE	371184	5006333	PT	ARPAPIEMONTE	SP200	S	1416.00	1416.00	1999-09-03	17	Meteorologica	816	0101000020F859000000000000C0A7164100000040FF185341	f	f	1416	1999-09-04	\N
004031	901	360	PIAGGIA	PIAGGIA PIAN DEL GUSO	398488	4880823	NPT	ARPAPIEMONTE	SP200	S	1645.00	1645.00	1999-09-01	17	Nivometrica	846	0101000020F85900000000000060521841000000C06D9E5241	f	f	1645	1999-09-02	\N
004079	901	358	S.GIACOMO DEMONTE	SAN GIACOMO DI DEMONTE	356860	4912030	PT	ARPAPIEMONTE	SP200	S	1297.00	1297.00	1999-09-02	17	Meteorologica	925	0101000020F859000000000000F0C7154100000080E7BC5241	f	f	1297	1999-09-03	\N
004248	902	359	VINADIO S.BERNOLFO	SAN BERNOLFO	343935	4902986	PT	ARPAPIEMONTE	SP200	S	1695.00	1695.00	1999-09-02	17	Meteorologica	1025	0101000020F859000000000000FCFD14410000008012B45241	f	f	1695	1999-09-03	\N
007008	900	S3367	AYMAVILLES-VIEYES	VIEYES	363786	5056816	PT	REGIONEVALLED'AOSTA	SPM20	S	1139.00	1139.00	2003-06-25	VA	Meteorologica	545	0101000020F85900000000000028341641000000004C4A5341	f	f	1139	\N	\N
007071	900	S3478	VALTOURNENCHE-CIMEBIANCHE	COLLECIMEBIANCHE	398610	5085987	BTV	REGIONEVALLED'AOSTA	SPM20	S	3100.00	3100.00	2003-08-05	VA	Meteorologica	1002	0101000020F85900000000000048541841000000C0C8665341	f	f	3100	\N	\N
002002	902	S2897	CAPANNA MARGHERITA	MONTEROSA	413013	5086763	BRTV	ARPAPIEMONTE	SPM20	S	4560.00	4560.00	2002-08-29	17	Meteorologica	607	0101000020F85900000000000054351941000000C08A675341	f	f	4560	2002-08-31	\N
007032	901	S3369	GRESSONEY-L.T.-GABIET	GABIET	410705	5078465	HNPTR	REGIONEVALLED'AOSTA	SPM20	S	2379.00	2379.00	2002-10-25	VA	Nivometrica	733	0101000020F8590000000000004411194100000040705F5341	f	f	2379	\N	\N
007033	901	S3364	GRESSONEY-S.J.-WEISSMATTEN	WEISSMATTEN	408692	5066969	NPTV	REGIONEVALLED'AOSTA	SPM20	S	2038.00	2038.00	2002-11-08	VA	Nivometrica	734	0101000020F859000000000000D0F118410000004036545341	f	f	2038	\N	\N
007050	900	S3372	PONTBOSET-FOURNIER	FOURNIER	397138	5051162	PT	REGIONEVALLED'AOSTA	SPM20	S	1087.00	1087.00	2002-11-07	VA	Meteorologica	868	0101000020F859000000000000483D184100000080C6445341	f	f	1087	\N	\N
004172	900	283	PONTECHIANALE	CASTELLO	345555	4941889	HNPT	ARPAPIEMONTE	SP200	S	1575.00	1575.00	1993-07-27	17	Nivometrica	873	0101000020F8590000000000004C1715410000004010DA5241	f	f	1575	1993-07-27	\N
007022	903	S1846	COURMAYEUR-FERRACHE	VAL FERRET-FERRACHET	347089	5081287	BHNPRTV	REGIONEVALLED'AOSTA	SPM20	S	2290.00	2290.00	2001-10-03	VA	Nivometrica	674	0101000020F859000000000000442F1541000000C031625341	f	f	2290	\N	\N
004001	901	S4062	ACCEGLIO COLLET	COLLET	333703	4931975	NPT	ARPAPIEMONTE	SPM20	S	2010.00	2010.00	2004-08-26	17	Nivometrica	517	0101000020F8590000000000001C5E1441000000C061D05241	f	f	2010	2004-08-27	\N
007022	902	S1299	COURMAYEUR-MONTDELASAXE	MONT DE LASAXE	343178	5075812	BHNPRTV	REGIONEVALLED'AOSTA	SP300	S	2076.00	2076.00	1992-10-01	VA	Nivometrica	676	0101000020F85900000000000028F2144100000000D95C5341	f	f	2076	\N	\N
004078	900	S3254	CUNEO CASCINA VECCHIA	CASCINA VECCHIA	382741	4914224	GHNPT	ARPAPIEMONTE	SPM20	S	575.00	575.00	2002-05-30	17	Nivometrica	685	0101000020F859000000000000545C1741000000000CBF5241	f	f	575	2002-05-31	\N
006079	900	S3216	GARBAGNA	RAMERO SUPERIORE-SAN FERMO	499447	4959186	PT	ARPAPIEMONTE	SPM20	S	420.00	420.00	2003-01-29	17	Meteorologica	719	0101000020F859000000000000DC7B1E4100000080F4EA5241	f	f	420	2003-02-20	\N
007044	900	S2542	MORGEX-LAVANCHERMETEO	MONTE LAVANCHER	346016	5073452	V	REGIONEVALLED'AOSTA	SPM20	S	2876.00	2876.00	1999-12-07	VA	Meteorologica	807	0101000020F859000000000000801E1541000000008B5A5341	f	f	2876	\N	\N
007044	901	S1845	MORGEX-LAVANCHERNIVO	MONTE LAVANCHER	346042	5073407	BHNPRT	REGIONEVALLED'AOSTA	SPM20	S	2842.00	2842.00	1999-12-07	VA	Nivometrica	808	0101000020F859000000000000E81E1541000000C07F5A5341	f	f	2842	\N	\N
001191	902	S3685	PINEROLO	PINEROLO-VIA POIRINO 145 POLO ECOLOGICO	370552	4973026	HPTVB	ACEAS.P.A.	SPM20	S	340.00	340.00	2003-08-27	17	Meteorologica	859	0101000020F859000000000000E09D16410000008078F85241	f	f	340	2003-08-28	\N
007053	902	S6157	PRE'ST DIDIER DORA BALTEA	PRE' ST.DIDIER	343931	5069892	IT	REGIONEVALLED'AOSTA	\N	S	995.00	995.00	2010-04-19	VA	Idrometrica	888	0101000020F859000000000000ECFD14410000000011575341	f	f	995	\N	\N
009017	901	S2892	SETTEPANI	MONTE SETTEPANI	435925	4899480	HNPRTV	ARPAPIEMONTE	SPM20	S	1375.00	1375.00	2002-05-15	17	Nivometrica	954	0101000020F859000000000000549B1A4100000000A6B05241	f	f	1375	2003-01-01	\N
007069	901	S2981	VALPELLINE PRELE'-BUTHIER	PRELE A VALPELLINE	373423	5077504	I	REGIONEVALLED'AOSTA	SPM20	S	1093.00	1093.00	2003-06-26	VA	Idrometrica	998	0101000020F859000000000000BCCA164100000000805E5341	f	f	1093	\N	\N
003148	900	S3375	TRASQUERA	SCHIAFFO	438833	5118446	PT	ARPAPIEMONTE	SPM20	S	1145.00	1145.00	2002-07-31	17	Meteorologica	986	0101000020F859000000000000C4C81A41000000807B865341	f	f	1145	2002-08-01	\N
001022	906	S4117	ROCHEMOLLES	ROCHEMOLLES	324349	5000119	PT	ARPAPIEMONTE	SPM20	S	1975.00	1975.00	2006-11-23	17	Meteorologica	915	0101000020F859000000000000F4CB1341000000C0ED125341	f	f	1975	2006-11-24	\N
001073	902	S2900	GRAN VAUDALA	GRANVAUDALA PUNTA NORD	353111	5039936	BRTV	ARPAPIEMONTE	SPM20	S	3272.00	3272.00	2002-10-01	17	Meteorologica	727	0101000020F8590000080EEA30698D15415F978F38CE395341	f	f	3272	2002-10-02	\N
007012	901	S4498	BRUSSON-EXTRAPIERAZ	EXTRAPIERAZ	398830	5070678	IP	REGIONEVALLED'AOSTA	\N	S	1380.00	1380.00	2007-07-25	VA	Idrometrica	585	0101000020F859000000000000B857184100000080D5575341	f	f	1380	\N	\N
007031	900	S4296	PILA LEISSE	PILALEISSE	368343	5058342	NPTV	REGIONEVALLED'AOSTA	\N	S	2280.00	2280.00	2007-07-17	VA	Nivometrica	858	0101000020F8590000000000005C7B164100000080C94B5341	f	f	2280	\N	\N
007027	900	S4495	LAVODILEC	LAVODILEC	381936	5055786	NPT	REGIONEVALLED'AOSTA	\N	S	2250.00	2250.00	2007-07-26	VA	Nivometrica	756	0101000020F859000000000000C04F1741000000804A495341	f	f	2250	\N	\N
007056	900	S3365	RHEMES-SG-DORA DI RHEMES	RHEMES ST.GEORGES	356133	5056984	IPT	REGIONEVALLED'AOSTA	SPM20	S	1179.00	1179.00	2002-11-27	VA	Idrometrica	901	0101000020F85900000000000094BC154100000000764A5341	f	f	1179	\N	\N
007021	902	S2952	COGNE-CRETAZ-T.GRAD-EYVIA	CRETAZ	370693	5052759	IT	REGIONEVALLED'AOSTA	\N	S	1470.00	1470.00	2004-08-04	VA	Idrometrica	660	0101000020F85900000000000014A01641000000C055465341	f	f	1470	\N	\N
007071	901	S2957	VALTOURNENCHE-MAEN-T.MARMORE	MAEN	392276	5079914	IPT	REGIONEVALLED'AOSTA	\N	S	1310.00	1310.00	2005-09-30	VA	Idrometrica	1003	0101000020F85900000000000050F1174100000080DA605341	f	f	1310	\N	\N
010066	900	S2589	ALPE VOBBIA	PASSO DELL'INCISA	506175	4935957	PT	REGIONELIGURIA	SPM20	S	1082.00	1082.00	2001-05-31	RL	Meteorologica	530	0101000020F859000000000000FCE41E410000004045D45241	f	f	1082	2004-01-01	\N
001019	901	S4101	BALME	FRAZIONE CORNETTI	360677	5018290	PT	ARPAPIEMONTE	SPM20	S	1410.00	1410.00	2006-09-28	17	Meteorologica	549	0101000020F85900006D40DCA2AC0216419364443C92245341	f	f	1410	2006-09-29	\N
007027	901	S3373	FENIS-CLAVALITE	ROUBIO	383024	5060488	PT	VALLED'AOSTA	\N	S	1531.00	1531.00	2003-08-06	VA	Meteorologica	702	0101000020F859000000000000C060174100000000E24D5341	f	f	1531	\N	\N
033038	900	F2941	RIVERGARO TREBBIA	RIVERGARO	545854	4973568	I	ARPA EMILIA-ROMAGNA	\N	N	62.00	62.00	2003-11-02	EM	Idrometrica	1053	0101000020F8590000DBB6F8B1DAA9204172D4B70A8BF75241	f	f	62	\N	\N
033004	901	F3334	RIGLIO	RIGLIO	553491	4964412	P	REGIONEEMILIAROMAGNA	\N	N	432.00	432.00	2003-11-12	EM	Meteorologica	905	0101000020F85900000000000026E42041000000000FF05241	f	f	432	\N	\N
033044	900	F3337	CASEBONINI	CASEBONINI	561402	4956952	IP	REGIONEEMILIAROMAGNA	\N	N	366.00	366.00	2003-11-12	EM	Idrometrica	622	0101000020F85900006C2121D96B222141BFC7A264BCE75241	f	f	366	\N	\N
033039	900	F2937	ROTTOFRENO TIDONE	ROTTOFRENO	541590	4988628	I	ARPA EMILIA ROMAGNA	\N	N	75.00	75.00	2003-11-12	EM	Idrometrica	1055	0101000020F8590000B481C3BBDD8820414C08A465A1085341	f	f	75	\N	\N
015230	900	F3275	VAPRIO D'ADDA	CANONICA D'ADDA	541706	5046989	I	REGIONE LOMBARDIA	\N	N	168.00	168.00	2003-11-12	LO	Idrometrica	1057	0101000020F859000094EBB744F4882041912869AE16415341	f	f	168	\N	\N
001272	905	S3869	TORINO REISS ROMOLI	TORINO	395535	4996506	BHPRTV	ARPAPIEMONTE	SPM20	S	270.00	270.00	2003-12-17	17	Meteorologica	978	0101000020F8590000000000003C24184100000080660F5341	f	f	270	2003-12-18	\N
010062	901	F2087	TORRIGLIA	TORRIGLIA	512365	4928438	PT	REGIONELIGURIA	\N	S	769.00	769.00	2003-11-12	RL	Meteorologica	984	0101000020F859000000000000B4451F4100000080EDCC5241	f	f	769	\N	\N
010030	900	F3353	BARBAGELATA	BARBAGELATA	519310	4924690	PT	REGIONELIGURIA	\N	N	1100.00	1100.00	2003-11-12	RL	Meteorologica	550	0101000020F85900000000000038B21F410000008044C95241	f	f	1100	\N	\N
010052	900	F3357	ROVEGNO	ROVEGNO	522011	4935992	PT	REGIONELIGURIA	\N	N	650.00	650.00	2003-11-12	RL	Meteorologica	924	0101000020F8590000000000006CDC1F41000000004ED45241	f	f	650	\N	\N
004190	901	S3950	ROCCAFORTE MONDOVI'	GHIRARDE	399915	4907260	HPT	ARPAPIEMONTE	SPM20	S	595.00	595.00	2004-05-18	17	Meteorologica	912	0101000020F859000000000000AC681841000000003FB85241	f	f	595	2004-05-19	\N
001022	905	012	BARDONECCHIA PRA NUDIN	PRANUDIN	319476	4997331	BHNPRTV	ARPAPIEMONTESITAFS.P.A.	SPM20	S	2045.00	2045.00	2005-09-06	17	Nivometrica	553	0101000020F859000000000000D07F1341000000C034105341	f	f	2045	2005-09-07	\N
007036	900	S3371	ISSIME-CAPOLUOGO-LYS	ISSIME	411019	5060138	IPT	REGIONEVALLED'AOSTA	SPM20	S	960.00	960.00	2003-01-23	VA	Idrometrica	742	0101000020F8590000000000002C161941000000808A4D5341	f	f	960	\N	\N
001313	901	S4127	VIU' CENTRALE FUCINE	FUCINE	371673	5010080	PT	ARPAPIEMONTE	SPM20	S	715.00	715.00	2006-08-29	17	Meteorologica	1028	0101000020F85900000000000064AF164100000000A81C5341	f	f	715	2006-08-31	\N
007068	900	S2622	VALGRISENCHE-MENTHIEU	MENTHIEU	348237	5053168	PTN	REGIONEVALLED'AOSTA	SPM20	S	1859.00	1859.00	2001-10-10	VA	Meteorologica	997	0101000020F8590000000000003441154100000000BC465341	f	f	1859	\N	\N
007018	901	S2954	CHARPORCHER-CHARDONNEY-AYASSE	CHARDONNEY	391621	5053030	IPT	REGIONEVALLED'AOSTA	\N	S	1430.00	1430.00	2005-08-25	VA	Idrometrica	651	0101000020F85900000000000014E717410000008099465341	f	f	1430	\N	\N
001232	900	150	SALBERTRAND	GRAVIERE	334301	4993216	HNPTV	SITAFS.P.A.	SP300	S	1010.00	1010.00	1990-11-15	17	Nivometrica	927	0101000020F8590000000000007467144100000000300C5341	f	f	1010	1990-11-15	\N
005005	901	S4194	ASTI	ISTITUTO PENNA	436154	4974320	BGHNPRTV	ARPAPIEMONTE	SPM20	S	175.00	175.00	2005-03-17	17	Nivometrica	540	0101000020F859000000000000E89E1A4100000000BCF95241	f	f	175	2005-03-26	\N
001275	900	S6470	BERTENGA PELLICE	PONTE SUL TORRENTE PELLICE	358256	4964389	I	COMUNETORREPELLICE	SPM20	S	548.00	548.00	2012-05-24	17	Idrometrica	562	0101000020F859000000000000C0DD15410000004009F05241	f	f	548	\N	\N
005012	900	S4195	BUTTIGLIERA D'ASTI	STRADA VECCHIA DI CHIERI	416001	4985910	HPRTV	ARPAPIEMONTE	SPM20	S	290.00	290.00	2005-03-17	17	Meteorologica	589	0101000020F85900000000000004641941000000800D055341	f	f	290	2005-03-26	\N
004066	900	S4145	CEVA	VIA S.PIETRO	421761	4915442	PT	PROVINCIADICUNEO	SPM20	S	410.00	410.00	2005-03-16	17	Meteorologica	646	0101000020F85900000000000004BE1941000000803CC05241	f	f	410	2008-01-01	\N
004073	900	S3735	CORTEMILIA UZZONE	PONTE SP208	436245	4936687	I	PROVINCIADICUNEO	SPM20	S	264.00	264.00	2005-03-17	17	Idrometrica	671	0101000020F85900000000000054A01A41000000C0FBD45241	f	f	264	2008-01-01	2013-12-31
004081	900	S3762	DOGLIANI REA	PONTE VIA MONVISO	417002	4931661	I	PROVINCIADICUNEO	SPM20	S	295.00	295.00	2005-04-06	17	Idrometrica	692	0101000020F859000000000000A87319410000004013D05241	f	f	295	2008-01-01	2013-12-31
001282	901	S4108	LAGO DIETRO LA TORRE	LAGO DIETRO LA TORRE	356046	5013564	NPT	ARPAPIEMONTE	SPM20	S	2360.00	2360.00	2006-08-30	17	Nivometrica	749	0101000020F85900000000000038BB1541000000000F205341	f	f	2360	2006-08-31	\N
004117	900	S4148	MARENE	AREA ECOLOGICA	399568	4947072	PT	PROVINCIADICUNEO	SPM20	S	310.00	310.00	2005-04-07	17	Meteorologica	774	0101000020F859000000000000406318410000000020DF5241	f	f	310	2008-01-01	\N
004125	900	S3758	MOMBASIGLIO MONGIA	PONTE VIA ASCHERI	417577	4913468	IP	PROVINCIADICUNEO	SPM20	S	452.00	452.00	2005-04-05	17	Idrometrica	787	0101000020F859000000000000A47C1941000000004FBE5241	f	f	452	2008-01-01	2013-12-31
215000	900	S4112	MONCENISIO LAGO	HAUTE MAURIENNE-LANSLEBOURG-MONT-CENIS-PASSO DEL MONCENISIO	338644	5009846	PT	ARPAPIEMONTE	SPM20	S	2000.00	2000.00	2005-06-22	17	Meteorologica	792	0101000020F8590000E20437CDBDAC144186DB15399C1C5341	f	f	2000	2006-01-01	\N
006161	900	S4121	SEZZADIO	DEPURATORE COMUNALE	465851	4959096	PT	ARPAPIEMONTE	SPM20	S	110.00	110.00	2005-08-02	17	Meteorologica	955	0101000020F859000000000000EC6E1C4100000000DEEA5241	f	f	110	2005-08-03	\N
001272	908	S4294	TORINO ALENIA	CORSO MARCHE 41	390738	4992935	HRTV	ARPAPIEMONTE	SPM20	S	320.00	320.00	2005-05-31	17	Meteorologica	973	0101000020F85900000000000048D91741000000C0E90B5341	f	f	320	2005-06-01	\N
012120	900	F2031	SESTO CALENDE	VIA ALZAIA LEANDRO MATTEA	471890	5063464	I	REGIONE LOMBARDIA	SPM20	\N	197.00	197.00	2013-01-01	LO	Idrometrica	1033	0101000020F8590000A4D3E42681CF1C4149393B1207515341	f	f	197	\N	\N
012087	901	F2032	POGGIO SANT'ELSA	POGGIO SANT'ELSA	472016	5084442	BHPRTV	REGIONE LOMBARDIA	SPM20	N	949.00	949.00	2013-01-01	LO	Meteorologica	1034	0101000020F8590000E37168B262D51C417FD053574B655341	f	f	949	\N	\N
015151	900	F2033	MOTTA VISCONTI	VIA ALCIDE DE GASPERI - PISCINA COMUNALE	499166	5084244	BHTVP	REGIONE LOMBARDIA	SPM20	N	100.00	100.00	2013-01-01	LO	Meteorologica	1035	0101000020F8590000EB59EACA92771E416E8A963EF5205341	f	f	100	\N	\N
012048	900	F2035	CAVARIA	VIA ROSSELLI 45 - SEDE PROTEZIONE CIVILE	485038	5059760	PT	REGIONE LOMBARDIA	SPM20	N	259.00	259.00	2013-01-01	LO	Meteorologica	1036	0101000020F8590000F81E80B8E9991D4141E54A2C354D5341	f	f	259	\N	\N
012047	900	F2036	CASTRONNO	VIA BELVEDERE	486156	5066278	BPTV	REGIONE LOMBARDIA	SPM20	N	370.00	370.00	2013-01-01	LO	Meteorologica	1037	0101000020F859000028A62C4E35AC1D41FDF4C6108A535341	f	f	370	\N	\N
018039	900	F2037	CASTELLO D'AGOGNA	SP26 - ENTE DI RICERCA RISI MORTARA	476584	5010609	HPTV	REGIONE LOMBARDIA	SPM20	N	108.00	108.00	2013-01-01	LO	Meteorologica	1038	0101000020F8590000FF1E14D982161D419C2E0D582D1D5341	f	f	108	\N	\N
015007	900	F2038	ARCONATE	VIA ALCIDE DE GASPERI CAMPO SPORTIVO	488151	5044094	BHPTV	REGIONE LOMBARDIA	SPM20	N	183.00	183.00	2013-01-01	LO	Meteorologica	1039	0101000020F85900005B59AB2006CA1D41948BB734FC3D5341	f	f	183	\N	\N
018152	900	F2030	SPESSA PO	SP199 KM 0+450	527292	4994495	I	REGIONE LOMBARDIA	SPM20	N	58.00	58.00	2013-01-01	LO	Idrometrica	1040	0101000020F8590000C5098C8DBB1720410E50813D8A0D5341	f	f	58	\N	\N
003142	902	118	MOTTARONE	MOTTARONE-VETTA	457689	5081238	BHTV	ARPAPIEMONTE	SPM20	S	1502.00	1491.00	1988-07-13	17	Meteorologica	811	0101000020F85900000000000064EF1B410000008025625341	f	f	1491	1988-07-13	\N
012086	900	F2034	LAVENA PONTE TRESA	VIA DELLA BOSCHIVA CAMPO SPORTIVO	488480	5091115	PT	REGIONE LOMBARDIA	SPM20	N	269.00	269.00	2013-01-01	LO	Meteorologica	1041	0101000020F8590000C438B9BB8DD01D41704B37E7C96B5341	f	f	269	\N	\N
006012	900	212	BASALUZZO	BASALUZZO	474833	4956759	HTVP	AZIENDAMULTISERVIZIIDRICIEDAMBIENTALISCRIVIAS.P.A.	SPM20	S	128.00	128.00	1998-10-09	17	Meteorologica	555	0101000020F85900000000000044FB1C41000000C095E85241	f	f	128	1998-10-10	\N
004038	901	S2561	GARDETTA	GARDETTA	341793	4919440	NPT	ARPAPIEMONTE	SPM20	S	2337.00	2337.00	2001-09-20	17	Nivometrica	720	0101000020F85900000000000084DC14410000000024C45241	f	f	2337	2001-10-01	\N
007003	900	S7251	SAINT CHRISTOPHE	AEROPORTO REGIONALE CORRADO GEX	372841	5066584	TPNVR	REGIONE VALLE D AOSTA	\N	N	544.00	544.00	2015-04-13	VA	Nivometrica	1060	0101000020F859000038708902B9D01641C57FDEB3E0535341	f	f	544	\N	\N
007070	901	S2951	VALSAVAR.-EAUXROUSSES-SAVARA	EAUX-ROUSSES	360272	5047673	IPT	REGIONEVALLED'AOSTA	\N	S	1651.00	1651.00	2004-08-04	VA	Idrometrica	1000	0101000020F85900000000000040FD1541000000405E415341	f	f	1651	\N	\N
010048	900	F2067	CABANNE	CABANNE	527101	4926600	IPT	REGIONELIGURIA	SPM20	N	809.00	809.00	2003-11-12	RL	Idrometrica	590	0101000020F8590000D8429E9C0D1A2041FEF8C822A9CB5241	f	f	809	\N	\N
004159	900	311	PAMPARATO	SERRA	412659	4904107	PT	ARPAPIEMONTE	SP200	S	975.00	975.00	1997-10-14	17	Meteorologica	834	0101000020F859000000000000CC2F1941000000C02AB55241	f	f	975	1997-10-15	\N
004221	900	137	SOMANO	ALBERE	422019	4932623	HPT	ARPAPIEMONTE	SPM20	S	626.00	626.00	1989-07-05	17	Meteorologica	956	0101000020F8590000000000000CC21941000000C003D15241	f	f	626	1989-07-05	\N
001073	901	348	CERESOLE VILLA	VILLA	360163	5033606	NPT	ARPAPIEMONTE	SP200	S	1581.00	1581.00	1999-09-07	17	Nivometrica	642	0101000020F8590000000000008CFB154100000080A1335341	f	f	1581	1999-09-08	\N
007042	900	S2616	LILLIANES-GRANGES	GRANGES	410936	5053543	PT	REGIONEVALLED'AOSTA	SPM20	S	1256.00	1256.00	2001-09-19	VA	Meteorologica	761	0101000020F859000000000000E0141941000000C019475341	f	f	1256	\N	\N
002072	901	S2579	LOZZOLO	MONTEMAZZUCCO	448135	5054747	PTV	ARPAPIEMONTE	SPM20	S	533.00	533.00	2001-04-17	17	Meteorologica	765	0101000020F8590000000000001C5A1B41000000C046485341	f	f	533	2001-10-01	\N
012077	900	F2021	MIORINA	STRADA ALZAIA MIORINA	472754	5060086	I	REGIONE LOMBARDIA	\N	N	218.00	218.00	2003-11-12	LO	Idrometrica	1058	0101000020F8590000E788F0AE8AE11C41FF71B150F54E5341	f	f	218	\N	\N
001175	903	S2960	CHATEAU BEAULARD	RIFUGIOREY-PRA'MENIER	323132	4988527	NPT	COMUNEDIOULX	SPM20	S	1800.00	1800.00	2001-11-13	17	Nivometrica	652	0101000020F859000000000000F0B81341000000C09B075341	f	f	1800	2002-01-01	\N
015191	900	F6240	S. COLOMBANO AL LAMBRO	VIGNETO SPERIMENTALE MORETTO	538217	5038466	HPTVR	REGIONE LOMBARDIA	\N	N	140.00	140.00	2014-02-01	LO	Meteorologica	1047	0101000020F8590000366D9202FF6C204186DB680AD3165341	f	f	140	\N	\N
018171	901	F6251	VARZI ERSAF	NIVIONE	514203	4961808	HPTRV	REGIONE LOMBARDIA	\N	N	560.00	560.00	2014-02-01	LO	Meteorologia	1049	0101000020F8590000740511ADBF681F41E560F07275EF5241	f	f	560	\N	\N
005005	902	S6520	ASTI VERSA	PONTESUERO - VIA E. TORCHIO	439555	4974996	I	PROVINCIA DI ASTI	SPM20	S	123.00	123.00	2014-09-05	17	Idrometrica	1051	0101000020F8590000000000000CD41A410000000065FA5241	f	f	123	2014-09-05	\N
015182	900	F7216	RHO SCALO FIORENZA	TRENORD SRL	506990	5040343	HTVP	REGIONE LOMBARDIA	SP200	N	143.00	143.00	2014-04-01	LO	Meteorologica	1059	0101000020F859000011752A8B18F31E413B443C24653A5341	f	f	143	\N	\N
015146	902	F6212	MILANO LAMBRATE	PARCO LAMBO	520118	5038367	HPTV	REGIONE LOMBARDIA	\N	N	120.00	120.00	2014-02-01	LO	Meteorologica	1044	0101000020F8590000D686BEA03EBF1F41F82AAD165C385341	f	f	120	\N	\N
002038	900	S4591	CELLIO	VALMONFREDO	447736	5066833	PT	PROVINCIADIVERCELLI	SPM20	S	705.00	705.00	2006-06-07	17	Meteorologica	639	0101000020F859000000000000E0531B410000004014545341	f	f	705	2006-08-11	\N
018078	900	F6205	LANDRIANO	AZIENDA AGRICOLA MENOZZI	510911	5018499	BHPRTV	REGIONE LOMBARDIA	\N	N	88.00	88.00	2014-02-01	LO	Meteorologica	1045	0101000020F85900002A093A64C9C81F41026D801C26255341	f	f	88	\N	\N
012135	900	F6444	VEDDASCA	MONTE CADRIGNA	422052	5101919	HPTV	REGIONE LOMBARDIA	\N	N	1302.00	1302.00	2014-02-01	LO	Meteorologica	1050	0101000020F8590000C60909B0CD641D411C97EDF8E7765341	f	f	1302	\N	\N
015209	900	F6213	MILANO PARCO NORD	PARCO NORD	516097	5043110	PTV	REGIONE LOMBARDIA	\N	N	145.00	145.00	2014-02-01	LO	Meteorologica	1043	0101000020F8590000655D8A5351811F4117EC7B7D363D5341	f	f	145	\N	\N
002110	900	185	RASSA	RASSA	423601	5069104	HPT	ARPAPIEMONTE	SP200	S	950.00	950.00	1993-07-20	17	Meteorologica	898	0101000020F859000000000000C4DA1941000000004C565341	f	f	950	1993-07-20	\N
007007	900	S5649	AYAS ALPE AVENTINE	ALPE AVENTINE	400189	5080783	NPT	REGIONEVALLED'AOSTA	\N	S	2073.00	2073.00	2009-10-07	VA	Nivometrica	543	0101000020F859000000000000F46C1841000000C0B3615341	f	f	2073	\N	\N
005022	901	S1728	CASTAGNOLE LANZE	BRIC DELLA GUARDIA	435061	4955861	HPT	ARPAPIEMONTE	SPM20	S	383.00	383.00	2007-11-19	17	Meteorologica	629	0101000020F859000000000000D48D1A4100000040B5E75241	f	f	383	2007-11-22	\N
007008	901	S2959	AYMAVILLES-DORA BALTEA	SAINT LEGER	364072	5063600	IT	REGIONEVALLED'AOSTA	\N	S	610.00	610.00	2004-08-03	VA	Idrometrica	544	0101000020F859000000000000A038164100000000EC505341	f	f	610	\N	\N
003048	900	098	CEPPO MORELLI	ALPECOLLA	426224	5093256	PT	CITTA'DICEPPOMORELLI	SP200	S	1995.00	1995.00	2000-11-22	17	Meteorologica	640	0101000020F859000000000000C0031A4100000000E26D5341	f	f	1995	2000-11-23	\N
001074	902	242	CESANA THURAS	BOISDUBANRIOMUSIA	329829	4973144	PT	PROVINCIADITORINO	SP200	S	1918.00	1918.00	2001-08-29	17	Meteorologica	643	0101000020F859000000000000942114410000000096F85241	f	f	1918	2001-08-30	\N
001103	900	265	PRA' CATINAT	PRA'CATINAT	348435	4989063	HPT	ARPAPIEMONTE	SP200	S	1670.00	1670.00	1997-09-10	17	Meteorologica	880	0101000020F8590000000000004C441541000000C021085341	f	f	1670	1997-09-11	\N
003003	900	160	ALPE CHEGGIO	ALPE CHEGGIO	431711	5104080	NPTH	ARPAPIEMONTE	SP200	S	1460.00	1460.00	1996-11-05	17	Nivometrica	526	0101000020F8590000000000007C591A410000000074785341	f	f	1460	1996-11-06	\N
001292	901	S4587	VENARIA LA MANDRIA	CASCINA PEPPINELLA	386872	5003594	HTVP	ARPAPIEMONTE	SPM20	S	337.00	337.00	2006-04-04	17	Meteorologica	1012	0101000020F859000000000000E09C17410000008052165341	f	f	337	2006-04-05	\N
007056	901	S4026	RHEMES - SAINT GEORGES	RHEMES - SAINT GEORGES	353677	5052293	NTP	REGIONE VALLE D'AOSTA	\N	N	2322.00	2322.00	2016-04-01	VA	Nivometrica	1065	0101000020F85900009555B04A7C9715418FD268E312465341	f	f	2322	\N	\N
007071	902	S3391	VALTOURNENCHE GOILLET	LAGO GOILLET DIGA C.V.A.	396405	5087484	NTP	REGIONE VALLE D'AOSTA	\N	N	2541.00	2541.00	2016-04-01	VA	Nivometrica	1066	0101000020F8590000F85364961D3318410E0016B370685341	f	f	2541	\N	\N
007071	903	S4297	VALTOURNENCHE GRAND MURAILLES	GRANDES MURAILLES	391777	5087361	NTVP	REGIONE VALLE D'AOSTA	\N	N	2566.00	2566.00	2016-04-01	VA	Nivometrica	1067	0101000020F85900006756DF73CDEA1741A1881BF351685341	f	f	2566	\N	\N
007070	902	S4027	VALSAVARENCHE - ORVIELLE	CASA REALE DI CACCIA	359026	5049161	NTP	REGIONE VALLE D'AOSTA	\N	N	2160.00	2160.00	2016-04-01	VA	Nivometrica	1068	0101000020F85900001978DD7110EB15413874CDE103435341	f	f	2160	\N	\N
001050	900	099	CANDIA	LAGO DI CANDIA	413755	5019418	HIPRTV	ARPAPIEMONTE	SPM20	S	226.00	226.00	1988-03-01	17	Idrometrica	601	0101000020F859000000000000EC40194100000080C6255341	f	f	226	2000-01-01	\N
001196	900	234	PIVERONE	PIVERONE-LIDO DI ANZASCO	424479	5031426	HIPTV	ARPAPIEMONTE	SPM20	S	230.00	230.00	1993-06-23	17	Idrometrica	861	0101000020F8590000000000007CE819410000008080315341	f	f	230	1993-09-01	\N
007046	900	S2613	OLLOMONT-BY	BY	368218	5082478	PTN	REGIONEVALLED'AOSTA	SPM20	S	2017.00	2017.00	2001-09-19	VA	Nivometrica	823	0101000020F85900000000000068791641000000805B635341	f	f	2017	\N	\N
007055	900	S2950	RHEMES-CHANAVEY-DORA RHEMES	CHANAVEY	353673	5049164	IPTN	REGIONEVALLED'AOSTA	\N	S	1690.00	1700.00	2004-08-04	VA	Nivometrica	900	0101000020F8590000000000002496154100000000D3425341	f	f	1700	\N	\N
007041	902	S1844	LATHUILE-FOILLEX	FOILLEX	342193	5064835	PR	REGIONEVALLED'AOSTA	SPM20	S	2042.00	2042.00	2002-11-07	VA	Meteorologica	745	0101000020F859000000000000C4E21441000000C020525341	f	f	2042	\N	\N
004029	901	275	BRA-ISOLASONORA	BRA-VIA PIUMATI 112	408124	4949616	HTV	CITTA'DIBRA	SPM20	S	290.00	290.00	2000-05-08	17	Z	580	0101000020F859000000000000F0E81841000000009CE15241	f	f	290	2000-09-05	2009-12-31
004205	900	002	PIAN DELLE BARACCHE	PIAN DELLE BARACCHE	351816	4934725	NPRTVY	ARPAPIEMONTE	SPM20	S	2135.00	2135.00	1987-10-08	17	Nivometrica	849	0101000020F859000000000000207915410000004011D35241	f	f	2135	1987-10-09	\N
003067	900	010	FORMAZZA	PIANO DEI CAMOSCI	450779	5142603	HNPTVY	ARPAPIEMONTE	SPM20	S	2453.00	2453.00	1988-10-27	17	Nivometrica	707	0101000020F8590000000000006C831B41000000C0129E5341	f	f	2453	1988-10-27	\N
001259	900	008	LAGO PILONE	LAGO PILONE	332693	4985596	HNPRTVY	ARPAPIEMONTE	SPM20	S	2280.00	2280.00	1988-10-21	17	Nivometrica	751	0101000020F859000000000000544E144100000000BF045341	f	f	2280	1988-10-22	\N
002002	900	006	BOCCHETTA DELLE PISSE	ALAGNA-BOCCHETTA DELLE PISSE	414792	5081006	NPTVRY	ARPAPIEMONTE	SPM20	S	2410.00	2410.00	1987-10-21	17	Nivometrica	571	0101000020F8590000000000002051194100000080EB615341	f	f	2410	1987-10-22	\N
003086	900	007	PASSO DEL MORO	PASSO DEL MORO	420822	5094426	GHNPRTVY	ARPAPIEMONTE	SPM20	S	2820.00	2820.00	1988-11-04	17	Nivometrica	839	0101000020F85900000000000058AF194100000080066F5341	f	f	2820	1988-11-04	\N
004248	900	001	COLLE LOMBARDA	COLLE LOMBARDA	352095	4896831	NPTVY	ARPAPIEMONTE	SPM20	S	2305.00	2305.00	1987-09-24	17	Nivometrica	667	0101000020F8590000000000007C7D1541000000C00FAE5241	f	f	2305	1987-09-25	\N
007053	900	S1300	PRE-ST-DIDIER-PLANPRAZ	PLAN PRAZ	340864	5069401	BHNPRTVY	REGIONEVALLED'AOSTA	SPM20	S	2044.00	2044.00	1992-10-01	VA	Nivometrica	890	0101000020F85900000000000000CE14410000004096565341	f	f	2044	\N	\N
001263	907	S3237	SESTRIERE BANCHETTA	MONTE BANCHETTA	335258	4981370	HNPRTVY	ARPAPIEMONTE	SPM20	S	2480.00	2480.00	2003-08-06	17	Nivometrica	953	0101000020F85900000000000068761441000000809E005341	f	f	2480	2003-08-07	\N
004110	901	S4613	LIMONE PANCANI	PANCANI	387341	4890901	AHNPTVY	ARPAPIEMONTE	SPM20	S	1875.00	1875.00	2006-10-05	17	Nivometrica	762	0101000020F85900000000000034A417410000004045A85241	f	f	1875	2006-10-06	\N
004172	902	S4063	COLLE DELL'AGNELLO	RICOVERINI	339885	4949696	GNPTY	ARPAPIEMONTE	SPM20	S	2685.00	2685.00	2004-09-01	17	Nivometrica	665	0101000020F85900009DFAE4B2EABF1441A4C14BE9B7E15241	f	f	2685	2004-09-02	\N
005064	700	236	MOMBALDONE BORMIDA	PONTEMENASCO	447287	4935480	BHIPRT	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP300	S	187.00	187.00	1994-06-05	RI	Idrometrica	785	0101000020F859000000000000DC4C1B4100000000CED35241	f	f	187	2005-01-01	\N
009048	900	286	PIANA CRIXIA BORMIDA	PIANA CRIXIA	445180	4926774	I	REGIONELIGURIA	SP200	S	267.00	267.00	2001-03-14	RL	Idrometrica	851	0101000020F859000000000000F02B1B41000000804DCB5241	f	f	267	2004-01-01	\N
006036	900	284	CARTOSIO ERRO	PONTE VIADOTTO S.S.334	454121	4935927	I	ARPAPIEMONTE	SP200	S	236.00	236.00	2001-03-13	17	Idrometrica	617	0101000020F859000000000000A4B71B41000000C03DD45241	f	f	236	2003-01-01	\N
004017	901	S5611	LA COLLETTA	LACOLLETTA	336694	4940526	HNT	ARPAPIEMONTE	SPM20	N	2793.00	2793.00	2009-09-24	17	Nivometrica	743	0101000020F859000049FB5F8DF58B14416C2B051C62D35241	f	f	2793	\N	\N
001127	700	S2752	LA LOGGIA CHISOLA	VIADOTTO S.S.20	395185	4980749	I	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	247.00	247.00	2001-10-01	RI	Z	744	0101000020F859000000000000C41E18410000004003005341	f	f	247	2003-01-01	\N
001165	900	S4105	NOASCA	NOASCA	368058	5034971	PT	ARPAPIEMONTE	SPM20	S	1055.00	1055.00	2006-08-31	17	Meteorologica	818	0101000020F859000000000000E8761641000000C0F6345341	f	f	1055	2006-10-15	\N
003050	900	S2568	CESARA	CESARA	450752	5076235	PT	ARPAPIEMONTE	SPM20	S	500.00	500.00	2000-12-11	17	Meteorologica	644	0101000020F85900000000000000831B41000000C0425D5341	f	f	500	2001-10-01	\N
001080	900	148	FINIERE	FINIERE	340117	4998152	HPTV	SITAFS.P.A.	SP200	S	813.00	813.00	1990-12-19	17	Meteorologica	704	0101000020F85900000000000054C214410000000002115341	f	f	813	1990-12-19	\N
010026	900	F2979	ALPE GORRETO	ALPE	518758	4939746	PT	REGIONELIGURIA	\N	N	915.00	915.00	2003-11-12	RL	Meteorologica	528	0101000020F85900000000000098A91F4100000080F8D75241	f	f	915	\N	\N
001032	901	S7677	BORGONE SUSA DORA RIPARIA	PONTE S.P. 201	767700	4997067	I	VILLARFIOCCARDO SRL	MHASTER	N	381.00	381.00	2017-10-02	17	Idrometrica	1070	0101000020F859000098209AC378351641BEA7644CF70F5341	f	f	381	2017-10-02	\N
006125	900	231	PARETO	BISSI	451556	4930821	P	ARPAPIEMONTE	SP200	S	525.00	525.00	1996-08-29	17	Meteorologica	836	0101000020F859000000000000908F1B410000004041CF5241	f	f	525	1996-10-14	\N
003155	900	128	VARZO	SAN DOMENICO	437878	5122296	HPT	ARPAPIEMONTE	SP200	S	1308.00	1308.00	1989-07-19	17	Meteorologica	1010	0101000020F859000000000000D8B91A41000000003E8A5341	f	f	1308	1989-07-19	\N
005080	900	207	NIZZA MONFERRATO	INCIE	448319	4957203	HPT	ARPAPIEMONTE	SP200	S	138.00	138.00	1993-07-15	17	Meteorologica	817	0101000020F859000000000000FC5C1B41000000C004E95241	f	f	138	1993-07-15	\N
003156	900	641	PALLANZA	CNR DI PALLANZA	465093	5085916	BGHIPRTV	ARPAPIEMONTE	SPM20	S	202.00	202.00	1996-06-06	17	Idrometrica	833	0101000020F85900000000000014631C4100000000B7665341	t	f	202	2000-01-01	\N
006025	900	121	CAPANNE DI COSOLA	CAPANNE DI COSOLA	515945	4947126	HPRTV	ARPAPIEMONTE	SPM20	S	1550.00	1550.00	1988-05-10	17	Meteorologica	608	0101000020F8590000CD663DDD947D1F41000000802DDF5241	f	f	1550	1988-05-10	\N
007045	901	S4817	LES ILES	\N	378580	5066428	IPT	REGIONEVALLED'AOSTA	\N	S	534.00	534.00	2006-12-13	VA	Idrometrica	759	0101000020F859000000000000501B174100000000AF535341	f	f	534	\N	\N
007034	900	S2955	HONE-PONTES.R.-DORA BALTEA	BARD	401842	5052488	IPT	REGIONEVALLED'AOSTA	\N	S	340.00	359.00	2004-08-03	VA	Idrometrica	738	0101000020F859000000000000C88618410000000012465341	f	f	359	\N	\N
007017	901	S2956	CHAMPDEPRAZ-DORA BALTEA	VERRES	396798	5059749	IT	REGIONEVALLED'AOSTA	\N	S	370.00	370.00	2004-08-03	VA	Idrometrica	649	0101000020F859000000000000F837184100000040294D5341	f	f	370	\N	\N
004084	902	S2898	ROCCA DELL'ABISSO	ROCCA DELL'ABISSO	380355	4889073	BRTV	ARPAPIEMONTE	SPM20	S	2753.00	2753.00	2002-10-03	17	Meteorologica	910	0101000020F8590000F0E32B9EF136174101F476A37DA65241	f	f	2753	2002-10-04	\N
033004	900	F2920	BETTOLA	CAMPELLI DI VIGOLO	550095	4960619	PT	REGIONEEMILIAROMAGNA	\N	N	618.00	618.00	2003-11-12	EM	Meteorologica	564	0101000020F8590000000000009EC92041000000C05AEC5241	f	f	618	\N	\N
004239	900	S2563	PALANFRE'	PALANFRE'GIASCHIOT	379312	4894654	NPT	ARPAPIEMONTE	SPM20	S	1625.00	1625.00	2001-06-28	17	Nivometrica	831	0101000020F859000000000000C026174100000080EFAB5241	f	f	1625	2001-10-01	\N
004033	900	356	BROSSASCO	DEPURATORE COMUNALE	370918	4936473	BPT	ARPAPIEMONTE	SPM20	S	580.00	580.00	1999-07-15	17	Meteorologica	584	0101000020F85900000000000098A3164100000040C6D45241	f	f	580	1999-07-16	\N
003118	900	445	FOMARCO	VIA CROSA	443240	5094961	PT	ARPAPIEMONTE	SP200	S	252.00	252.00	2002-01-01	17	Meteorologica	706	0101000020F859000000000000A00D1B41000000408C6F5341	f	f	252	2002-01-01	\N
004017	900	355	BELLINO	PIAN MELZE'	339936	4937921	PT	ARPAPIEMONTE	SPM20	S	1805.00	1805.00	1999-07-15	17	Meteorologica	559	0101000020F85900000000000080BF14410000004030D65241	f	f	1805	1999-07-16	\N
012132	900	F6442	VARANO BORGHI	BOFFALORA	477673	5068124	HPTV	REGIONE LOMBARDIA	\N	N	241.00	241.00	2014-02-01	LO	Meteorologica	1048	0101000020F8590000436153CB8E271D41423295A7A0555341	f	f	241	\N	\N
012087	902	F2160	LAVENO MOLO	MOLO LAGO MAGGIORE	470407	5084041	HIPTV	REGIONE LOMBARDIA	\N	N	197.00	197.00	2014-02-01	LO	Idrometrica	1046	0101000020F8590000AC5BA34461B71C418E4833202C655341	f	f	197	\N	\N
006101	900	424	VOLPEDO CURONE	MONREALE	498735	4970599	IQ	ARPAPIEMONTE	SP200	S	182.00	182.00	1992-02-05	17	IdrometricaQ	1030	0101000020F859000000000000BC701E41000000C019F65241	f	f	182	2004-01-01	\N
004035	900	S2080	CAMERANA BORMIDA	GABUTTI	432075	4921538	IQ	ARPA PIEMONTE	SPM20	S	368.00	368.00	2017-07-06	17	IdrometricaQ	597	0101000020F8590000D6C9DDA8325F1A41F8270E1930C65241	f	f	368	2017-07-06	\N
002032	700	377	CARISIO ELVO	PONTE S.P.3	438077	5029958	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	183.00	183.00	2000-06-01	RI	IdrometricaQ	613	0101000020F859000000000000F4BC1A410000008011305341	f	f	183	2001-01-01	\N
001068	700	S2422	CASTIGLIONE TORINESE PO	MONTE DEPURATORE SMAT	404509	4998360	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	215.00	215.00	2001-09-20	RI	ZQ	637	0101000020F85900000000000074B018410000000036115341	f	f	215	2003-01-01	\N
001034	700	373	BRANDIZZO MALONE	PONTE S.S.31BIS	409882	5004010	IPTQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	192.00	192.00	2000-12-06	RI	IdrometricaQ	581	0101000020F8590000000000006804194100000080BA165341	f	f	192	2005-01-01	\N
001309	900	S7671	VINOVO CHISOLA	PONTE SP 143	391861	4978800	IQ	ARPAPIEMONTE	SPM20	S	230.00	230.00	2017-07-12	17	IdrometricaQ	1069	0101000020F8590000B30A604DC9EA17417E550DBF1BFE5241	f	t	230	2017-07-12	\N
004190	902	S3925	RASTELLO ELLERO	PONTE COMUNALE	398801	4902252	IQ	PROVINCIADICUNEO	SPM20	S	819.00	819.00	2005-03-30	17	IdrometricaQ	899	0101000020F85900000000000044571841000000005BB35241	f	f	819	2008-01-01	\N
003061	902	441	DOMODOSSOLA TOCE	PONTE S.S.33	446475	5106990	IQ	ARPAPIEMONTE	SP200	S	441.00	441.00	2003-02-18	17	IdrometricaQ	694	0101000020F8590000000000002C401B41000000804B7B5341	f	f	441	2003-01-01	\N
003152	900	S6329	SAN CARLO ANZA	SAN CARLO	432861	5093049	IQ	ARPA PIEMONTE	SPM20	S	558.00	558.00	2012-10-11	17	IdrometricaQ	1032	0101000020F859000048690612DF7D1A414E02AEFD196E5341	f	f	558	2013-01-01	\N
005097	900	204	SAN DAMIANO BORBORE	PONTE DI LAVEZZOLE	427500	4966004	HIPTQ	ARPAPIEMONTE	SP200	S	154.00	154.00	1995-11-08	17	IdrometricaQ	934	0101000020F859000000000000B0171A41000000009DF15241	f	f	154	1995-11-08	\N
003056	900	407	PONTEMAGLIO TOCE	PONTEMAGLIO	447898	5114558	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	N	373.00	373.00	1993-04-20	RI	IdrometricaQ	874	0101000020F85900000000000068561B4100000080AF825341	f	f	373	2013-01-01	\N
003061	901	409	PONTE CADDO BOGNA	CADDO	443992	5108033	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	280.00	280.00	1993-03-24	RI	IdrometricaQ	870	0101000020F85900000000000060191B4100000040507C5341	f	f	280	2002-01-01	\N
004197	900	420	ROSSANA VARAITA	BORGO SANT'ANTONIO	376300	4934816	IQ	ARPAPIEMONTE	SPM20	S	499.00	499.00	1990-06-08	17	IdrometricaQ	921	0101000020F859000000000000B0F716410000000028D35241	f	f	499	2003-01-01	\N
001270	903	403	SUSA CENISCHIA	VALLE CENTRALE ENEL	347243	5000742	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	500.00	500.00	1993-02-10	RI	IdrometricaQ	965	0101000020F859000000000000AC3115410000008089135341	f	f	500	2001-01-01	\N
004077	902	S5615	CRISSOLO PO	CRISSOLO	353800	4951471	ITPQ	PROVINCIADICUNEO	SPM20	S	1342.00	1342.00	2009-12-30	17	IdrometricaQ	680	0101000020F85900000000000020981541000000C06BE35241	f	f	1342	2010-01-01	\N
001109	900	247	FRONT MALONE	PONTE S.P.13	395441	5015494	HIPTQ	ARPAPIEMONTE	SPM20	S	270.00	270.00	1995-12-07	17	IdrometricaQ	716	0101000020F859000000000000C422184100000080F1215341	f	f	270	1995-12-07	\N
001175	901	402	OULX DORA RIPARIA	PONTE S.S.335	329418	4989165	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	1105.00	1105.00	1993-02-02	RI	IdrometricaQ	827	0101000020F859000000000000281B1441000000403B085341	f	f	1105	2001-01-01	\N
002105	900	188	PRAY SESSERA	PIAN CERIBASSO	439458	5058321	IPTQ	ARPAPIEMONTE	SP200	S	409.00	409.00	1996-11-06	17	IdrometricaQ	887	0101000020F85900000000000088D21A4100000040C44B5341	f	f	409	2005-08-02	\N
001199	700	388	PONT SOANA	PONTE DI VIA ROMA	390677	5030935	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	453.00	453.00	2000-06-08	RI	IdrometricaQ	866	0101000020F85900000000000054D81741000000C005315341	f	f	453	2002-01-01	\N
018081	900	490	PONTE BECCAPO	PONTE BECCA	518029	4999180	IQ	AGENZIAINTERREGIONALEDELPO	SP200	S	62.00	62.00	1997-11-12	MP	IdrometricaQ	869	0101000020F859000000000000349E1F410000000003125341	f	f	62	\N	\N
001293	700	375	VEROLENGO DORA BALTEA	PONTE S.S.31BIS	424770	5004925	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	167.00	167.00	2000-06-07	RI	IdrometricaQ	1016	0101000020F85900000000000008ED1941000000409F175341	f	f	167	2001-01-01	\N
003030	900	444	CALTIGNAGATERDOPPIO	PONTE S.S.229	469614	5040849	IQ	ARPAPIEMONTE	SPM20	S	180.00	180.00	2003-02-19	17	IdrometricaQ	595	0101000020F859000000000000B8A91C4100000040B43A5341	f	f	180	2003-01-01	\N
004139	700	385	MONTEROSSO GRANA	CENTRO ABITATO	366665	4918908	IPTQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	720.00	720.00	2000-07-27	RI	IdrometricaQ	806	0101000020F85900000000000024611641000000009FC35241	f	f	720	2005-01-01	\N
002160	900	S3223	VIGLIANO CERVO	PONTE S.P.301	430702	5045109	IQ	ARPAPIEMONTE	SPM20	S	327.00	327.00	2002-05-28	17	IdrometricaQ	1019	0101000020F859000000000000B8491A4100000040DD3E5341	f	f	327	2003-01-01	\N
010027	900	S2591	ISOLA DEL CANTONE VOBBIA	VOBBIETTA	498788	4943483	IQ	REGIONELIGURIA	SPM20	S	323.00	323.00	2001-05-31	RL	IdrometricaQ	739	0101000020F8590000162A9C6BFA6E1E415F183080E5DA5241	f	f	323	2004-01-01	\N
005037	700	387	CESSOLE BORMIDA	SAN ALESSANDRO	440553	4944472	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	200.00	200.00	2000-07-25	RI	IdrometricaQ	645	0101000020F859000000000000A4E31A410000000096DC5241	f	f	200	2002-01-01	\N
004043	700	383	CARRU' PESIO	PONTEVECCHIO	411221	4924307	IPTQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	275.00	275.00	2000-07-25	RI	IdrometricaQ	616	0101000020F85900000000000054191941000000C0E4C85241	f	f	275	2005-01-01	\N
004233	901	S3931	ANDONNO GESSO	PONTE SP219	375159	4905569	IPQ	PROVINCIADICUNEO	SPM20	S	712.00	712.00	2005-03-09	17	IdrometricaQ	531	0101000020F859000000000000DCE516410000004098B65241	f	f	712	2008-01-01	\N
006012	700	226	BASALUZZO ORBA	TRAVERSA DERIVAZIONE CANALE FRESONARA	474101	4957372	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP300	S	125.00	125.00	2000-10-02	RI	IdrometricaQ	556	0101000020F859000000000000D4EF1C41000000002FE95241	f	f	125	2001-01-01	\N
001128	901	415	LANZO STURA DI LANZO	SAN ROCCO	381063	5014078	IPTQ	ARPAPIEMONTE	SP200	S	540.00	540.00	1990-07-12	17	IdrometricaQ	753	0101000020F8590000000000001C421741000000808F205341	f	f	540	2001-03-23	\N
001066	900	S5616	SPINETO ORCO	SPINETO	396288	5026973	IQ	ARPAPIEMONTE	SPM20	S	362.00	362.00	2009-11-11	17	IdrometricaQ	961	0101000020F8590000000000000030184100000040272D5341	f	f	362	2010-01-01	\N
001191	901	417	SAN MARTINO CHISONE	BARAVEIERA	364487	4971847	IPQ	ARPAPIEMONTE	SP200	S	410.00	410.00	1991-03-15	17	IdrometricaQ	937	0101000020F8590000000000001C3F1641000000C051F75241	f	f	410	2001-01-01	\N
001257	900	180	SANTENA BANNA	VIA CAVOUR	403991	4977715	HIPTQ	CNRISTITUTODIRICERCAPERLAPROTEZIONEIDROGEOLOGICA-CITTA'DISANTENA	SP200	S	238.00	238.00	1998-10-08	17	IdrometricaQ	942	0101000020F8590000000000005CA81841000000C00CFD5241	f	f	238	1998-10-09	\N
004155	901	S2590	PONTE DI NAVA TANARO	PONTE DI NAVA	409472	4885763	IPTQ	REGIONELIGURIA	SPM20	S	840.00	840.00	2001-09-20	17	IdrometricaQ	871	0101000020F85900000000000000FE1841000000C040A35241	f	f	840	2001-10-01	\N
006160	900	423	SERRAVALLE SCRIVIA	VILLANAVE	489070	4952616	IQ	ARPAPIEMONTE	SPM20	S	220.00	220.00	1991-10-03	17	IdrometricaQ	950	0101000020F859000000000000B8D91D41000000008AE45241	f	f	220	2007-01-01	\N
003162	900	410	VILLADOSSOLA OVESCA	VILLADOSSOLA	442653	5102039	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	259.00	259.00	1997-03-01	RI	IdrometricaQ	1021	0101000020F85900000000000074041B41000000C075765341	f	f	259	2004-01-01	\N
004034	900	421	BUSCA MAIRA	VALENTINO	379385	4930399	IQ	ARPAPIEMONTE	SP200	S	500.00	500.00	1990-06-08	17	IdrometricaQ	587	0101000020F859000000000000E4271741000000C0D7CE5241	f	f	500	2003-01-01	\N
002108	700	S2985	QUINTO VERCELLESE CERVO	PONTE S.S.230	451094	5025701	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	160.00	160.00	2002-01-31	RI	IdrometricaQ	896	0101000020F85900000000000058881B4100000040E92B5341	f	f	160	2003-01-01	\N
004130	700	386	MONDOVI' ELLERO	PONTE PIAZZA ELLERO	406101	4916088	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	390.00	390.00	2000-09-27	RI	IdrometricaQ	794	0101000020F85900000000000054C9184100000000DEC05241	f	f	390	2002-01-01	\N
001179	900	S2887	PARELLA CHIUSELLA	PONTE S.P.63	406046	5030506	IPTQ	PROVINCIADITORINO	SPM20	S	260.00	260.00	2002-01-31	17	IdrometricaQ	835	0101000020F85900000000000078C81841000000809A305341	f	f	260	2002-01-31	\N
001276	900	278	TRANA SANGONE	PONTE S.S.589	375630	4988307	IPTQ	PROVINCIADITORINO	SP200	S	371.00	371.00	2000-12-13	17	IdrometricaQ	985	0101000020F85900000000000038ED1641000000C064075341	f	f	371	2000-12-13	\N
002016	901	413	BORGOSESIA SESIA	ISOLELLA FRAZ. BORGOSESIA	442551	5065261	IPQ	ARPAPIEMONTE	SPM20	S	371.00	371.00	2009-06-24	17	IdrometricaQ	577	0101000020F859000000000000DC021B41000000408B525341	f	f	371	2009-06-23	\N
001186	900	276	PERRERO GERMANASCA	POMARETTO	355142	4978853	IPTQ	PROVINCIADITORINO	SP200	S	662.00	662.00	2000-06-21	17	IdrometricaQ	844	0101000020F85900000000000018AD15410000004029FE5241	f	f	662	2000-06-21	\N
004079	900	422	GAIOLA STURA DI DEMONTE	PIANO DI GAIOLA	373835	4910163	IQ	ARPAPIEMONTE	SP200	S	645.00	645.00	1992-01-29	17	IdrometricaQ	718	0101000020F8590000000000002CD11641000000C014BB5241	f	f	645	2003-01-01	\N
003078	700	378	GRAVELLONA STRONA	PONTE S.S.33	456216	5086278	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	210.00	210.00	1999-11-02	RI	IdrometricaQ	729	0101000020F85900000000000060D81B410000008011675341	f	f	210	2002-01-01	\N
003106	700	379	NOVARA AGOGNA	MADONNA DEL BOSCO	468063	5031113	IPTQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	146.00	146.00	2000-10-06	RI	IdrometricaQ	820	0101000020F8590000000000007C911C410000004032315341	f	f	146	2005-01-01	\N
009040	900	S2598	MURIALDO BORMIDA DIMILLESIMO	BORGATAAZZINI	432952	4906183	IPTQ	REGIONELIGURIA	SPM20	S	523.00	523.00	2002-02-27	RL	IdrometricaQ	813	0101000020F859000000000000E06C1A41000000C031B75241	f	f	523	2005-08-02	\N
002025	900	S3226	CAMPERTOGNO SESIA	PONTE S.S.299	424843	5072324	IQ	ARPAPIEMONTE	SPM20	S	820.00	820.00	2002-07-10	17	IdrometricaQ	600	0101000020F8590000000000002CEE19410000000071595341	f	f	820	2003-01-01	\N
002046	900	S3224	COSSATO STRONA	PONTE S.S.142	436329	5046678	IQ	ARPAPIEMONTE	SPM20	S	255.00	255.00	2002-06-26	17	IdrometricaQ	672	0101000020F859000000000000A4A11A410000008065405341	f	f	255	2004-01-01	\N
001113	900	S2980	GERMAGNANO BORGO STURA DI VIU'	PONTE S.P.32	377143	5011507	IQ	ARPAPIEMONTE	SPM20	S	575.00	575.00	2002-07-26	17	IdrometricaQ	723	0101000020F859000000000000DC041741000000C00C1E5341	f	f	575	2003-01-01	\N
001152	900	S4983	MEZZENILE STURA DI LANZO	PONTE VIA VILLA INFERIORE	374593	5017495	IQ	PROVINCIADITORINO	SPM20	S	605.00	605.00	2010-05-27	17	IdrometricaQ	782	0101000020F85900000000000004DD1641000000C0E5235341	f	f	605	2010-01-01	\N
001156	901	S4111	MONCALIERI PO	CORSO TRIESTE	395976	4984080	IQ	ARPAPIEMONTE	SPM20	S	220.00	220.00	2007-01-23	17	IdrometricaQ	790	0101000020F859000000000000202B18410000000044035341	f	f	220	2007-01-01	\N
001175	902	401	BEAULARD DORA DI BARDONECCHIA	PONTE S.S.335	323529	4990782	ITQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	1149.00	1149.00	1993-04-09	RI	IdrometricaQ	558	0101000020F85900000000000024BF134100000080CF095341	f	f	1149	2001-10-01	\N
001054	900	S4982	CANTOIRA STURA DI VALGRANDE	PONTE VIA SANTA CRISTINA	373377	5022129	IQ	PROVINCIADITORINO	SPM20	S	728.00	728.00	2010-05-25	17	IdrometricaQ	606	0101000020F85900000000000004CA1641000000406C285341	f	f	728	2010-01-01	\N
004082	700	S5166	DRONERO MAIRA	PONTE SUL TORRENTE MAIRA	367511	4924961	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	618.00	618.00	2009-12-30	RI	IdrometricaQ	696	0101000020F8590000000000005C6E16410000004088C95241	f	f	618	2010-01-01	\N
001197	900	131	POIRINO BANNA	DEPURATORE COMUNALE	407716	4975370	IPQ	ARPAPIEMONTE	SPM20	S	237.00	237.00	1995-12-12	17	IdrometricaQ	863	0101000020F85900000000000090E2184100000080C2FA5241	f	f	237	1996-01-01	\N
004193	900	S3886	ROCCHETTA BELBO	PONTE PERROCCHETTA VECCHIA	434606	4942915	IQ	ARPAPIEMONTE	SP200	S	284.00	284.00	2004-01-29	17	IdrometricaQ	914	0101000020F859000000000000B8861A41000000C010DB5241	f	f	284	2004-01-01	\N
001270	904	S3952	SUSA DORA RIPARIA VIA MAZZINI	PONTE VIA MAZZINI	346587	5000202	IQ	IRIDES.P.A.	SPM20	S	500.00	500.00	2004-08-05	17	IdrometricaQ	967	0101000020F8590000000000006C2715410000008002135341	f	f	500	2006-01-01	\N
001300	900	S5605	VILLAFRANCA PIEMONTE PO	PONTE SP139	382375	4959780	IQ	ARPAPIEMONTE	SPM20	S	257.00	257.00	2009-10-08	17	IdrometricaQ	1023	0101000020F8590000000000009C5617410000000089EB5241	f	f	257	2010-01-01	\N
004134	900	S3781	FRABOSA SOPRANA CORSAGLIA	PONTE SP183	407216	4903242	IPQ	PROVINCIADICUNEO	SPM20	S	683.00	683.00	2005-03-10	17	IdrometricaQ	714	0101000020F859000000000000C0DA18410000008052B45241	f	f	683	2008-01-01	\N
004215	901	S3736	LEVALDIGI GRANA	PONTE SP192	390339	4935084	IQ	PROVINCIADICUNEO	SPM20	S	367.00	367.00	2005-03-01	17	IdrometricaQ	760	0101000020F8590000000000000CD31741000000006BD35241	f	f	367	2008-01-01	\N
004127	900	S3930	MONASTEROLO CASOTTO	CONFLUENZA CASOTTO/CASTORELLO	415313	4907154	IQ	PROVINCIADICUNEO	SPM20	S	646.00	646.00	2005-03-10	17	IdrometricaQ	789	0101000020F859000000000000445919410000008024B85241	f	f	646	2008-01-01	\N
004185	900	S3926	ROBILANTE VERMENAGNA	PONTE SUL TORRENTE VERMENAGNA	381736	4902250	IPQ	PROVINCIADICUNEO	SPM20	S	751.00	751.00	2005-03-15	17	IdrometricaQ	909	0101000020F859000000000000A04C1741000000805AB35241	f	f	751	2008-01-01	\N
004068	901	S3716	SAN BARTOLOMEO PESIO	PONTE SP42	393379	4903036	IQ	PROVINCIADICUNEO	SPM20	S	733.00	733.00	2005-03-02	17	IdrometricaQ	932	0101000020F8590000000000008C021841000000001FB45241	f	f	733	2008-01-01	\N
004047	900	S3927	TORRETTE VARAITA	PONTE COMUNALE	349737	4938638	IQ	PROVINCIADICUNEO	SPM20	S	1153.00	1153.00	2005-04-21	17	IdrometricaQ	983	0101000020F859000000000000A458154100000080E3D65241	f	f	1153	2008-01-01	\N
002156	700	376	VARALLO MASTALLONE	LEFOLLE	442271	5075681	IQ	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	485.00	485.00	1999-11-24	RI	IdrometricaQ	1005	0101000020F8590000000000007CFE1A4100000040B85C5341	f	f	485	2002-01-01	\N
001272	909	S7421	TORINO SANGONE	PONTE CORSO UNIONE SOVIETICA	391275	4984894	IQ	ARPA PIEMONTE	SPM20	S	240.00	240.00	2015-10-20	17	IdrometricaQ	1062	0101000020F85900002A90842AF8E21741B992982140045341	f	f	240	2015-10-20	\N
004210	900	S3951	TORRE MONDOVI' CORSAGLIA	PONTE CAVA SP35	412625	4912493	IQ	ARPAPIEMONTE	SPM20	S	454.00	454.00	2004-05-19	17	IdrometricaQ	982	0101000020F859000000000000442F1941000000405BBD5241	f	f	454	2008-01-01	\N
010061	900	S2592	TIGLIETO ORBA	PONTE S.P.1	469736	4930378	IQ	REGIONELIGURIA	SPM20	S	500.00	500.00	2011-12-02	RL	IdrometricaQ	971	0101000020F859000000000000A0AB1C4100000080D2CE5241	f	f	500	2003-01-01	\N
004248	903	S3932	VINADIO STURA DI DEMONTE	PONTE SP238	349707	4907393	GIPQ	PROVINCIADICUNEO	SPM20	S	955.00	955.00	2005-03-09	17	IdrometricaQ	1026	0101000020F8590000000000002C5815410000004060B85241	f	f	955	2008-01-01	\N
003132	900	S3222	SANTINO SAN BERNARDINO	PONTE S.P.61	463305	5089535	IQ	ARPAPIEMONTE	SPM20	S	250.00	250.00	2002-06-27	17	IdrometricaQ	943	0101000020F85900000000000024471C41000000C03F6A5341	f	f	250	2003-01-01	\N
001201	907	S4336	SOUCHERES BASSES	SOUCHERES BASSES	339301	4988338	IQ	ARPAPIEMONTE	SPM20	S	1471.00	1471.00	2005-07-20	17	IdrometricaQ	959	0101000020F8590000CE0EDA3923B71441102DC8889E075341	f	f	1471	2007-01-01	\N
003100	900	442	MOMOAGOGNA	PONTE S.S.229	464790	5046697	IPTQ	ARPAPIEMONTE	SP200	S	213.00	213.00	2003-02-18	17	IdrometricaQ	788	0101000020F859000000000000585E1C41000000406A405341	f	f	213	2005-05-10	\N
002124	900	235	PASSOBREVE CERVO	PASSO BREVE	425108	5053640	IQ	ARPAPIEMONTE	SP200	S	593.00	593.00	2001-02-13	17	IdrometricaQ	840	0101000020F85900000000000050F219410000000032475341	f	f	593	2003-01-01	\N
001175	900	151	GAD	GAD	329988	4990162	HPRTV	SITAFS.P.A.	SP300	S	1065.00	1065.00	1990-12-19	17	Meteorologica	717	0101000020F85900009F8328C3012414415C1BB5E92E095341	f	f	1065	1990-12-19	\N
009017	900	203	CALIZZANO	PIANO	429680	4898688	PT	REGIONELIGURIA	SPM20	S	647.00	647.00	2002-02-24	RL	Meteorologica	594	0101000020F859000000000000C0391A4100000000E0AF5241	f	f	647	2002-02-28	\N
004051	900	318	CASTELLINALDO	BRIC TORTE	423075	4958076	HPT	ARPAPIEMONTE	SPM20	S	325.00	325.00	1995-11-08	17	Meteorologica	634	0101000020F8590000000000008CD2194100000000DFE95241	f	f	325	1995-11-08	\N
004089	901	292	FOSSANO STURA DI DEMONTE	PONTE S.P.231	398709	4931050	IQX	ARPAPIEMONTE	SPM20	S	330.00	330.00	1997-04-29	17	IdrometricaQ	713	0101000020F859000000000000D4551841000000807ACF5241	t	f	330	2000-01-01	\N
006037	900	430	CASAL CERMELLI ORBA	PONTE S.P.181	470953	4964651	GIQX	ARPAPIEMONTE	SP200	S	102.00	102.00	1992-01-15	17	IdrometricaQ	618	0101000020F859000000000000A4BE1C41000000C04AF05241	t	f	102	2009-01-01	\N
004171	700	381	POLONGHERA VARAITA	PONTE VECCHIO S.S.663	389255	4962153	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	246.00	246.00	2000-06-08	RI	IdrometricaQ	865	0101000020F8590000000000001CC2174100000040DAED5241	t	f	246	2002-01-01	\N
004179	700	382	RACCONIGI MAIRA	PONTE S.P.29	394619	4958191	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	259.00	259.00	2000-07-25	RI	IdrometricaQ	897	0101000020F859000000000000EC151841000000C0FBE95241	t	f	259	2002-01-01	\N
001236	700	374	SAN BENIGNO ORCO	PONTE S.P.40	406394	5011258	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	219.00	219.00	2000-06-08	RI	IdrometricaQ	933	0101000020F859000000000000E8CD184100000080CE1D5341	t	f	219	2002-01-01	\N
001272	701	371	TORINO DORA RIPARIA	PONTE WASHINGTON	399175	4992374	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	219.00	219.00	2000-10-11	RI	IdrometricaQ	974	0101000020F8590000000000001C5D1841000000805D0B5341	t	f	219	2002-01-01	\N
001272	702	372	TORINO STURA DI LANZO	PONTE CORSO GIULIO CESARE	398334	4996316	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	221.00	221.00	2001-02-01	RI	IdrometricaQ	979	0101000020F859000000000000F84F184100000000370F5341	t	f	221	2002-01-01	\N
006177	900	S2115	VALENZA PO	PONTE S.S.494 VALENZA/TORRE BERETTI	471070	4988876	IQX	ARPAPIEMONTE	SPM20	S	90.00	90.00	2004-10-26	17	IdrometricaQ	996	0101000020F85900000000000078C01C4100000000F3075341	t	t	90	2003-02-19	\N
006086	700	221	GUAZZORA SCRIVIA	MOLINO DEI TORTI	490340	4986342	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP300	S	76.00	76.00	2000-10-02	RI	IdrometricaQ	737	0101000020F85900000000000090ED1D410000008079055341	t	f	76	2001-01-01	\N
001058	900	412	CARIGNANO_PO	PONTE S.P.122	396763	4973852	IQX	ARPAPIEMONTE	SP200	S	240.00	240.00	1991-10-01	17	IdrometricaQ	611	0101000020F8590000000000006C3718410000000047F95241	t	t	240	2007-01-01	\N
006087	700	216	ISOLA S.ANTONIO PO	PONTES.S.211	486057	4987180	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	76.00	76.00	1995-01-01	RI	IdrometricaQ	741	0101000020F859000000000000A4AA1D41000000004B065341	t	t	76	1996-01-01	\N
006003	902	S6833	ALESSANDRIA TANARO	PONTE TIZIANO	468597	4973449	IQX	AIPO	\N	S	87.00	87.00	2013-11-20	\N	IdrometricaQ	1042	0101000020F8590000E4867FB6BB9A1C4164020F1B32F95241	t	f	87	2015-01-01	\N
001300	700	370	VILLAFRANCA PELLICE	PONTE S.P.139	381427	4963366	IPTQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SP200	S	260.00	260.00	2000-10-05	RI	IdrometricaQ	1022	0101000020F859000000000000CC4717410000008009EF5241	t	f	260	2005-01-01	\N
004086	900	435	FARIGLIANO TANARO	PONTE S.P.12	412790	4930094	IPQX	ARPAPIEMONTE	SPM20	S	263.00	263.00	1995-09-20	17	IdrometricaQ	699	0101000020F859000000000000D8311941000000808BCE5241	t	f	263	2002-01-01	\N
005005	900	138	ASTI TANARO	BORGO TANARO	437873	4970662	HIPTQX	ARPAPIEMONTE	SP200	S	117.00	117.00	1998-05-19	17	IdrometricaQ	541	0101000020F859000000000000C4B91A410000008029F65241	t	f	117	1998-05-20	\N
004003	900	429	ALBA TANARO	PONTE S.S.29	423047	4950863	HIPRTVQX	ARPAPIEMONTE	SP200	S	172.00	172.00	1991-10-02	RI	IdrometricaQ	522	0101000020F8590000000000001CD21941000000C0D3E25241	t	f	172	2001-01-01	\N
001253	700	S4825	SAN SEBASTIANO PO	PONTE SP94	417034	5002843	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	174.00	174.00	2007-02-28	RI	IdrometricaQ	940	0101000020F85900000000000028741941000000C096155341	t	t	174	2007-01-01	\N
001272	703	S4816	TORINO MURAZZI PO	PONTE REGINA MARGHERITA	398412	4991541	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	223.00	223.00	2007-02-28	RI	IdrometricaQ	976	0101000020F85900000000000030511841000000408D0A5341	t	t	223	2007-01-01	\N
003096	900	604	CANDOGLIA TOCE	CANDOGLIA	455291	5091605	IPTQX	ARPAPIEMONTE	SP200	S	201.00	201.00	1990-03-01	17	IdrometricaQ	602	0101000020F859000000000000ECC91B4100000040456C5341	t	f	201	2000-01-01	\N
001271	900	414	TAVAGNASCO DORA BALTEA	PONTE PER SETTIMO VITTONE	408502	5044703	IQX	ARPAPIEMONTE	SPM20	S	270.00	270.00	1990-07-13	17	IdrometricaQ	969	0101000020F859000000000000D8EE1841000000C0773E5341	t	f	270	2002-01-01	\N
002049	900	473	CRESCENTINO PO	PONTE STRADA CRESCENTINO / VERRUA SAVOIA	429362	5003439	IQX	AGENZIAINTERREGIONALEDELPO	SP200	S	158.00	158.00	1997-10-30	MP	IdrometricaQ	679	0101000020F859000000000000C8341A41000000C02B165341	t	t	158	2013-01-01	\N
005029	900	427	CASTELNUOVO BELBO	PONTEVIAROMA	454121	4960917	IQX	ARPAPIEMONTE	SPM20	S	122.00	122.00	1992-01-14	17	IdrometricaQ	636	0101000020F859000000000000A4B71B4100000040A5EC5241	t	f	122	2003-01-01	\N
006043	900	431	CASSINE BORMIDA	PRESA CANALE CARLO ALBERTO	463868	4955633	IQX	ARPAPIEMONTE	SP200	S	123.00	123.00	1992-02-04	RI	IdrometricaQ	627	0101000020F859000000000000F04F1C41000000407CE75241	t	f	123	2007-01-01	\N
006091	900	177	MASIO TANARO	PONTE S.P.247	453525	4969048	IPQX	ARPAPIEMONTE	SP200	S	105.00	105.00	1998-05-20	17	IdrometricaQ	777	0101000020F85900000000000054AE1B410000000096F45241	t	f	105	1998-05-21	\N
018107	700	200	PALESTRO SESIA	PRESA ROGGIONE SARTIRANA	464018	5014910	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	121.00	121.00	1995-01-01	RI	IdrometricaQ	832	0101000020F85900000000000048521C41000000805F215341	t	f	121	1995-03-16	\N
006039	901	440	CASALE MONFERRATO PO	PONTE S.S.31	456657	4999051	IQX	ARPAPIEMONTE	SP200	S	115.00	115.00	2003-02-19	17	IdrometricaQ	620	0101000020F85900000000000044DF1B41000000C0E2115341	t	t	115	2009-01-01	\N
004095	900	313	GARESSIO TANARO	BORGOPONTE	421390	4894972	IX	COMUNITA'MONTANAVALLIMONGIA,CEVETTAELANGACEBANA	SP200	S	582.00	582.00	1995-11-22	17	Idrometrica	721	0101000020F85900000000000038B81941000000003FAC5241	f	f	582	2000-01-01	\N
004108	900	328	PIANTORRETANARO	PONTE S.P.115	418249	4918994	IQX	ARPAPIEMONTE	SP200	S	345.00	345.00	1996-04-24	17	IdrometricaQ	855	0101000020F8590000000000002487194100000080B4C35241	f	f	345	2000-01-01	\N
006105	700	218	MONTECASTELLO TANARO	MONTECASTELLO	475186	4977273	IQX	REGIONEPIEMONTEDIREZIONEAMBIENTE	SPM20	S	216.00	216.00	1995-01-01	RI	IdrometricaQ	803	0101000020F859000000000000C8001D41000000409EFC5241	t	f	216	1995-01-01	\N
004025	500	\N	BORGO SAN DALMAZZO 	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1063	\N	f	f	\N	\N	\N
001272	907	446	TORINO GIARDINI REALI	GIARDINI REALI	397112	4991946	BGHNPRST	ARPAPIEMONTE	SPM20	S	239.00	239.00	2004-08-05	17	Nivometrica	975	0101000020F8590000A51A81F9FB3A1841075FE53BE80A5341	f	f	239	2004-08-06	\N
002158	900	198	VERCELLI	CASELLO RUGGERINA	452237	5019386	GHPRTVW	ARPAPIEMONTE	SPM20	S	132.00	132.00	1993-06-17	17	MeteorologicaW	1014	0101000020F859000000000000349A1B4100000080BE255341	f	f	132	1993-06-17	\N
001059	901	S3339	CARMAGNOLA PLUVIO	ISTITUTO AGRARIA	396335	4971359	PRVW	ARPAPIEMONTE	SPM20	N	232.00	232.00	2003-02-18	17	MeteorologicaW	615	0101000020F859000000000000BC301841000000C0D7F65241	f	f	232	\N	\N
001022	903	S3238	BARDONECCHIA PIAN DEL SOLE	PIAN DEL SOLE	319383	4992738	BFGHNPTVW	ARPAPIEMONTE	SPM20	S	1585.00	1585.00	2003-02-06	17	MeteorologicaW	552	0101000020F8590000000000005C7E134100000080B80B5341	f	f	1585	2003-02-07	\N
004084	900	S2576	DIGA DEL CHIOTAS	DIGA DEL CHIOTAS	366881	4891327	GNPRTW	ARPAPIEMONTE	SPM20	S	2020.00	2020.00	2001-06-27	17	MeteorologicaW	690	0101000020F85900000000000084641641000000C0AFA85241	f	f	2020	2001-10-01	\N
006003	900	115	ALESSANDRIA LOBBI	LOBBI DEPURATORE COMUNALE	476727	4976201	BGHPRTVW	ARPAPIEMONTE	SPM20	S	90.00	90.00	1988-05-11	17	MeteorologicaW	525	0101000020F859000000000000DC181D410000004092FB5241	f	f	90	1988-05-11	\N
003032	900	114	CAMERI	CASCINA BORNAGO	476179	5044074	BHPTVW	ARPAPIEMONTE	SPM20	S	173.00	173.00	1988-05-03	17	MeteorologicaW	598	0101000020F85900005987684028101D41FD4AAC0ADD3D5341	f	f	173	1988-05-04	\N
001263	906	S2893	SESTRIERE ALPETTE	MONTE ALPETTE	333556	4979878	BFHPTVW	ARPAPIEMONTE	SPM20	S	2250.00	2250.00	2003-02-06	17	MeteorologicaW	952	0101000020F859000000000000D05B14410000008029FF5241	f	f	2250	2003-02-14	\N
001063	900	S2896	CASELLE	CASELLE TORINESE	394093	5004633	BFHPRTVW	ARPAPIEMONTE	SPM20	S	300.00	300.00	2003-11-18	17	MeteorologicaW	625	0101000020F859000045E21E8E290F1841DD7D50BA0D185341	f	f	300	2003-11-19	\N
004215	900	ML001	AEROPORTO CUNEO LEVALDIGI	S.S.N.20 LEVALDIGI CN 12040	389764	4932725	BHPTVW	ARPAPIEMONTE	MILOS	N	382.00	382.00	1999-10-06	17	Z	519	0101000020F85900000000000010CA1741000000401DD15241	f	f	382	\N	\N
\.


--
-- Name: rete_meteoidrografica_2_gid_seq; Type: SEQUENCE SET; Schema: dati_di_base; Owner: postgres
--

SELECT pg_catalog.setval('rete_meteoidrografica_2_gid_seq', 1070, true);


--
-- Data for Name: soglie_idrometriche; Type: TABLE DATA; Schema: dati_di_base; Owner: postgres
--

COPY soglie_idrometriche (codice_istat_comune, progr_punto_com, id_parametro, codice1, codice2, codice3, data_agg, autore_agg, q_equilibrio, dmv_base, dmv_deroga, zero_idrometrico) FROM stdin;
002016	900	PORTATA	1125.0	1500.0	2700.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
002025	900	PORTATA	115.0	150.0	300.0	2015-09-21	GRAZIADEI	\N	0.77	\N	\N
002032	700	PORTATA	150.0	200.0	420.0	2015-09-17	GRAZIADEI	\N	0.86	\N	\N
002046	900	PORTATA	60.0	80.0	\N	2015-09-21	GRAZIADEI	\N	0.24	\N	\N
002049	900	PORTATA	1900.0	2500.0	4500.0	2015-09-21	GRAZIADEI	\N	41.60	13.87	\N
002105	900	PORTATA	150.0	200.0	450.0	2015-09-21	GRAZIADEI	\N	0.68	\N	\N
002108	700	PORTATA	490.0	850.0	1400.0	2015-09-17	GRAZIADEI	\N	3.42	\N	\N
002124	900	PORTATA	150.0	200.0	350.0	2015-09-21	GRAZIADEI	\N	0.43	\N	\N
002156	700	PORTATA	265.0	350.0	550.0	2015-09-21	GRAZIADEI	\N	0.79	\N	\N
002160	900	PORTATA	165.0	220.0	400.0	2015-09-17	GRAZIADEI	\N	0.81	0.27	\N
003030	900	PORTATA	38.0	50.0	\N	2015-09-17	GRAZIADEI	\N	0.18	\N	\N
003056	900	PORTATA	115.0	150.0	\N	2015-09-21	GRAZIADEI	\N	1.78	\N	\N
003061	902	PORTATA	160.0	545.0	840.0	2015-09-21	GRAZIADEI	\N	5.66	\N	\N
003078	700	PORTATA	100.0	200.0	440.0	2015-09-21	GRAZIADEI	\N	1.65	\N	\N
003092	900	PORTATA	135.0	180.0	\N	2015-09-21	GRAZIADEI	\N	0.22	\N	\N
003096	900	PORTATA	750.0	980.0	1900.0	2015-09-17	GRAZIADEI	\N	8.98	\N	\N
003100	900	PORTATA	115.0	150.0	300.0	2010-09-15	GRAZIADEI	\N	0.90	0.30	\N
003101	900	PORTATA	98.0	130.0	300.0	2015-09-21	GRAZIADEI	\N	0.37	\N	\N
003106	700	PORTATA	115.0	150.0	300.0	2015-09-21	GRAZIADEI	\N	0.98	0.32	\N
003132	900	PORTATA	180.0	400.0	550.0	2015-09-21	GRAZIADEI	\N	0.75	\N	\N
004003	900	PORTATA	810.0	1100.0	2000.0	2015-09-17	GRAZIADEI	\N	8.50	\N	\N
004025	700	PORTATA	165.0	220.0	540.0	2015-09-21	GRAZIADEI	\N	3.29	\N	\N
004034	900	PORTATA	98.0	130.0	230.0	2015-09-21	GRAZIADEI	\N	2.22	0.74	\N
004035	700	PORTATA	188.0	250.0	450.0	2015-09-17	GRAZIADEI	\N	0.29	\N	\N
004047	900	PORTATA	42.0	55.0	\N	2015-09-21	GRAZIADEI	\N	0.56	\N	\N
004073	900	PORTATA	120.0	160.0	\N	2015-09-21	GRAZIADEI	\N	0.31	\N	\N
004079	900	PORTATA	68.0	90.0	200.0	2015-09-17	GRAZIADEI	\N	2.39	\N	\N
004081	900	PORTATA	20.0	40.0	70.0	2013-11-06	GRAZIADEI	\N	\N	\N	\N
004086	900	PORTATA	530.0	750.0	1500.0	2015-09-17	GRAZIADEI	\N	2.05	\N	\N
004089	901	PORTATA	250.0	370.0	670.0	2015-09-17	GRAZIADEI	\N	4.50	1.50	\N
004095	900	PORTATA	90.0	190.0	370.0	2015-09-21	GRAZIADEI	\N	0.48	\N	\N
004108	900	PORTATA	170.0	330.0	620.0	2015-09-17	GRAZIADEI	\N	0.72	0.24	\N
004118	900	PORTATA	105.0	140.0	\N	2015-09-21	GRAZIADEI	\N	\N	\N	\N
004127	900	PORTATA	45.0	60.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004130	700	PORTATA	115.0	150.0	\N	2015-09-17	GRAZIADEI	\N	0.30	\N	\N
004134	900	PORTATA	45.0	60.0	\N	2015-09-21	GRAZIADEI	\N	0.17	\N	\N
004139	700	PORTATA	45.0	60.0	130.0	2015-09-16	GRAZIADEI	\N	0.32	\N	\N
004155	901	PORTATA	80.0	140.0	300.0	2015-09-21	GRAZIADEI	\N	0.30	\N	\N
004171	700	PORTATA	150.0	220.0	350.0	2015-09-16	GRAZIADEI	\N	1.73	0.58	\N
004179	700	PORTATA	100.0	190.0	300.0	2015-09-16	GRAZIADEI	\N	3.25	1.08	\N
004180	900	PORTATA	90.0	120.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004185	900	PORTATA	68.0	90.0	\N	2015-09-21	GRAZIADEI	\N	0.56	\N	\N
004190	902	PORTATA	60.0	80.0	\N	2015-09-21	GRAZIADEI	\N	0.14	\N	\N
004197	900	PORTATA	85.0	130.0	250.0	2015-09-16	GRAZIADEI	\N	1.05	\N	\N
004215	901	PORTATA	60.0	80.0	190.0	2015-09-21	GRAZIADEI	\N	0.96	0.32	\N
004224	900	PORTATA	65.0	85.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004233	901	PORTATA	105.0	135.0	\N	2015-09-21	GRAZIADEI	\N	1.77	\N	\N
004248	903	PORTATA	27.0	35.0	\N	2015-09-21	GRAZIADEI	\N	0.89	\N	\N
005005	900	PORTATA	1000.0	1300.0	2100.0	2015-09-21	GRAZIADEI	\N	8.70	\N	\N
005029	900	PORTATA	185.0	250.0	400.0	2015-09-17	GRAZIADEI	\N	0.08	\N	\N
005037	700	PORTATA	200.0	330.0	520.0	2015-09-21	GRAZIADEI	\N	0.35	\N	\N
005064	700	PORTATA	375.0	500.0	850.0	2015-09-17	GRAZIADEI	\N	0.35	\N	\N
005097	900	PORTATA	26.0	35.0	70.0	2015-09-21	GRAZIADEI	\N	0.01	\N	\N
006003	901	PORTATA	1050.0	1400.0	2000.0	2015-09-17	GRAZIADEI	\N	2.14	\N	\N
006009	700	PORTATA	340.0	450.0	800.0	2015-09-21	GRAZIADEI	\N	0.60	\N	\N
006012	700	PORTATA	500.0	700.0	1400.0	2015-09-17	GRAZIADEI	\N	1.20	0.40	\N
006018	900	PORTATA	188.0	250.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
006036	900	PORTATA	205.0	270.0	\N	2015-09-21	GRAZIADEI	\N	0.23	\N	\N
006037	900	PORTATA	525.0	700.0	1500.0	2015-09-21	GRAZIADEI	\N	1.41	0.47	\N
006043	900	PORTATA	540.0	870.0	1400.0	2015-09-17	GRAZIADEI	\N	1.01	0.34	\N
006086	700	PORTATA	600.0	800.0	1500.0	2015-09-17	GRAZIADEI	\N	1.26	\N	\N
006087	700	PORTATA	4000.0	5400.0	8000.0	2015-09-17	GRAZIADEI	\N	78.20	\N	\N
006091	900	PORTATA	870.0	1300.0	2000.0	2015-09-21	GRAZIADEI	\N	8.70	\N	\N
006105	700	PORTATA	1400.0	1750.0	2600.0	2015-09-17	GRAZIADEI	\N	14.60	\N	\N
006160	900	PORTATA	600.0	800.0	1500.0	2015-09-17	GRAZIADEI	\N	1.04	\N	\N
006177	900	PORTATA	2600.0	3300.0	6000.0	2015-09-17	GRAZIADEI	\N	51.20	\N	\N
009040	900	PORTATA	70.0	120.0	200.0	2013-11-06	GRAZIADEI	\N	\N	\N	\N
010027	900	PORTATA	92.0	122.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
010061	900	PORTATA	120.0	230.0	400.0	2015-09-21	GRAZIADEI	\N	0.21	\N	\N
018033	900	PORTATA	4125.0	5500.0	8000.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
018081	900	PORTATA	5300.0	6500.0	7900.0	2010-10-13	GRAZIADEI	\N	\N	\N	\N
018107	700	PORTATA	910.0	2000.0	3200.0	2015-09-17	GRAZIADEI	\N	11.89	\N	\N
003117	900	IDRO1	\N	2.0	3.0	2001-09-27	MENON	\N	\N	\N	\N
006068	700	IDROS	\N	\N	\N	2002-03-06	D'ARNESE	\N	\N	\N	\N
006174	700	IDROS	\N	3.5	\N	2001-09-27	MENON	\N	\N	\N	\N
001058	700	IDRO	3.1	3.7	5.2	2013-11-06	GRAZIADEI	\N	\N	\N	\N
002016	901	PORTATA	420.0	700.0	1400.0	2016-08-29	GRAZIADEI	\N	4.08	\N	\N
001156	700	IDRO	2.3	3.0	\N	2013-11-06	GRAZIADEI	\N	\N	\N	\N
001156	700	PORTATA	120.0	230.0	330.0	2015-09-21	GRAZIADEI	\N	0.83	\N	\N
004125	900	PORTATA	18.0	40.0	100.0	2013-11-06	GRAZIADEI	\N	\N	\N	\N
004068	901	PORTATA	60.0	110.0	250.0	2015-09-21	GRAZIADEI	\N	0.18	0.06	\N
004082	700	PORTATA	75.0	130.0	\N	2015-09-21	GRAZIADEI	\N	1.45	0.48	\N
001156	901	PORTATA	500.0	850.0	1400.0	2015-09-21	GRAZIADEI	\N	10.70	\N	\N
006039	901	PORTATA	1900.0	2500.0	4500.0	2015-09-17	GRAZIADEI	\N	41.60	13.87	\N
006003	902	PORTATA	870.0	1300.0	2000.0	2015-09-21	GRAZIADEI	\N	9.60	\N	\N
001276	900	PORTATA	80.0	160.0	\N	2017-04-11	GRAZIADEI	\N	0.69	\N	\N
001270	904	PORTATA	100.0	150.0	\N	2017-04-11	GRAZIADEI	\N	1.74	\N	\N
004043	700	PORTATA	120.0	200.0	\N	2017-04-11	GRAZIADEI	\N	0.53	\N	\N
001066	900	PORTATA	300.0	400.0	\N	2016-08-29	GRAZIADEI	\N	3.49	1.16	\N
001300	900	PORTATA	310.0	450.0	\N	2016-09-20	GRAZIADEI	\N	1.61	0.54	\N
001272	909	PORTATA	\N	\N	\N	2016-08-18	ZACCAGNINO	\N	0.83	\N	\N
001179	900	PORTATA	150.0	250.0	\N	2017-04-11	GRAZIADEI	\N	0.92	\N	\N
001054	900	PORTATA	50.0	75.0	\N	2017-04-11	GRAZIADEI	\N	0.61	\N	\N
004077	902	PORTATA	15.0	30.0	\N	2017-04-11	GRAZIADEI	\N	0.14	\N	\N
001152	900	PORTATA	95.0	140.0	\N	2017-04-11	GRAZIADEI	\N	3.96	1.32	\N
003061	901	PORTATA	\N	\N	\N	2016-09-06	GRAZIADEI	\N	0.39	\N	\N
004193	900	PORTATA	35.0	50.0	\N	2017-04-11	GRAZIADEI	\N	0.05	\N	\N
003152	900	PORTATA	\N	\N	\N	2016-09-06	GRAZIADEI	\N	0.64	\N	\N
001201	907	PORTATA	12.0	25.0	\N	2017-04-11	GRAZIADEI	\N	0.24	\N	\N
004210	900	PORTATA	120.0	200.0	\N	2017-04-11	GRAZIADEI	\N	0.24	\N	\N
001292	900	PORTATA	110.0	190.0	\N	2017-04-11	GRAZIADEI	\N	0.63	\N	\N
003162	900	PORTATA	\N	\N	\N	2016-09-06	GRAZIADEI	\N	0.69	\N	\N
006101	900	PORTATA	70.0	110.0	\N	2017-04-11	GRAZIADEI	\N	0.10	\N	\N
001054	900	IDRO	0.4	0.7	\N	2017-04-11	GRAZIADEI	\N	\N	\N	\N
001066	900	IDRO	1.1	1.5	\N	2016-09-20	GRAZIADEI	\N	\N	\N	\N
001272	909	IDRO	1.5	\N	\N	2016-09-20	GRAZIADEI	\N	\N	\N	\N
004077	902	IDRO	1.0	1.3	\N	2016-09-20	GRAZIADEI	\N	\N	\N	\N
004213	900	IDRO	2.1	2.8	\N	2016-09-20	GRAZIADEI	\N	\N	\N	\N
005005	902	IDRO	1.0	1.3	\N	2016-09-20	GRAZIADEI	\N	\N	\N	\N
001152	900	IDRO	2.0	2.6	\N	2017-04-11	GRAZIADEI	\N	\N	\N	\N
007017	901	IDRO	2.6	3.5	3.9	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007017	901	PORTATA	357.0	591.0	713.0	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007034	900	IDRO	3.3	4.7	5.7	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007034	900	PORTATA	403.0	671.0	960.0	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007045	901	IDRO	0.9	1.1	1.3	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007045	901	PORTATA	300.0	523.0	850.0	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
007051	900	PORTATA	257.0	535.0	926.0	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
009048	900	PORTATA	120.0	230.0	\N	2017-04-11	GRAZIADEI	\N	\N	\N	\N
006009	700	IDRO	3.4	4.5	5.5	2010-09-15	GRAZIADEI	\N	\N	\N	\N
006018	900	IDRO	1.5	2.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
006043	700	IDRO	2.1	2.8	3.8	2013-11-06	GRAZIADEI	\N	\N	\N	\N
007051	900	IDRO	3.2	4.3	5.2	2016-10-03	ZACCAGNINO	\N	\N	\N	\N
001034	700	PORTATA	195.0	260.0	500.0	2015-09-21	GRAZIADEI	\N	1.04	\N	\N
001058	700	PORTATA	440.0	620.0	1150.0	2015-09-21	GRAZIADEI	\N	10.70	\N	\N
001058	900	PORTATA	440.0	620.0	1150.0	2015-09-21	GRAZIADEI	\N	10.70	\N	\N
001068	700	PORTATA	1050.0	1400.0	2200.0	2015-09-21	GRAZIADEI	\N	20.80	\N	\N
001098	901	PORTATA	225.0	300.0	1000.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001109	900	PORTATA	195.0	260.0	500.0	2015-09-17	GRAZIADEI	\N	0.33	\N	\N
001113	900	PORTATA	188.0	250.0	400.0	2015-09-21	GRAZIADEI	\N	0.91	\N	\N
001127	700	PORTATA	98.0	130.0	170.0	2015-09-17	GRAZIADEI	\N	0.64	\N	\N
001128	901	PORTATA	320.0	580.0	1100.0	2015-09-17	GRAZIADEI	\N	3.53	\N	\N
001139	901	PORTATA	75.0	100.0	210.0	2015-09-16	GRAZIADEI	\N	0.94	0.31	\N
001175	901	PORTATA	60.0	80.0	140.0	2015-09-21	GRAZIADEI	\N	0.67	\N	\N
001175	902	PORTATA	40.0	55.0	85.0	2015-09-21	GRAZIADEI	\N	0.59	\N	\N
001186	900	PORTATA	75.0	100.0	350.0	2015-09-21	GRAZIADEI	\N	0.70	\N	\N
001191	901	PORTATA	262.0	350.0	570.0	2015-09-21	GRAZIADEI	\N	2.29	\N	\N
001197	900	PORTATA	70.0	110.0	170.0	2015-09-21	GRAZIADEI	\N	0.09	\N	\N
001197	901	PORTATA	38.0	50.0	90.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001199	700	PORTATA	60.0	160.0	300.0	2015-09-21	GRAZIADEI	\N	1.01	\N	\N
001236	700	PORTATA	450.0	600.0	1200.0	2015-09-17	GRAZIADEI	\N	4.86	1.62	\N
001253	700	PORTATA	1000.0	1800.0	3200.0	2015-09-17	GRAZIADEI	\N	27.30	9.10	\N
001257	900	PORTATA	90.0	120.0	180.0	2015-09-21	GRAZIADEI	\N	0.12	\N	\N
001270	903	PORTATA	30.0	50.0	80.0	2015-09-21	GRAZIADEI	\N	0.46	\N	\N
001271	900	PORTATA	540.0	800.0	1300.0	2016-05-06	GRAZIADEI	\N	12.11	\N	\N
001272	700	PORTATA	640.0	850.0	1400.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001272	701	PORTATA	160.0	290.0	490.0	2015-09-17	GRAZIADEI	\N	4.58	1.53	\N
001272	702	PORTATA	520.0	730.0	1400.0	2015-09-17	GRAZIADEI	\N	4.64	\N	\N
001272	703	PORTATA	680.0	900.0	1500.0	2015-09-17	GRAZIADEI	\N	13.00	\N	\N
001293	700	PORTATA	675.0	900.0	1800.0	2015-09-17	GRAZIADEI	\N	19.49	6.49	\N
001300	700	PORTATA	220.0	430.0	750.0	2015-09-16	GRAZIADEI	\N	6.87	2.29	\N
001068	700	IDRO	3.6	4.8	6.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001082	701	IDRO	1.8	2.4	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001098	901	IDRO	1.5	2.0	3.3	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001127	700	IDRO	3.5	4.7	5.6	2015-05-18	GRAZIADEI	\N	\N	\N	\N
001197	901	IDRO	2.0	2.7	3.5	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001270	902	IDRO	2.1	2.8	3.8	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001272	700	IDRO	2.3	3.0	4.2	2010-09-15	GRAZIADEI	\N	\N	\N	\N
002016	900	IDRO	2.3	3.0	4.5	2010-09-15	GRAZIADEI	\N	\N	\N	\N
003056	901	IDRO	2.1	2.8	3.5	2010-09-15	GRAZIADEI	\N	\N	\N	\N
003092	900	IDRO	1.9	2.6	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
003101	900	IDRO	1.5	2.0	2.8	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004003	700	IDRO	1.9	2.5	4.1	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004025	700	IDRO	1.5	2.0	3.0	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004035	700	IDRO	2.5	3.3	4.5	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004042	900	IDRO	3.2	4.2	5.3	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004118	900	IDRO	2.7	3.5	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
004224	900	IDRO	1.8	2.4	\N	2010-09-15	GRAZIADEI	\N	\N	\N	\N
001034	700	IDRO	1.5	2.0	3.0	2010-09-15	GRAZIADEI	\N	\N	\N	181.74
001058	900	IDRO	3.1	3.7	5.2	2013-11-06	GRAZIADEI	\N	\N	\N	221.65
001109	900	IDRO	1.5	1.9	2.5	2010-09-15	GRAZIADEI	\N	\N	\N	263.85
001113	900	IDRO	2.5	3.3	4.0	2010-09-15	GRAZIADEI	\N	\N	\N	561.06
001128	901	IDRO	1.9	2.5	3.4	2013-11-06	GRAZIADEI	\N	\N	\N	452.20
001139	901	IDRO	1.1	1.5	2.2	2010-09-15	GRAZIADEI	\N	\N	\N	465.93
001156	901	IDRO	3.7	4.9	6.4	2013-11-06	GRAZIADEI	\N	\N	\N	212.57
001175	901	IDRO	1.1	1.5	2.0	2010-09-15	GRAZIADEI	\N	\N	\N	1071.29
001175	902	IDRO	1.2	1.6	2.1	2010-09-15	GRAZIADEI	\N	\N	\N	1134.80
001179	900	IDRO	1.3	1.8	\N	2010-09-15	GRAZIADEI	\N	\N	\N	249.42
001186	900	IDRO	2.2	3.0	4.0	2010-09-15	GRAZIADEI	\N	\N	\N	649.19
001191	901	IDRO	1.5	2.0	3.0	2010-09-15	GRAZIADEI	\N	\N	\N	402.72
001197	900	IDRO	4.4	5.2	6.2	2010-11-22	GRAZIADEI	\N	\N	\N	231.35
001199	700	IDRO	2.6	3.4	\N	2013-11-06	GRAZIADEI	\N	\N	\N	441.40
001201	907	IDRO	0.8	1.1	\N	2016-09-20	GRAZIADEI	\N	\N	\N	1459.52
001236	700	IDRO	2.3	2.6	3.6	2010-09-15	GRAZIADEI	\N	\N	\N	210.02
001253	700	IDRO	3.3	4.4	5.9	2013-11-06	GRAZIADEI	\N	\N	\N	164.79
001257	900	IDRO	3.4	4.5	5.5	2010-09-15	GRAZIADEI	\N	\N	\N	227.78
001270	903	IDRO	1.0	1.4	\N	2017-11-28	GRAZIADEI	\N	\N	\N	495.13
001270	904	IDRO	1.8	2.4	3.6	2017-04-11	GRAZIADEI	\N	\N	\N	492.33
001271	900	IDRO	2.5	3.1	4.0	2016-05-06	GRAZIADEI	\N	\N	\N	262.52
001272	701	IDRO	2.6	3.4	4.1	2013-11-06	GRAZIADEI	\N	\N	\N	210.68
001272	702	IDRO	1.8	2.2	3.2	2010-09-15	GRAZIADEI	\N	\N	\N	214.32
001272	703	IDRO	2.9	3.5	4.7	2010-09-15	GRAZIADEI	\N	\N	\N	209.71
001276	900	IDRO	1.5	2.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	363.54
001292	900	IDRO	1.5	2.2	3.0	2016-02-25	GRAZIADEI	\N	\N	\N	246.06
001293	700	IDRO	2.6	3.5	4.5	2010-09-15	GRAZIADEI	\N	\N	\N	156.30
001300	700	IDRO	1.8	2.4	3.2	2013-11-06	GRAZIADEI	\N	\N	\N	249.61
001300	900	IDRO	2.5	3.3	\N	2016-09-20	GRAZIADEI	\N	\N	\N	245.53
002016	901	IDRO	3.5	4.6	5.9	2013-11-06	GRAZIADEI	\N	\N	\N	354.90
002025	900	IDRO	1.9	2.5	4.0	2010-09-15	GRAZIADEI	\N	\N	\N	810.30
002032	700	IDRO	2.4	3.2	4.2	2010-09-15	GRAZIADEI	\N	\N	\N	176.21
002046	900	IDRO	2.3	3.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	247.42
002049	900	IDRO	3.6	4.0	5.0	2010-09-15	GRAZIADEI	\N	\N	\N	145.82
002105	900	IDRO	2.3	3.0	3.8	2010-09-15	GRAZIADEI	\N	\N	\N	400.70
002108	700	IDRO	1.9	2.5	3.5	2010-09-15	GRAZIADEI	\N	\N	\N	132.81
002124	900	IDRO	3.8	5.0	6.0	2010-09-15	GRAZIADEI	\N	\N	\N	574.01
002156	700	IDRO	3.4	4.5	6.0	2010-09-15	GRAZIADEI	\N	\N	\N	471.28
002160	900	IDRO	1.4	1.8	2.5	2010-09-15	GRAZIADEI	\N	\N	\N	295.99
003030	900	IDRO	2.1	2.8	\N	2010-09-15	GRAZIADEI	\N	\N	\N	170.96
003056	900	IDRO	1.4	1.8	2.5	2010-09-15	GRAZIADEI	\N	\N	\N	346.12
003061	901	IDRO	2.0	2.6	\N	2016-09-20	GRAZIADEI	\N	\N	\N	324.84
003061	902	IDRO	1.9	2.5	2.9	2013-11-06	GRAZIADEI	\N	\N	\N	256.72
003078	700	IDRO	1.7	2.2	3.0	2013-11-06	GRAZIADEI	\N	\N	\N	210.27
003096	900	IDRO	4.4	5.2	7.7	2010-09-15	GRAZIADEI	\N	\N	\N	196.00
003100	900	IDRO	2.2	2.7	3.7	2015-05-18	GRAZIADEI	\N	\N	\N	204.78
003106	700	IDRO	1.9	2.3	3.5	2015-05-18	GRAZIADEI	\N	\N	\N	138.49
003110	900	IDRO	1.4	1.8	2.3	2014-11-14	ZACCAGNINO	\N	\N	\N	288.86
003132	900	IDRO	5.0	6.6	7.4	2013-11-06	GRAZIADEI	\N	\N	\N	235.51
003152	900	IDRO	1.1	1.5	\N	2016-09-20	GRAZIADEI	\N	\N	\N	544.46
003156	900	IDRO	4.5	5.0	6.0	2014-11-06	GRAZIADEI	\N	\N	\N	190.00
003162	900	IDRO	2.3	3.0	4.2	2010-09-15	GRAZIADEI	\N	\N	\N	260.85
004003	900	IDRO	1.9	2.5	4.1	2010-09-15	GRAZIADEI	\N	\N	\N	157.21
004034	900	IDRO	1.9	2.5	3.5	2010-09-15	GRAZIADEI	\N	\N	\N	473.38
004043	700	IDRO	1.0	1.4	1.9	2010-09-15	GRAZIADEI	\N	\N	\N	275.04
004047	900	IDRO	1.9	2.5	\N	2010-09-15	GRAZIADEI	\N	\N	\N	1144.27
004068	901	IDRO	2.2	2.9	\N	2013-11-06	GRAZIADEI	\N	\N	\N	719.45
004073	900	IDRO	1.3	1.7	\N	2010-09-15	GRAZIADEI	\N	\N	\N	250.72
004079	900	IDRO	1.2	1.6	2.5	2010-09-15	GRAZIADEI	\N	\N	\N	642.93
004081	900	IDRO	1.1	1.4	\N	2013-11-06	GRAZIADEI	\N	\N	\N	282.03
004082	700	IDRO	2.2	2.7	\N	2015-05-18	GRAZIADEI	\N	\N	\N	611.66
004086	900	IDRO	2.6	3.0	4.0	2010-09-15	GRAZIADEI	\N	\N	\N	232.88
004089	901	IDRO	2.2	2.5	3.1	2012-09-14	GRAZIADEI	\N	\N	\N	309.65
004095	900	IDRO	1.9	2.5	3.2	2013-11-06	GRAZIADEI	\N	\N	\N	573.54
004108	900	IDRO	2.6	3.5	4.7	2015-05-18	GRAZIADEI	\N	\N	\N	337.23
004125	900	IDRO	1.7	2.3	\N	2013-11-06	GRAZIADEI	\N	\N	\N	427.36
004127	900	IDRO	1.9	2.5	\N	2010-09-15	GRAZIADEI	\N	\N	\N	636.86
004130	700	IDRO	1.4	1.8	\N	2010-09-15	GRAZIADEI	\N	\N	\N	380.77
004134	900	IDRO	1.5	2.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	667.96
004139	700	IDRO	1.2	1.6	2.2	2010-09-15	GRAZIADEI	\N	\N	\N	711.50
004155	901	IDRO	1.9	2.5	3.6	2013-11-06	GRAZIADEI	\N	\N	\N	806.42
004171	700	IDRO	2.2	2.8	3.8	2010-09-15	GRAZIADEI	\N	\N	\N	240.42
004179	700	IDRO	0.7	1.0	\N	2013-11-06	GRAZIADEI	\N	\N	\N	256.46
004180	900	IDRO	2.3	3.0	4.0	2010-09-15	GRAZIADEI	\N	\N	\N	260.98
004185	900	IDRO	1.8	2.4	\N	2010-09-15	GRAZIADEI	\N	\N	\N	733.79
004190	902	IDRO	2.3	3.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	810.77
004193	900	IDRO	2.0	2.6	\N	2016-09-06	GRAZIADEI	\N	\N	\N	267.48
004197	900	IDRO	0.9	1.3	\N	2013-11-06	GRAZIADEI	\N	\N	\N	491.13
004210	900	IDRO	1.5	2.2	\N	2017-04-11	GRAZIADEI	\N	\N	\N	438.49
004215	901	IDRO	1.0	1.3	2.3	2010-09-15	GRAZIADEI	\N	\N	\N	361.62
004233	901	IDRO	1.9	2.5	\N	2010-09-15	GRAZIADEI	\N	\N	\N	696.80
004248	903	IDRO	1.5	2.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	955.27
005005	900	IDRO	3.0	4.0	5.5	2012-02-24	GRAZIADEI	\N	\N	\N	108.10
005029	900	IDRO	3.9	4.5	5.5	2010-09-15	GRAZIADEI	\N	\N	\N	114.06
005037	700	IDRO	2.3	3.0	3.8	2013-11-06	GRAZIADEI	\N	\N	\N	194.04
005064	700	IDRO	3.8	5.0	6.2	2010-09-15	GRAZIADEI	\N	\N	\N	200.82
005097	900	IDRO	2.0	2.6	3.6	2010-09-15	GRAZIADEI	\N	\N	\N	146.67
006003	901	IDRO	4.3	5.7	7.0	2010-09-15	GRAZIADEI	\N	\N	\N	83.66
006003	902	IDRO	3.3	4.1	5.3	2014-02-26	ZACCAGNINO	\N	\N	\N	87.00
006012	700	IDRO	1.8	2.1	2.9	2013-11-06	GRAZIADEI	\N	\N	\N	122.16
006036	900	IDRO	1.5	2.0	\N	2010-09-15	GRAZIADEI	\N	\N	\N	215.48
006037	900	IDRO	3.0	3.5	4.5	2010-09-15	GRAZIADEI	\N	\N	\N	97.42
006039	901	IDRO	-0.4	0.5	1.8	2014-04-04	GRAZIADEI	\N	\N	\N	107.58
006043	900	IDRO	2.1	2.8	3.8	2013-11-06	GRAZIADEI	\N	\N	\N	113.45
006086	700	IDRO	5.0	6.7	8.8	2015-05-18	GRAZIADEI	\N	\N	\N	67.03
006087	700	IDRO	5.5	6.5	8.0	2010-09-15	GRAZIADEI	\N	\N	\N	68.08
006091	900	IDRO	2.8	3.7	5.2	2013-11-06	GRAZIADEI	\N	\N	\N	96.78
006101	900	IDRO	1.0	1.3	1.8	2010-09-15	GRAZIADEI	\N	\N	\N	175.23
006105	700	IDRO	4.9	5.7	6.7	2013-11-06	GRAZIADEI	\N	\N	\N	79.80
006160	900	IDRO	1.7	2.2	3.5	2010-09-15	GRAZIADEI	\N	\N	\N	193.68
006177	900	IDRO	2.7	3.3	4.8	2010-09-15	GRAZIADEI	\N	\N	\N	85.18
009040	900	IDRO	1.5	2.0	2.6	2013-11-06	GRAZIADEI	\N	\N	\N	511.06
009048	900	IDRO	3.0	4.0	\N	2010-10-27	GRAZIADEI	\N	\N	\N	259.72
010027	900	IDRO	1.9	2.5	\N	2010-09-15	GRAZIADEI	\N	\N	\N	318.44
010061	900	IDRO	2.6	3.5	4.5	2013-11-06	GRAZIADEI	\N	\N	\N	377.79
018033	900	IDRO	2.3	3.0	4.5	2010-09-15	GRAZIADEI	\N	\N	\N	67.51
018081	900	IDRO	3.5	4.5	5.5	2010-10-13	GRAZIADEI	\N	\N	\N	55.17
018107	700	IDRO	3.2	4.3	5.2	2013-11-06	GRAZIADEI	\N	\N	\N	108.80
\.


--
-- Name: pk_soglie_gamma; Type: CONSTRAINT; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY soglie_gamma
    ADD CONSTRAINT pk_soglie_gamma PRIMARY KEY (codice_istat_comune, progr_punto_com, id_parametro);


--
-- Name: rete_meteo2_key; Type: CONSTRAINT; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rete_meteoidrografica
    ADD CONSTRAINT rete_meteo2_key PRIMARY KEY (gid);


--
-- Name: rete_meteoidrografica_codice_istat_comune_progr_punto_com_key; Type: CONSTRAINT; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY rete_meteoidrografica
    ADD CONSTRAINT rete_meteoidrografica_codice_istat_comune_progr_punto_com_key UNIQUE (codice_istat_comune, progr_punto_com);


--
-- Name: soglie_idrometriche_pkey; Type: CONSTRAINT; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY soglie_idrometriche
    ADD CONSTRAINT soglie_idrometriche_pkey PRIMARY KEY (codice_istat_comune, progr_punto_com, id_parametro);


SET search_path = realtime, pg_catalog;

--
-- Name: bis_stato_codice_key; Type: CONSTRAINT; Schema: realtime; Owner: idro; Tablespace: 
--

ALTER TABLE ONLY bis_stato
    ADD CONSTRAINT bis_stato_codice_key UNIQUE (codice);


--
-- Name: bis_stato_pkey; Type: CONSTRAINT; Schema: realtime; Owner: idro; Tablespace: 
--

ALTER TABLE ONLY bis_stato
    ADD CONSTRAINT bis_stato_pkey PRIMARY KEY (gid);


--
-- Name: pk_anomalia; Type: CONSTRAINT; Schema: realtime; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY anomalie
    ADD CONSTRAINT pk_anomalia PRIMARY KEY (data_inizio, id_sistema);


--
-- Name: pk_meteo_real_time; Type: CONSTRAINT; Schema: realtime; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY meteo_real_time
    ADD CONSTRAINT pk_meteo_real_time PRIMARY KEY (id_rete_monit, codice_istat_comune, progr_punto_com, data, ora, id_parametro, id_aggregazione);


SET search_path = dati_di_base, pg_catalog;

--
-- Name: rete_meteob_idx; Type: INDEX; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE INDEX rete_meteob_idx ON rete_meteoidrografica USING gist (the_geom);


--
-- Name: rete_meteoidro_istat; Type: INDEX; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE INDEX rete_meteoidro_istat ON rete_meteoidrografica USING btree (codice_istat_comune);


--
-- Name: rete_meteoidro_progr; Type: INDEX; Schema: dati_di_base; Owner: postgres; Tablespace: 
--

CREATE INDEX rete_meteoidro_progr ON rete_meteoidrografica USING btree (progr_punto_com);


SET search_path = realtime, pg_catalog;

--
-- Name: meteo_real_time_idx_istat_progr; Type: INDEX; Schema: realtime; Owner: postgres; Tablespace: 
--

CREATE INDEX meteo_real_time_idx_istat_progr ON meteo_real_time USING btree (codice_istat_comune, progr_punto_com);


--
-- Name: anomalie_id_sistema_fkey; Type: FK CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY anomalie
    ADD CONSTRAINT anomalie_id_sistema_fkey FOREIGN KEY (id_sistema) REFERENCES config.anomalie_sistemi(id_sistema) MATCH FULL;


--
-- Name: anomalie_severita_fkey; Type: FK CONSTRAINT; Schema: realtime; Owner: postgres
--

ALTER TABLE ONLY anomalie
    ADD CONSTRAINT anomalie_severita_fkey FOREIGN KEY (severita) REFERENCES config.anomalie_severita(severita_idx);


SET search_path = dati_di_base, pg_catalog;

--
-- Name: rete_meteoidrografica; Type: ACL; Schema: dati_di_base; Owner: postgres
--

REVOKE ALL ON TABLE rete_meteoidrografica FROM PUBLIC;
REVOKE ALL ON TABLE rete_meteoidrografica FROM postgres;
GRANT ALL ON TABLE rete_meteoidrografica TO postgres;
GRANT SELECT ON TABLE rete_meteoidrografica TO webgis_r;
GRANT ALL ON TABLE rete_meteoidrografica TO radar_rw;


--
-- Name: soglie_gamma; Type: ACL; Schema: dati_di_base; Owner: postgres
--

REVOKE ALL ON TABLE soglie_gamma FROM PUBLIC;
REVOKE ALL ON TABLE soglie_gamma FROM postgres;
GRANT ALL ON TABLE soglie_gamma TO postgres;
GRANT SELECT ON TABLE soglie_gamma TO webgis_r;
GRANT ALL ON TABLE soglie_gamma TO radar_rw;


--
-- Name: soglie_idrometriche; Type: ACL; Schema: dati_di_base; Owner: postgres
--

REVOKE ALL ON TABLE soglie_idrometriche FROM PUBLIC;
REVOKE ALL ON TABLE soglie_idrometriche FROM postgres;
GRANT ALL ON TABLE soglie_idrometriche TO postgres;
GRANT SELECT ON TABLE soglie_idrometriche TO webgis_r;


SET search_path = realtime, pg_catalog;

--
-- Name: meteo_real_time; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE meteo_real_time FROM PUBLIC;
REVOKE ALL ON TABLE meteo_real_time FROM postgres;
GRANT ALL ON TABLE meteo_real_time TO postgres;
GRANT SELECT ON TABLE meteo_real_time TO webgis_r;
GRANT ALL ON TABLE meteo_real_time TO radar_rw;


--
-- Name: anomalie; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE anomalie FROM PUBLIC;
REVOKE ALL ON TABLE anomalie FROM postgres;
GRANT ALL ON TABLE anomalie TO postgres;
GRANT SELECT ON TABLE anomalie TO webgis_r;
GRANT ALL ON TABLE anomalie TO radar_rw;


--
-- Name: bis_stato; Type: ACL; Schema: realtime; Owner: idro
--

REVOKE ALL ON TABLE bis_stato FROM PUBLIC;
REVOKE ALL ON TABLE bis_stato FROM idro;
GRANT ALL ON TABLE bis_stato TO idro;
GRANT SELECT ON TABLE bis_stato TO webgis_r;
GRANT ALL ON TABLE bis_stato TO radar_rw;


--
-- Name: v_anomalie; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_anomalie FROM PUBLIC;
REVOKE ALL ON TABLE v_anomalie FROM postgres;
GRANT ALL ON TABLE v_anomalie TO postgres;
GRANT SELECT ON TABLE v_anomalie TO webgis_r;
GRANT ALL ON TABLE v_anomalie TO radar_rw;


--
-- Name: v_last_idro; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_last_idro FROM PUBLIC;
REVOKE ALL ON TABLE v_last_idro FROM postgres;
GRANT ALL ON TABLE v_last_idro TO postgres;
GRANT SELECT ON TABLE v_last_idro TO webgis_r;
GRANT ALL ON TABLE v_last_idro TO radar_rw;


--
-- Name: v_last_nivo; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_last_nivo FROM PUBLIC;
REVOKE ALL ON TABLE v_last_nivo FROM postgres;
GRANT ALL ON TABLE v_last_nivo TO postgres;
GRANT SELECT ON TABLE v_last_nivo TO webgis_r;
GRANT ALL ON TABLE v_last_nivo TO radar_rw;


--
-- Name: v_last_pluv; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_last_pluv FROM PUBLIC;
REVOKE ALL ON TABLE v_last_pluv FROM postgres;
GRANT ALL ON TABLE v_last_pluv TO postgres;
GRANT SELECT ON TABLE v_last_pluv TO webgis_r;


--
-- Name: v_last_terma; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_last_terma FROM PUBLIC;
REVOKE ALL ON TABLE v_last_terma FROM postgres;
GRANT ALL ON TABLE v_last_terma TO postgres;
GRANT SELECT ON TABLE v_last_terma TO webgis_r;
GRANT ALL ON TABLE v_last_terma TO radar_rw;


--
-- Name: v_last_vento; Type: ACL; Schema: realtime; Owner: postgres
--

REVOKE ALL ON TABLE v_last_vento FROM PUBLIC;
REVOKE ALL ON TABLE v_last_vento FROM postgres;
GRANT ALL ON TABLE v_last_vento TO postgres;
GRANT SELECT ON TABLE v_last_vento TO webgis_r;
GRANT ALL ON TABLE v_last_vento TO radar_rw;


--
-- PostgreSQL database dump complete
--

