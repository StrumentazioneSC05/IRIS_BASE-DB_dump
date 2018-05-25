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
-- Name: config; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA config;


ALTER SCHEMA config OWNER TO postgres;

--
-- Name: SCHEMA config; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA config IS 'schema con tabelle di configurazione dei sistemi WebGis';


--
-- Name: update_legend_variable(); Type: FUNCTION; Schema: config; Owner: postgres
--

CREATE FUNCTION config.update_legend_variable() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
UPDATE config.webgis_ol_layers SET default_legend_variable = 'layer' || NEW.layer_idx WHERE NEW.layer_idx=layer_idx;
RETURN NULL;
END;
$$;


ALTER FUNCTION config.update_legend_variable() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: animazione_webgis; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.animazione_webgis (
    label character varying(64),
    nome_file character varying(125),
    tipo_dato character varying(32),
    formato_data character varying(64),
    campo_data character varying(64),
    gid integer NOT NULL,
    note character varying(255),
    delta_min integer,
    delta_max integer,
    delta_udm character varying(16),
    path character varying(200),
    data_index character(12),
    bounds3857 character varying(100),
    size character varying(64),
    delta_inizio integer,
    delta_passo integer,
    attivo smallint,
    webgis_idx_arr integer[],
    frame_offset smallint
);


ALTER TABLE config.animazione_webgis OWNER TO postgres;

--
-- Name: TABLE animazione_webgis; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.animazione_webgis IS 'test per gestire le animazioni dei layers sul webgis';


--
-- Name: COLUMN animazione_webgis.tipo_dato; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.tipo_dato IS 'indicare se il layer da animare e "vettore" o "img"';


--
-- Name: COLUMN animazione_webgis.delta_min; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.delta_min IS 'passo minimo tra una animazione e la successiva, in delta_udm';


--
-- Name: COLUMN animazione_webgis.delta_max; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.delta_max IS 'flashblack massimo concesso, in delta_udm';


--
-- Name: COLUMN animazione_webgis.delta_udm; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.delta_udm IS 'unita di misura secondo lo standard postgres dei delta indicati';


--
-- Name: COLUMN animazione_webgis.path; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.path IS 'percorso del file raster per l''animazione o nel caso di file vettoriali indicare DB.SCHEMA';


--
-- Name: COLUMN animazione_webgis.data_index; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.data_index IS 'contando da zero indice iniziale incluso e indice finale escluso dell''informazione temporale separati da @@';


--
-- Name: COLUMN animazione_webgis.bounds3857; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.bounds3857 IS '2 coppie di coordinate separate da @@ nel sistema epsg:3857, per i raster';


--
-- Name: COLUMN animazione_webgis.size; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.size IS 'coppia delle dimensioni dell''immagine raster in pixel, separati da @@';


--
-- Name: COLUMN animazione_webgis.delta_inizio; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.delta_inizio IS 'in delta_udm specificare il tempo di partenza del delta_min. normalmente ├¿ 00 ma potrebbe essere altro...';


--
-- Name: COLUMN animazione_webgis.delta_passo; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.delta_passo IS 'passo in delta_udm per scaglionare gli intervalli temporali per il flashback, deve essere un sottomultiplo di delta_max. ad esempio se si vuol far selezionare di ora in ora, mettere 60 con delta_udm=MI';


--
-- Name: COLUMN animazione_webgis.attivo; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.attivo IS '0-disattivato nell''elenco;1-attivato nell''elenco';


--
-- Name: COLUMN animazione_webgis.webgis_idx_arr; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.webgis_idx_arr IS 'webgis che contengono questi layer in animazione';


--
-- Name: COLUMN animazione_webgis.frame_offset; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.animazione_webgis.frame_offset IS 'moltiplicatore del campo delta_min per non partire da frame al tempo attuale ma recuperarne X istanti indietro';


--
-- Name: animazione_webgis_gid_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.animazione_webgis_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.animazione_webgis_gid_seq OWNER TO postgres;

--
-- Name: animazione_webgis_gid_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.animazione_webgis_gid_seq OWNED BY config.animazione_webgis.gid;


--
-- Name: anomalie_severita; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.anomalie_severita (
    severita_idx integer NOT NULL,
    severita_descr character varying(12),
    impatto_operativo boolean,
    severita_colore character varying(24)
);


ALTER TABLE config.anomalie_severita OWNER TO postgres;

--
-- Name: TABLE anomalie_severita; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.anomalie_severita IS 'severita delle anomalie, da riportare nella tabella realtime.anomalie';


--
-- Name: anomalie_sistemi; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.anomalie_sistemi (
    id_sistema integer NOT NULL,
    descrizione character varying(250),
    data_agg timestamp without time zone DEFAULT now() NOT NULL,
    autore_agg character varying(50) NOT NULL
);


ALTER TABLE config.anomalie_sistemi OWNER TO postgres;

--
-- Name: TABLE anomalie_sistemi; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.anomalie_sistemi IS 'Tabella dei sistemi RADAR per anomalie';


--
-- Name: httpd_access; Type: TABLE; Schema: config; Owner: apache_rw; Tablespace: 
--

CREATE TABLE config.httpd_access (
    username character varying(25) NOT NULL,
    data_login timestamp without time zone DEFAULT now(),
    webgis_type character varying(32),
    remote_addr character varying(32),
    php_self character varying(120)
);


ALTER TABLE config.httpd_access OWNER TO apache_rw;

--
-- Name: TABLE httpd_access; Type: COMMENT; Schema: config; Owner: apache_rw
--

COMMENT ON TABLE config.httpd_access IS 'elenco accesso utenti al servizio IRIS con httpd';


--
-- Name: httpd_users; Type: TABLE; Schema: config; Owner: apache_rw; Tablespace: 
--

CREATE TABLE config.httpd_users (
    username character varying(25) NOT NULL,
    password character varying(40),
    groups character varying(25),
    active smallint DEFAULT 1
);


ALTER TABLE config.httpd_users OWNER TO apache_rw;

--
-- Name: TABLE httpd_users; Type: COMMENT; Schema: config; Owner: apache_rw
--

COMMENT ON TABLE config.httpd_users IS 'elenco utenti per connessione al servizio IRIS con httpd';


--
-- Name: news_message; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.news_message (
    gid integer NOT NULL,
    messaggio character varying,
    icona_iniziale character varying,
    data_validita date DEFAULT now() NOT NULL,
    data_scadenza date,
    webgis_idx integer[]
);


ALTER TABLE config.news_message OWNER TO postgres;

--
-- Name: TABLE news_message; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.news_message IS 'messaggi di ultime novita di sviluppo sul webgis da visualizzare sul browser basandosi sui cookies';


--
-- Name: COLUMN news_message.data_scadenza; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.news_message.data_scadenza IS 'inserire la data di scadenza quando non si vuole far piu'' comparire il messaggio';


--
-- Name: COLUMN news_message.webgis_idx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.news_message.webgis_idx IS 'indici dei webgis su cui deve comparire questa notizia o messaggio. Lasciarlo NULL se messaggio valido per tutti';


--
-- Name: news_message_gid_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.news_message_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.news_message_gid_seq OWNER TO postgres;

--
-- Name: news_message_gid_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.news_message_gid_seq OWNED BY config.news_message.gid;


--
-- Name: tab_tipo_evento; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.tab_tipo_evento (
    id_tipo_evento integer NOT NULL,
    nome_tipo_evento character varying(225),
    descrizione character varying(512),
    data_agg timestamp without time zone DEFAULT now() NOT NULL,
    autore_agg character varying(50) NOT NULL
);


ALTER TABLE config.tab_tipo_evento OWNER TO postgres;

--
-- Name: TABLE tab_tipo_evento; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.tab_tipo_evento IS 'Tabella dei tipi evento';


--
-- Name: webgis_groups; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_groups (
    legend_group_name character varying(32),
    pedice character varying(12) NOT NULL,
    group_father character varying(32),
    description character varying(120),
    group_idx integer NOT NULL,
    order_in_webgis integer,
    expanded boolean,
    is_father smallint,
    children_array character varying(32)[]
);


ALTER TABLE config.webgis_groups OWNER TO postgres;

--
-- Name: TABLE webgis_groups; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_groups IS 'configurazione gruppi dei layers da DB';


--
-- Name: COLUMN webgis_groups.pedice; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_groups.pedice IS 'pedice da usare nella forma ''<!--pedice-->''';


--
-- Name: COLUMN webgis_groups.is_father; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_groups.is_father IS '0: gruppo normale; 1: gruppo padre; -1: sottogruppo';


--
-- Name: COLUMN webgis_groups.children_array; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_groups.children_array IS 'pedici di eventuali sottogruppi figli del gruppo';


--
-- Name: webgis_indici_idx_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.webgis_indici_idx_seq
    START WITH 15
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.webgis_indici_idx_seq OWNER TO postgres;

--
-- Name: webgis_indici; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_indici (
    webgis_name character varying(24) NOT NULL,
    webgis_description character varying(200),
    webgis_idx integer DEFAULT nextval('config.webgis_indici_idx_seq'::regclass) NOT NULL,
    default_raster integer,
    zoom_center integer DEFAULT 8 NOT NULL,
    lon_center double precision DEFAULT 8 NOT NULL,
    lat_center double precision DEFAULT 45 NOT NULL,
    query_map_idx smallint DEFAULT 0 NOT NULL,
    baselayers integer[],
    collapsed_grid boolean DEFAULT true NOT NULL,
    defaultgrid_layeridx integer,
    attivo integer,
    themes_path character varying(255) DEFAULT '/common/tematismi'::character varying NOT NULL,
    scripts_path character varying(255) DEFAULT '/common/scripts'::character varying NOT NULL,
    nomelogo character varying(255) DEFAULT '/common/icons/logo_ArpaPiemonte_transp.png'::character varying NOT NULL,
    urllogo character varying(255) DEFAULT 'http://www.arpa.piemonte.gov.it/'::character varying NOT NULL,
    map_path character varying(255) DEFAULT '/var/www/html/common/mapfiles/'::character varying NOT NULL,
    url_tinyows character varying(255) DEFAULT '/cgi-bin/tinyows'::character varying NOT NULL,
    url_tinyows_sigeo character varying(255) DEFAULT '/cgi-bin/tinyows_sigeo'::character varying NOT NULL,
    titlelogo character varying(32) DEFAULT 'WebGis IRIS'::character varying NOT NULL,
    id_logo_div character varying(32) DEFAULT 'logo'::character varying NOT NULL,
    local_path character varying(255) DEFAULT '/iris_base/'::character varying NOT NULL,
    query_map_extra_idx character varying(10)[],
    CONSTRAINT webgis_indici_attivo_check CHECK ((attivo = ANY (ARRAY[0, 1])))
);


ALTER TABLE config.webgis_indici OWNER TO postgres;

--
-- Name: TABLE webgis_indici; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_indici IS 'indici univoci dei vari webgis attivi, per selezionare i layer da attivare per le animazioni.';


--
-- Name: COLUMN webgis_indici.webgis_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.webgis_name IS 'nome del webgis cosi come da TYPE nella url';


--
-- Name: COLUMN webgis_indici.webgis_idx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.webgis_idx IS 'indice numerico univoco da associare al webgis';


--
-- Name: COLUMN webgis_indici.default_raster; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.default_raster IS 'gid del raster visibile di default dalla tabella animazione_raster';


--
-- Name: COLUMN webgis_indici.query_map_idx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.query_map_idx IS 'idx delle azioni da abilitare al clic su mappa richiamando il codice python query_raster.py';


--
-- Name: COLUMN webgis_indici.baselayers; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.baselayers IS 'lista degli idx dei baselayers caricati sul servizio, in ordine. Il primo si accende di default';


--
-- Name: COLUMN webgis_indici.collapsed_grid; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.collapsed_grid IS 'la griglia attributi deve stare aperta - FALSE, o chiusa - TRUE';


--
-- Name: COLUMN webgis_indici.defaultgrid_layeridx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.defaultgrid_layeridx IS 'specificare quale layer mostrare nella griglia attributi. Lasciare NULL per niente. ATTENZIONE! il layer specificato DEVE ESSERE CARICATO sulla mappa altrimenti il servizio crasha';


--
-- Name: COLUMN webgis_indici.attivo; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.attivo IS 'Servizio attivo';


--
-- Name: COLUMN webgis_indici.themes_path; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.themes_path IS 'percorso con la definizione js dei tematismi';


--
-- Name: COLUMN webgis_indici.scripts_path; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.scripts_path IS 'percorso di altri script js';


--
-- Name: COLUMN webgis_indici.map_path; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.map_path IS 'percorso dei file .map di mapserver';


--
-- Name: COLUMN webgis_indici.url_tinyows; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.url_tinyows IS 'percorso eseguibile tinyows principale';


--
-- Name: COLUMN webgis_indici.url_tinyows_sigeo; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.url_tinyows_sigeo IS 'percorso eseguibile tinyows secondario per caricare eventuali altri dati da un altro DB';


--
-- Name: COLUMN webgis_indici.local_path; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_indici.local_path IS 'percorso con gli script specifici del servizio';


--
-- Name: webgis_layers; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_layers (
    webgis_idx integer NOT NULL,
    legend_name character varying(120) NOT NULL,
    legend_group_idx integer,
    select_highlight integer,
    visible integer,
    order_in_webgis integer NOT NULL,
    ol_layer_idx integer NOT NULL,
    CONSTRAINT webgis_layers_select_highlight_check CHECK ((select_highlight = ANY (ARRAY[0, 1, 2, 3]))),
    CONSTRAINT webgis_layers_visible_check CHECK ((visible = ANY (ARRAY[0, 1])))
);


ALTER TABLE config.webgis_layers OWNER TO postgres;

--
-- Name: TABLE webgis_layers; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_layers IS 'configurazione layers da DB associati ai servizi webgis';


--
-- Name: COLUMN webgis_layers.select_highlight; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_layers.select_highlight IS '0-niente;1-solo select;2-select e highlight';


--
-- Name: COLUMN webgis_layers.visible; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_layers.visible IS 'visibile all''avvio del servizio. 0-no; 1-si';


--
-- Name: COLUMN webgis_layers.ol_layer_idx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_layers.ol_layer_idx IS 'indice della variabile OL a cui far iferimento dalla tabella webgis_ol_layers';


--
-- Name: webgis_ol_layers; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_ol_layers (
    layer_idx integer NOT NULL,
    openlayer_name character varying(120) NOT NULL,
    default_legend_variable character varying(32),
    db_table_view_name character varying(120) NOT NULL,
    service character varying(32),
    layer_description character varying(255) NOT NULL,
    theme_description character varying(255) NOT NULL,
    ol_cluster_enabled boolean DEFAULT false NOT NULL,
    store_definition character varying(32),
    column_definition character varying(32),
    filter_defined boolean NOT NULL,
    filter_description character varying(255),
    mobile_friendly boolean DEFAULT false NOT NULL,
    geom_type character varying(30),
    geom_srid integer,
    grid_title character varying(200)
);


ALTER TABLE config.webgis_ol_layers OWNER TO postgres;

--
-- Name: TABLE webgis_ol_layers; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_ol_layers IS 'Layers definiti su OpenLayers. Elenco da tenere aggiornato manualmente in modo da poter aggiungere piu agevolmente i layer ai vari servizi WebGis';


--
-- Name: COLUMN webgis_ol_layers.openlayer_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.openlayer_name IS 'nome della variabile data al layer su OL';


--
-- Name: COLUMN webgis_ol_layers.default_legend_variable; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.default_legend_variable IS 'nome della variabile con il nome da riportare in legenda';


--
-- Name: COLUMN webgis_ol_layers.db_table_view_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.db_table_view_name IS 'Campo NON descrittivo: puntare alla tabella o vista origine del dato!';


--
-- Name: COLUMN webgis_ol_layers.service; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.service IS 'mapserver - tinyows - image';


--
-- Name: COLUMN webgis_ol_layers.layer_description; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.layer_description IS 'descrizione sommaria di cosa rappresenta il layer';


--
-- Name: COLUMN webgis_ol_layers.theme_description; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.theme_description IS 'descrizione di come viene tematizzato il layer con questa variabile';


--
-- Name: COLUMN webgis_ol_layers.ol_cluster_enabled; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.ol_cluster_enabled IS 'e attiva la rappresentazione grafica per cluster di OL? 0-no, 1-si';


--
-- Name: COLUMN webgis_ol_layers.store_definition; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.store_definition IS 'eventuale variabile che definisce lo store per questo layer';


--
-- Name: COLUMN webgis_ol_layers.column_definition; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.column_definition IS 'eventuale variabile che definisce la column_store';


--
-- Name: COLUMN webgis_ol_layers.filter_defined; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.filter_defined IS 'vi sono dei filtri definiti DA CODICE per estromettere alcuni dati? 0-no, 1-si';


--
-- Name: COLUMN webgis_ol_layers.filter_description; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.filter_description IS 'se presente spiegare in cosa consiste il filtro';


--
-- Name: COLUMN webgis_ol_layers.mobile_friendly; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.mobile_friendly IS 'la rappresentazione o il tematismo in se puo andar bene su un dispositivo mobile? 0-no, 1-si';


--
-- Name: COLUMN webgis_ol_layers.geom_type; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.geom_type IS 'tipo di geometria - dalla vista geometry_columns';


--
-- Name: COLUMN webgis_ol_layers.geom_srid; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.geom_srid IS 'srid del layer - da geometry_columns';


--
-- Name: COLUMN webgis_ol_layers.grid_title; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_ol_layers.grid_title IS 'Titolo da dare alla griglia attributi. Nel caso dei dati RASTER e il riferimento all''immagine da usare come legenda';


--
-- Name: v_webgis_custom_settings; Type: VIEW; Schema: config; Owner: postgres
--

CREATE VIEW config.v_webgis_custom_settings AS
 SELECT main_table.layer_idx,
    main_table.openlayer_name,
    main_table.db_table_view_name,
    main_table.default_legend_variable,
    main_table.service,
    main_table.theme_description,
    main_table.store_definition,
    main_table.column_definition,
    main_table.grid_title,
    main_table.layer_description,
    main_table.filter_defined,
    main_table.filter_description,
    main_table.mobile_friendly,
    main_table.geom_type,
    main_table.geom_srid,
    main_table.webgis_idx,
    main_table.webgis_name,
    main_table.webgis_description,
    main_table.legend_name,
    main_table.select_highlight,
    main_table.visible,
    main_table.order_in_webgis,
    main_table.legend_group_idx,
    main_table.legend_group_name,
    main_table.pedice,
    main_table.is_father,
    main_table.group_father,
    main_table.group_desc,
    main_table.group_order,
    main_table.expanded,
    d.group_idx AS father_group_idx,
    d.legend_group_name AS father_group_name,
    d.pedice AS father_pedice,
    COALESCE((d.is_father)::integer, 0) AS father_is_father,
    array_to_json(d.children_array) AS children_array,
    d.order_in_webgis AS father_group_order,
    (d.expanded)::text AS father_expanded
   FROM (( SELECT webgis_ol_layers.layer_idx,
            webgis_ol_layers.openlayer_name,
            webgis_ol_layers.db_table_view_name,
            webgis_ol_layers.default_legend_variable,
            webgis_ol_layers.service,
            webgis_ol_layers.theme_description,
            webgis_ol_layers.store_definition,
            webgis_ol_layers.column_definition,
            webgis_ol_layers.grid_title,
            webgis_ol_layers.layer_description,
            webgis_ol_layers.filter_defined,
            webgis_ol_layers.filter_description,
            webgis_ol_layers.mobile_friendly,
            webgis_ol_layers.geom_type,
            webgis_ol_layers.geom_srid,
            webgis_layers.webgis_idx,
            webgis_indici.webgis_name,
            webgis_indici.webgis_description,
            webgis_layers.legend_name,
            webgis_layers.select_highlight,
            webgis_layers.visible,
            webgis_layers.order_in_webgis,
            webgis_layers.legend_group_idx,
            webgis_groups.legend_group_name,
            webgis_groups.pedice,
            webgis_groups.is_father,
            webgis_groups.group_father,
            webgis_groups.description AS group_desc,
            webgis_groups.order_in_webgis AS group_order,
            (webgis_groups.expanded)::text AS expanded
           FROM config.webgis_ol_layers,
            config.webgis_layers,
            config.webgis_groups,
            config.webgis_indici
          WHERE (((webgis_ol_layers.layer_idx = webgis_layers.ol_layer_idx) AND (webgis_layers.webgis_idx = webgis_indici.webgis_idx)) AND (webgis_layers.legend_group_idx = webgis_groups.group_idx))) main_table
     LEFT JOIN config.webgis_groups d ON (((main_table.group_father)::text = (d.pedice)::text)));


ALTER TABLE config.v_webgis_custom_settings OWNER TO postgres;

--
-- Name: VIEW v_webgis_custom_settings; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON VIEW config.v_webgis_custom_settings IS 'Configurazione layers da DB';


--
-- Name: webgis_toolbar_tools; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_toolbar_tools (
    tool_idx integer NOT NULL,
    tool_name character varying(32),
    tool_description character varying(255),
    tool_icon character varying(250)
);


ALTER TABLE config.webgis_toolbar_tools OWNER TO postgres;

--
-- Name: TABLE webgis_toolbar_tools; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_toolbar_tools IS 'strumenti aggiuntivi alla toolbar del webgis';


--
-- Name: COLUMN webgis_toolbar_tools.tool_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_toolbar_tools.tool_name IS 'nome della variabile JS che rappresenta il tool';


--
-- Name: webgis_tools; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_tools (
    webgis_idx integer NOT NULL,
    tools_idx integer NOT NULL
);


ALTER TABLE config.webgis_tools OWNER TO postgres;

--
-- Name: TABLE webgis_tools; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_tools IS 'tools della toolbar attivi pe ciascun webgis. Tavola di appoggio';


--
-- Name: v_webgis_general_config; Type: VIEW; Schema: config; Owner: postgres
--

CREATE VIEW config.v_webgis_general_config AS
 SELECT webgis_indici.webgis_name,
    webgis_indici.webgis_idx,
    webgis_indici.zoom_center,
    webgis_indici.lon_center,
    webgis_indici.lat_center,
    (webgis_indici.query_map_idx || rpad(COALESCE(array_to_string(webgis_indici.query_map_extra_idx, ''::text), (''::character varying)::text), 10, 'X'::text)) AS query_map_idx,
    webgis_indici.baselayers,
    webgis_indici.collapsed_grid,
    webgis_indici.attivo,
    webgis_ol_layers.store_definition AS store_grid,
    webgis_ol_layers.column_definition AS columns_grid,
    webgis_ol_layers.grid_title AS title_grid,
    webgis_tools.tools_idx,
    webgis_toolbar_tools.tool_name,
    webgis_toolbar_tools.tool_icon,
    ((webgis_toolbar_tools.tool_name)::text || '_hidden'::text) AS tools_variable
   FROM (((config.webgis_indici
     LEFT JOIN config.webgis_tools ON ((webgis_indici.webgis_idx = webgis_tools.webgis_idx)))
     LEFT JOIN config.webgis_toolbar_tools ON ((webgis_tools.tools_idx = webgis_toolbar_tools.tool_idx)))
     LEFT JOIN config.webgis_ol_layers ON ((webgis_indici.defaultgrid_layeridx = webgis_ol_layers.layer_idx)));


ALTER TABLE config.v_webgis_general_config OWNER TO postgres;

--
-- Name: VIEW v_webgis_general_config; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON VIEW config.v_webgis_general_config IS 'elenco dei tools da attivare in base al webgis';


--
-- Name: v_webgis_ol_layers; Type: VIEW; Schema: config; Owner: postgres
--

CREATE VIEW config.v_webgis_ol_layers AS
 SELECT webgis_ol_layers.layer_idx,
        CASE
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '/'::text) > 0) THEN 'filesystem'::text
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '@@'::text) > 0) THEN 'wms'::text
            ELSE split_part((webgis_ol_layers.db_table_view_name)::text, '.'::text, 1)
        END AS db,
        CASE
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '/'::text) > 0) THEN 'image'::text
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '@@'::text) > 0) THEN split_part((webgis_ol_layers.db_table_view_name)::text, '@@'::text, 1)
            ELSE split_part((webgis_ol_layers.db_table_view_name)::text, '.'::text, 2)
        END AS schema,
        CASE
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '/'::text) > 0) THEN substr((webgis_ol_layers.db_table_view_name)::text, (length("substring"((webgis_ol_layers.db_table_view_name)::text, '^(.*/)'::text)) + 1))
            WHEN (strpos((webgis_ol_layers.db_table_view_name)::text, '@@'::text) > 0) THEN split_part((webgis_ol_layers.db_table_view_name)::text, '@@'::text, 2)
            ELSE split_part((webgis_ol_layers.db_table_view_name)::text, '.'::text, 3)
        END AS tablename,
    webgis_ol_layers.default_legend_variable,
    webgis_ol_layers.layer_description,
    webgis_ol_layers.theme_description,
    webgis_ol_layers.openlayer_name,
    webgis_ol_layers.service,
        CASE
            WHEN (webgis_ol_layers.store_definition IS NOT NULL) THEN true
            ELSE false
        END AS store,
    webgis_ol_layers.geom_type,
    webgis_ol_layers.mobile_friendly
   FROM config.webgis_ol_layers
  ORDER BY webgis_ol_layers.db_table_view_name;


ALTER TABLE config.v_webgis_ol_layers OWNER TO postgres;

--
-- Name: VIEW v_webgis_ol_layers; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON VIEW config.v_webgis_ol_layers IS 'con alcuni ritocchi sui campi per costruire l''interfaccia web';


--
-- Name: webgis_popups; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_popups (
    ol_layer_idx integer NOT NULL,
    webgis_idx integer NOT NULL,
    funzione_associata character varying(64),
    url_link character varying(512),
    url_name character varying(64),
    url_options character varying(250),
    grafici_stazione character varying(64),
    grafici_tab_attivo character varying(64),
    pop_html character varying(1250),
    pop_title character varying(125),
    grafici_valore character varying(64),
    grafici_codice character varying(64),
    grafici_progr character varying(64),
    grafici_tipostaz character varying(64),
    grafici_tiporete character varying(64),
    grafici_composito integer[]
);


ALTER TABLE config.webgis_popups OWNER TO postgres;

--
-- Name: TABLE webgis_popups; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_popups IS 'eventuali funzioni da attivare al click su elemento di un layer';


--
-- Name: COLUMN webgis_popups.webgis_idx; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.webgis_idx IS 'id del webgis sul quale attivare questo tipo di popup per questo tipo di layer';


--
-- Name: COLUMN webgis_popups.funzione_associata; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.funzione_associata IS 'funzione da associare al click sul layer. Al momento sono createPopup, open_popup e grafici_rete';


--
-- Name: COLUMN webgis_popups.url_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.url_name IS 'nome della finestra popup da aprire';


--
-- Name: COLUMN webgis_popups.url_options; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.url_options IS 'opzioni della finestra popup da aprire, come posizione sul monitor e dimensioni';


--
-- Name: COLUMN webgis_popups.grafici_stazione; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_stazione IS 'per decidere a quale tipo di grafico puntare. I valori saranno vincolati dal codice. In particolare sono gli IF all''interno della funzione "grafici_rete", in js_functions.js.
Questa variabile decide anche a quali script successivi puntare per popolare di contenuti la nuova finestra popup.';


--
-- Name: COLUMN webgis_popups.grafici_tab_attivo; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_tab_attivo IS 'tab da attivare all''apertura del grafico. In genere e'' il nome del parametro';


--
-- Name: COLUMN webgis_popups.pop_html; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.pop_html IS 'contenuto html del popup proprio del webgis';


--
-- Name: COLUMN webgis_popups.pop_title; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.pop_title IS 'titolo della popup propria del webgis';


--
-- Name: COLUMN webgis_popups.grafici_valore; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_valore IS 'campo dove si trovano i valori da ordinare per visualizzare il grafico su elementi clusterizzati';


--
-- Name: COLUMN webgis_popups.grafici_codice; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_codice IS 'campo dove si trova il codice istat per visualizzare il grafico su elementi clusterizzati. Alrimenti indicare l''id della stazione. Al momento il codice non e'' ottimale bisogna anche indicare il nome del nuovo campo nella funzione local_script_db.php e js_function.js. DA MIGLIORARE';


--
-- Name: COLUMN webgis_popups.grafici_progr; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_progr IS 'campo dove si trova il codice progressivo per visualizzare il grafico su elementi clusterizzati';


--
-- Name: COLUMN webgis_popups.grafici_tipostaz; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_tipostaz IS 'campo dove si trova il tipo_staz per visualizzare il grafico su elementi clusterizzati';


--
-- Name: COLUMN webgis_popups.grafici_tiporete; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_tiporete IS 'campo dove si trovano i valori per decidere quale tipo di grafico aprire, in sostanza ''meteoidro'' o ''estero''. Se i dati di origine provengono da una tabella e nond auna vista, per non stravolgere la struttura della tabella aggiungendo il campo "tipo_rete", scrivo qui "grafici_stazione", e nel campo "grafici_stazione" scrivo il tipo di grafico a cui questo popup deve rimandare. Una pezza insomma...';


--
-- Name: COLUMN webgis_popups.grafici_composito; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_popups.grafici_composito IS '1-descrizione anagrafica fuori tab; 2-tab dei grafici; 3-meteogramma; 4-da sviluppare';


--
-- Name: v_webgis_popups; Type: VIEW; Schema: config; Owner: postgres
--

CREATE VIEW config.v_webgis_popups AS
 SELECT webgis_popups.ol_layer_idx,
    webgis_ol_layers.openlayer_name,
    webgis_ol_layers.default_legend_variable,
    webgis_popups.webgis_idx,
    webgis_popups.funzione_associata,
    webgis_popups.url_link,
    webgis_popups.url_name,
    webgis_popups.url_options,
    webgis_popups.grafici_stazione,
    webgis_popups.grafici_tab_attivo,
    webgis_popups.grafici_valore,
    webgis_popups.grafici_codice,
    webgis_popups.grafici_progr,
    webgis_popups.grafici_tipostaz,
    webgis_popups.grafici_tiporete,
    array_to_string(webgis_popups.grafici_composito, ','::text) AS grafici_composito,
    webgis_popups.pop_html,
    webgis_popups.pop_title
   FROM config.webgis_ol_layers,
    config.webgis_popups
  WHERE (webgis_popups.ol_layer_idx = webgis_ol_layers.layer_idx);


ALTER TABLE config.v_webgis_popups OWNER TO postgres;

--
-- Name: VIEW v_webgis_popups; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON VIEW config.v_webgis_popups IS 'vista che raggruppa le azioni di clic su elementi dei layer per aprire eventuali popup, link esterni, etc';


--
-- Name: webgis_base_layers; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_base_layers (
    baselayer_idx integer NOT NULL,
    openlayer_name character varying(120) NOT NULL,
    layer_legend_name character varying(32) NOT NULL,
    layer_description character varying(255) NOT NULL,
    geom_srid integer
);


ALTER TABLE config.webgis_base_layers OWNER TO postgres;

--
-- Name: TABLE webgis_base_layers; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_base_layers IS 'Layers di base definiti su OpenLayers. Elenco da tenere aggiornato manualmente in modo da poter aggiungere piu agevolmente i layer ai vari servizi WebGis';


--
-- Name: COLUMN webgis_base_layers.openlayer_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_base_layers.openlayer_name IS 'nome della variabile data al layer di base su OL';


--
-- Name: COLUMN webgis_base_layers.layer_legend_name; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_base_layers.layer_legend_name IS 'nome del layer cosi come riportato in legenda';


--
-- Name: COLUMN webgis_base_layers.layer_description; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_base_layers.layer_description IS 'descrizione sommaria di cosa rappresenta il layer';


--
-- Name: COLUMN webgis_base_layers.geom_srid; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON COLUMN config.webgis_base_layers.geom_srid IS 'srid del layer';


--
-- Name: webgis_base_layers_baselayer_idx_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.webgis_base_layers_baselayer_idx_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.webgis_base_layers_baselayer_idx_seq OWNER TO postgres;

--
-- Name: webgis_base_layers_baselayer_idx_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.webgis_base_layers_baselayer_idx_seq OWNED BY config.webgis_base_layers.baselayer_idx;


--
-- Name: webgis_groups_group_idx_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.webgis_groups_group_idx_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.webgis_groups_group_idx_seq OWNER TO postgres;

--
-- Name: webgis_groups_group_idx_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.webgis_groups_group_idx_seq OWNED BY config.webgis_groups.group_idx;


--
-- Name: webgis_ol_layers_layer_idx_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.webgis_ol_layers_layer_idx_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.webgis_ol_layers_layer_idx_seq OWNER TO postgres;

--
-- Name: webgis_ol_layers_layer_idx_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.webgis_ol_layers_layer_idx_seq OWNED BY config.webgis_ol_layers.layer_idx;


--
-- Name: webgis_query_map; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_query_map (
    query_map_idx smallint NOT NULL,
    query_description character varying(120)
);


ALTER TABLE config.webgis_query_map OWNER TO postgres;

--
-- Name: TABLE webgis_query_map; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_query_map IS 'funzioni da attivare al click su mappa - scenari di attivazione dello script query_raster.py';


--
-- Name: webgis_query_map_extra; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_query_map_extra (
    query_map_idx character(1) NOT NULL,
    query_description character varying(120)
);


ALTER TABLE config.webgis_query_map_extra OWNER TO postgres;

--
-- Name: TABLE webgis_query_map_extra; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_query_map_extra IS 'funzioni da attivare al click su mappa - scenari di attivazione dello script query_raster.py solo per intestazione';


--
-- Name: webgis_target; Type: TABLE; Schema: config; Owner: postgres; Tablespace: 
--

CREATE TABLE config.webgis_target (
    webgis_idx integer NOT NULL,
    radius integer NOT NULL,
    udm text,
    the_geom public.geometry(LineString,32632)
);


ALTER TABLE config.webgis_target OWNER TO postgres;

--
-- Name: TABLE webgis_target; Type: COMMENT; Schema: config; Owner: postgres
--

COMMENT ON TABLE config.webgis_target IS 'Linee concentriche da un bersaglio';


--
-- Name: webgis_toolbar_tools_tool_idx_seq; Type: SEQUENCE; Schema: config; Owner: postgres
--

CREATE SEQUENCE config.webgis_toolbar_tools_tool_idx_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE config.webgis_toolbar_tools_tool_idx_seq OWNER TO postgres;

--
-- Name: webgis_toolbar_tools_tool_idx_seq; Type: SEQUENCE OWNED BY; Schema: config; Owner: postgres
--

ALTER SEQUENCE config.webgis_toolbar_tools_tool_idx_seq OWNED BY config.webgis_toolbar_tools.tool_idx;


--
-- Name: gid; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.animazione_webgis ALTER COLUMN gid SET DEFAULT nextval('config.animazione_webgis_gid_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.news_message ALTER COLUMN gid SET DEFAULT nextval('config.news_message_gid_seq'::regclass);


--
-- Name: baselayer_idx; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_base_layers ALTER COLUMN baselayer_idx SET DEFAULT nextval('config.webgis_base_layers_baselayer_idx_seq'::regclass);


--
-- Name: group_idx; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_groups ALTER COLUMN group_idx SET DEFAULT nextval('config.webgis_groups_group_idx_seq'::regclass);


--
-- Name: layer_idx; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_ol_layers ALTER COLUMN layer_idx SET DEFAULT nextval('config.webgis_ol_layers_layer_idx_seq'::regclass);


--
-- Name: tool_idx; Type: DEFAULT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_toolbar_tools ALTER COLUMN tool_idx SET DEFAULT nextval('config.webgis_toolbar_tools_tool_idx_seq'::regclass);


--
-- Data for Name: animazione_webgis; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.animazione_webgis (label, nome_file, tipo_dato, formato_data, campo_data, gid, note, delta_min, delta_max, delta_udm, path, data_index, bounds3857, size, delta_inizio, delta_passo, attivo, webgis_idx_arr, frame_offset) FROM stdin;
banda X-DEMO	xband_T23:14Z.png	img	HH:MI	\N	19	banda x posizionato su Fiera Milano per EXPO 2015	5	1440	MI	/common/DATA/demo/raster/animation/20150508/	7@@12       	895093.48@@5589039.59@@1127676.15@@5818326.56	614@@604	0	60	1	{8}	2
banda X MAX ECHO	maxband_T23:17Z.png	img	HH:MI	\N	20	banda X massima echo	5	1440	MI	/common/DATA/raster/animation/	9@@14       	1045263@@5652433@@1192304.5@@5799474.5	616@@616	2	60	1	{2,11}	2
banda X SRI	xband_T23:14Z.png	img	HH:MI	\N	21	banda X sri (Lago Iseo)	5	1440	MI	/common/DATA/raster/animation/	7@@12       	1045263@@5652433@@1192304.5@@5799474.5	512@@512	2	60	1	{2,11}	2
test	\N	\N	\N	\N	9	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	\N	2
mosaico Piem. ist-DEMO	googlemap_ist_T22:35Z.png	img	HH:MI	\N	17	\N	5	1440	MI	/common/DATA/demo/raster/animation/20150508/	15@@20      	673811.859@@5310564.071@@1254923.782@@5881520.640	515@@506	0	60	1	{8}	2
mosaico Lema ist-DEMO	googlemap_ist_bis_T10:35Z.png	img	HH:MI	\N	18	\N	5	1440	MI	/common/DATA/demo/raster/animation/20150508/	19@@24      	702363.967@@5311713.301@@1298612.054@@5895539.553	528@@517	0	60	1	{8}	2
mosaico Piem. ist	googlemap_ist_T22:35Z.png	img	HH:MI	\N	3	\N	5	1440	MI	/common/DATA/raster/animation/	15@@20      	673811.859@@5310564.071@@1254923.782@@5881520.640	515@@506	0	60	1	{0,1,2,3,4,5,11,13}	2
mosaico Lema ist	googlemap_ist_bis_T10:35Z.png	img	HH:MI	\N	4	\N	5	1440	MI	/common/DATA/raster/animation/	19@@24      	702363.967@@5311713.301@@1298612.054@@5895539.553	528@@517	0	60	1	{0,1,2,3,5,6,10,13}	2
sismi	sismi	vettore	YYYY-MM-DD HH:MI:SS	full_date	6	campo data di tipo timestamp	1	15	DD	sismica.public	\N	\N	\N	\N	1	0	{0,1,3,8,13}	2
cloud mask	clm_bt_T00:00Z.png	img	HH:MI	\N	8	\N	15	720	MI	/common/DATA/raster/animation/	8@@13       	313624.231@@4942465.181@@1502178.899@@6081869.092	255@@266	0	60	1	{0,1,3,8,11,13}	2
banda X	xband_T23:14Z.png	img	HH:MI	\N	10	banda x posizionato su Fiera Milano per EXPO 2015	5	1440	MI	/common/DATA/raster/animation/	7@@12       	895093.48@@5589039.59@@1127676.15@@5818326.56	614@@604	0	60	0	{0,1,2,3,5,13}	2
COSMOI7-cumulata 1h	COSMOI7_2016070400_01h.png	img	YYYYMMDDYYHH	\N	23	modelli con cumulate orarie	1	72	HH	/common/DATA/modelli_animazione/	8@@18       	-560076.188@@3688352.368@@3000474.587@@6805777.829	458@@401	0	24	1	{0,13}	-1
COSMOI7-cumulata 24h	COSMOI7_2016070100_24h.png	img	YYYYMMDDYYHH	\N	22	modelli con cumulate giornaliere	24	72	HH	/common/DATA/modelli_animazione/	8@@18       	-560076.188@@3688352.368@@3000474.587@@6805777.829	458@@401	0	72	1	{0,13}	-1
mosaico DPC	googlemap_dpc_ist_T21:45Z.png	img	HH:MI	\N	7	\N	10	720	MI	/common/DATA/raster/animation/	19@@24      	499556.8@@4094696@@2662618@@6152957	1543@@1483	0	60	1	{0,1,2,4,5,13}	2
banda X	xband_T23:14Z.png	img	HH:MI	\N	1	banda x posizionato a Vercelli - autostrada	5	720	MI	/common/DATA/raster/animation/	7@@12       	818395.95@@5550636.52@@1045264.95@@5783682.85	515@@506	0	60	1	{0,1,3,5,6,13}	2
mosaico Piem. 3h	googlemap_03h_T05:50Z.png	img	HH:MI	\N	2	\N	5	720	MI	/common/DATA/raster/animation/	15@@20      	673811.859@@5310564.071@@1254923.782@@5881520.640	515@@506	0	60	1	{0,1,2,3,4,5,13}	2
meteoswiss	meteoswiss.radar.precip.201708111550.png	img	YYYYMMDDHHMI	\N	24	test per provare le img radar di meteoswiss per Arpa Lombardia	5	1440	MI	/common/DATA/raster/meteoswiss/animazione/	24@@36      	299385@@5406475@@1387223@@6354697	710@@640	0	60	1	{13}	2
precipitazione prevista	fews_201707010000_mm_3857.png	img	YYYYMMDDHHMI	\N	27	modelli fews lami	1	72	HH	/common/DATA/fews/anime_png/	5@@17       	245849@@3861665@@2329923@@6881447	245@@355	0	24	1	{15}	-1
modelli COSMO	COSMOI2_2014030400_021_EPSG3857.png	img	YYYYMMDDYY_XHH	\N	5	i caratteri X non fanno proprio parte dell ora. YY=ora in cui il modello ha girato	\N	\N	\N	\N	\N	\N	\N	\N	\N	0	{0,13}	2
\.


--
-- Name: animazione_webgis_gid_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.animazione_webgis_gid_seq', 27, true);


--
-- Data for Name: anomalie_severita; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.anomalie_severita (severita_idx, severita_descr, impatto_operativo, severita_colore) FROM stdin;
1	lieve	t	yellow
2	moderata	t	orange
3	grave	t	red
11	lieve	f	khaki
12	moderata	f	lightsalmon
13	grave	f	lightcoral
0	nessuna	\N	white
\.


--
-- Data for Name: anomalie_sistemi; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.anomalie_sistemi (id_sistema, descrizione, data_agg, autore_agg) FROM stdin;
3	ARX - banda X mobile	2012-06-08 09:14:17.366016	cremo
4	Fulmini	2012-06-08 09:14:31.495542	cremo
6	Storm-tracking	2012-06-08 09:15:21.843811	cremo
7	Defense	2012-06-08 09:16:00.359382	cremo
8	Altri sistemi	2012-08-28 10:41:13.608921	cremo
1	Radar Bric della Croce (TO)	2012-06-08 09:13:51.307757	cremo
2	Radar Monte Settepani (SV)	2012-06-08 09:14:06.109134	cremo
5	Mosaico radar Nazionale DPC	2012-06-08 09:14:46.232732	cremo
\.


--
-- Data for Name: httpd_users; Type: TABLE DATA; Schema: config; Owner: apache_rw
--

COPY config.httpd_users (username, password, groups, active) FROM stdin;
iris_base	{SHA}qUqP5cyxm6YcTAhz05Hph5gvu9M=	testgroup	1
test_XX	{SHA}qUqP5cyxm6YcTAhz05Hph5gvu9M=	testNOgroup	1
\.


--
-- Data for Name: news_message; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.news_message (gid, messaggio, icona_iniziale, data_validita, data_scadenza, webgis_idx) FROM stdin;
1	Benvenuto in IRIS! Il sistema usa dei cookie tecnici per migliorarne l'utilizzo	common/icons/toolbar_icons/smile.png	2015-12-10	\N	\N
2	Tieni sempre sotto controllo le novita' del WebGIS!!	common/icons/toolbar_icons/news.png	2015-12-01	\N	\N
\.


--
-- Name: news_message_gid_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.news_message_gid_seq', 3, false);


--
-- Data for Name: tab_tipo_evento; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.tab_tipo_evento (id_tipo_evento, nome_tipo_evento, descrizione, data_agg, autore_agg) FROM stdin;
1	dust devil  	A vortex not associated with a convective storm, typically between a few metres to a few tens of metres in diameter, extending upward from the earth's surface but not reaching any cloud. It is rendered visible by material lifted off the earth's surface (land devils) or by water droplets (water devils). Lesser whirlwinds result from temperature differences between the surface and the air above. Whirls in the lee of objects (e.g. buildings) are not considered a 'lesser whirlwind' here. 	2018-05-11 00:00:00	cremo
2	gustnado	A vortex occurring along a gust front of a convective storm that is visible by material that is lifted off the earth's surface. It is typically a few metres to a few tens of metres in diameter and extends upward from the earth's surface but is not connected with a cloud. In case of uncertainty whether a gustnado really occurred, do not select gustnado. If it is certain that either a tornado or gustnado occurred, select "tornado". If a "severe wind gust" may have occurred instead of a gustnado, please select	2018-05-11 00:00:00	cremo
3	heavy rain	Heavy rain defined here as rain falling in such large amounts, that significant damage is caused, or no damage is known, but precipitation amounts have been observed that are exceptional for the region in question.  	2018-05-11 00:00:00	cremo
4	large hail	The falling of hailstones having a diameter (in the longest direction) of 2.0 centimetres or more and/or smaller hailstones that form a layer of 2.0 cm thickness or more on flat parts of the earth's surface. 	2018-05-11 00:00:00	cremo
5	tornado	A tornado or waterspout is a vortex typically between a few metres to a few kilometres in diameter, extending between a convective cloud and the earth's surface, that may be visible by condensation of water and/or by material (e.g. water, in case of a waterspout) that is lifted off the earth's surface. \n\nRemark: select "tornado or waterspout" when a tornado or waterspouts is likely to have occurred or in case of doubt between a tornado or gustnado. If it is possible that a "severe wind gust" has occurred in	2018-05-11 00:00:00	cremo
6	severe wind  	A severe wind gust is a gust measured to have a speed of at least 25 m/s or one doing such damage that a wind speed of 25 m/s or higher is likely to have occurred.    	2018-05-11 00:00:00	cremo
7	heavy snowfall/snowstorm	Snow (or snow grains) and/or snowstorm in an amount that causes - or is capable of causing - important disruptions of daily life and/or considerable material or economical damage. 	2018-05-11 00:00:00	cremo
8	ice accumulation	Accumulations of ice on the earth’s surface and/or objects (such as power lines) in an amount that causes - or is capable of causing - important disruptions of daily life and/or considerable material damage or economical damage, not including ice accumulations resulting primarily from snowfall. Ice accumulations may result from freezing rain, freezing drizzle, freezing fog or from direct deposition of water vapour, resulting in glaze, frost or rime. 	2018-05-11 00:00:00	cremo
9	avalanche  	A rapid flow of snow down a slope.    	2018-05-11 00:00:00	cremo
10	damaging lightning	A lightning strike causing important damage to aircraft, vehicles, ships, or injuring/killing people or animals. Ball lightning or other exceptional lightning phenomena can be reported in this category also if no damage was reported.  	2018-05-11 00:00:00	cremo
\.


--
-- Data for Name: webgis_base_layers; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_base_layers (baselayer_idx, openlayer_name, layer_legend_name, layer_description, geom_srid) FROM stdin;
2	gsat	Google Satellite	Google Satellite	3857
3	gter	Google Rilievo	Google Rilievo	3857
8	osmGray	OSM Grayscale	OSM Grayscale	3857
4	osmLayer	OpenStreetMap	OpenStreetMap base	3857
5	osmLandscape	OSM Landscape	OSM Landscape con curve di livello	3857
6	osmSat	OSM Satellite	OSM Satellite	3857
7	osmMapQuest	OSM MapQuest	OSM MapQuest	3857
11	wms_regione_colore	WMS Regione	WMS Regione	3857
12	wms_regione_raster	WMS Regione - raster	WMS Regione - raster	3857
10	wms_regione_bn	WMS Regione BN	WMS Regione BN	3857
13	wms_modis	MODIS 24h	WMS MODIS 24h	3857
14	OpenTopoMap	Open Topo Map	Open Topo Map	3857
9	wms_arpa	WMS Arpa	WMS Arpa	3857
15	wms_lombardia_ctr	CTR Regione Lombardia 10k	CTR Regione Lombardia 10k	32632
16	wms_lombardia_ortofoto	Ortofoto Agea 2015 - Reg.Lombard	Ortofoto Agea 2015 - Reg.Lombardia	32632
\.


--
-- Name: webgis_base_layers_baselayer_idx_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.webgis_base_layers_baselayer_idx_seq', 16, true);


--
-- Data for Name: webgis_groups; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_groups (legend_group_name, pedice, group_father, description, group_idx, order_in_webgis, expanded, is_father, children_array) FROM stdin;
Dati di base	base	\N	\N	4	0	f	0	\N
Risorse idriche1	idro_up	\N	Idrologia - cartella con figli	7	51	t	1	{idro1,piene1,siccita1}
Piene2	idro1	idro_up	\N	21	52	f	-1	\N
Piene1	piene1	idro_up	\N	20	50	f	-1	\N
Allerta	allerta	\N	Temi per allerta CF	26	1	f	0	\N
Neve	neve	\N	\N	9	6	f	0	\N
Siccita	siccita1	idro_up	\N	22	7	f	-1	\N
Radar meteo	radar1	\N	\N	8	8	f	0	\N
Stazioni meteoidrografiche	rete	\N	\N	6	9	f	0	\N
Cataloghi sismici	ingv	sismi_up	\N	17	12	f	-1	\N
Sorgenti sismogenetiche	diss	sismi_up	\N	18	13	f	-1	\N
Pericolosita sismica	claxsism	sismi_up	\N	19	14	f	-1	\N
Temporali	temporali	\N	\N	11	15	f	0	\N
Layer in TEST	test	\N	\N	12	16	f	0	\N
Animazione	animazione2	\N	layer di animazione dovrebbero stare nascosti	25	18	f	0	\N
Frane	suolo1	\N	\N	5	5	f	0	\N
Piene	pienedef	\N	\N	28	2	f	0	\N
Idrologia	idro0	\N	Idrologia - cartella singola	23	3	t	0	\N
Risorse Idriche	risorseidro	\N	\N	27	4	f	0	\N
Modelli	modelli	svil_up	\N	24	17	f	-1	\N
Radar	radar2	svil_up	Temi in sviluppo radar	30	100	f	-1	\N
Sviluppo	svil_up	\N	Temi in sviluppo	29	30	f	1	{modelli,radar2}
RSNI-Monitoraggio sismico	sismi1	sismi_up	\N	16	11	f	-1	\N
Sismica	sismi_up	\N	\N	10	10	f	1	{sismi1,ingv,diss,claxsism}
Pioggia (raster)	pluv_rast	\N	Dati di pioggia osservati o previsti in forma di raster	31	19	f	0	\N
\.


--
-- Name: webgis_groups_group_idx_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.webgis_groups_group_idx_seq', 31, true);


--
-- Data for Name: webgis_indici; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_indici (webgis_name, webgis_description, webgis_idx, default_raster, zoom_center, lon_center, lat_center, query_map_idx, baselayers, collapsed_grid, defaultgrid_layeridx, attivo, themes_path, scripts_path, nomelogo, urllogo, map_path, url_tinyows, url_tinyows_sigeo, titlelogo, id_logo_div, local_path, query_map_extra_idx) FROM stdin;
iris_base	IRIS minimale per distribuzione	1	3	8	8.19999999999999929	45.2000000000000028	13	{4,14,5,8,2,3,12,11,10,9}	t	\N	1	/common/tematismi	/common/scripts	/common/icons/logo_ArpaPiemonte_transp.png	http://www.arpa.piemonte.gov.it/	/var/www/IRIS_BASE/html/common/mapfiles/	/cgi-bin/tinyows	/cgi-bin/tinyows_sigeo	WebGis IRIS	logo	/iris_base/	{C}
\.


--
-- Name: webgis_indici_idx_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.webgis_indici_idx_seq', 1, true);


--
-- Data for Name: webgis_layers; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_layers (webgis_idx, legend_name, legend_group_idx, select_highlight, visible, order_in_webgis, ol_layer_idx) FROM stdin;
1	SIVA	4	0	0	6	11
1	Rete meteoidro	4	3	0	0	1
1	Temperature	6	3	0	1	2
1	Neve dalle 8	6	3	0	2	4
1	Rete meteoidro SLD	4	3	0	3	6
1	Reticolo idrografico - Lombardia	4	0	0	5	9
1	Limiti comuni - MS	4	0	0	4	8
\.


--
-- Data for Name: webgis_ol_layers; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_ol_layers (layer_idx, openlayer_name, default_legend_variable, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title) FROM stdin;
2	temperatura_tiny	layer2	iris_base.realtime.v_last_terma	tinyows	Dati termometrici - ultimo valore	stile secondo il campo ultimovalore, con etichetta nel cerchio	t	\N	\N	f	\N	t	POINT	23032	\N
3	datistazioni_tiny	layer3	iris_base.realtime.v_last_vento	tinyows	Dati anemometrici - ultimo valore	stile con oggetto grafico esterno secondo valore e direzione vento	t	\N	\N	f	\N	t	POINT	23032	\N
4	nivo_tiny	layer4	iris_base.realtime.v_last_nivo	tinyows	Dati neve fresca dalle 8	stile secondo il campo ultimovalore, con etichetta nel cerchio	t	\N	\N	f	\N	t	POINT	23032	\N
5	rete_pluv_expo	layer5	iris_base.realtime.v_last_pluv	tinyows	Dati pluviometrici - cumulata ultime 3 ore	stile secondo il campo ultimovalore, con etichetta nel cerchio	t	\N	\N	f	\N	t	POINT	4326	\N
6	rete_meteoidro_sld	layer6	iris_base.dati_di_base.rete_meteoidrografica	mapserver	stazioni meteo RUPAR area piemontese e limitrofe	stile con SLD da QGis	f	\N	\N	f	\N	f	POINT	23032	\N
1	rete_meteoidro	layer1	iris_base.dati_di_base.rete_meteoidrografica	mapserver	stazioni meteo RUPAR area piemontese e limitrofe	stile secondo tipo stazione campo meteo_tab	f	store_meteoidro	columns_meteoidro	f	\N	f	POINT	23032	Anagrafica stazioni rete a terra (double-click to zoom on interested station)
9	reticolo_idro_lm_MS	layer9	iris_base.dati_di_base.cinaturali	mapserver	Reticolo idrografico lombardia	stile unico	f	\N	\N	f	\N	f	MULTILINEZ	32632	\N
11	valanghe_wms	layer11	webgis.arpa.piemonte.it/ags101free/services/geologia_e_dissesto/SIVA/MapServer/WMSServer	WMS	SIVA da Arpa Piemonte	stile secondo WMS	f	\N	\N	f	\N	f	WMS	3857	\N
8	limiti_comuni_MS	layer8	iris_base.dati_di_base.limiti_comuni_italiani_2018	mapserver	Limiti comuni italiani - ISTAT 2018	stile unico	f	\N	\N	f	\N	f	POLYGON	32632	\N
\.


--
-- Name: webgis_ol_layers_layer_idx_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.webgis_ol_layers_layer_idx_seq', 11, true);


--
-- Data for Name: webgis_popups; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_popups (ol_layer_idx, webgis_idx, funzione_associata, url_link, url_name, url_options, grafici_stazione, grafici_tab_attivo, pop_html, pop_title, grafici_valore, grafici_codice, grafici_progr, grafici_tipostaz, grafici_tiporete, grafici_composito) FROM stdin;
1	1	grafici_rete				meteoidro	TERMA			codice_istat_comune	codice_istat_comune	progr_punto_com	tipo_staz	grafici_stazione	{2}
\.


--
-- Data for Name: webgis_query_map; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_query_map (query_map_idx, query_description) FROM stdin;
0	Nessuna query su mappa attiva
1	Funzionalita complete dello script query_raster.py
2	Funzionalita complete tranne RHI per il banda X
3	Nessun accesso ai dati piemontesi (mosaici radar, cumulate da rete a terra, etc)
4	Nessun dato per il banda X
5	Interrogo solo i raster DPC, Meteosat e Mosaico NW
6	Funzionalita complete tranne grafico su atlante delle piogge
7	Interrogo solo i raster DPC, Meteosat e Lema
8	Interrogo solo Meteosat, radar Piemonte e BandaX
9	Interrogo solo i raster DPC, mosaico LEMA, Meteosat e cumulate da rete a terra
10	Interrogo solo Meteosat
11	Interrogo solo dati di neve - raster
12	Interrogo DPC e previsioni FEWS a 72h, senza Tipo di precipitazione
13	Interrogo raster via MapServer - IN SVILUPPO
\.


--
-- Data for Name: webgis_query_map_extra; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_query_map_extra (query_map_idx, query_description) FROM stdin;
A	mostro dataora
B	mostro strumento conversione coordinate
C	mostra info da google
D	mostra info comune da DB
\.


--
-- Data for Name: webgis_target; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_target (webgis_idx, radius, udm, the_geom) FROM stdin;
11	10	km	0102000020787F000021000000D2AAF559122B2241B413B7E7C94D5341B965980E92292241C6B7E82DE24B534134852AF11F252241AF8451320D4A534179E75FBEE71D22415E19C4FA5C48534154E7AD7C30142241260C6023E2465341727D8DC15908224126CC293BAB455341CB222205D8FA21417378D034C4445341028A682830EC214166BC22F13544534177AAF559F2DC2141C613B7E705445341F0CA828BB4CD21416BBC22F1354453412932C9AE0CBF21417C78D034C444534187D75DF28AB1214134CC293BAB455341AC6D3D37B4A52141390C6023E24653418E6D8BF5FC9B21417419C4FA5C485341D8CFC0C2C4942141C78451320D4A534157EF52A552902141DFB7E82DE24B534140AAF559D28E2141CE13B7E7C94D534159EF52A552902141BD6F85A1B14F5341D8CFC0C2C4942141D5A21C9D865153418E6D8BF5FC9B2141290EAAD436535341AC6D3D37B4A52141611B0EACB154534187D75DF28AB12141625B4494E85553412832C9AE0CBF214115AF9D9ACF565341EECA828BB4CD2141246B4BDE5D57534178AAF559F2DC2141C513B7E78D575341018A682830EC21411E6B4BDE5D575341CC222205D8FA21410BAF9D9ACF565341737D8DC159082241535B4494E855534156E7AD7C301422414F1B0EACB154534179E75FBEE71D2241120EAAD43653534135852AF11F252241BDA21C9D86515341BA65980E92292241A26F85A1B14F5341D2AAF559122B2241B413B7E7C94D5341
11	20	km	0102000020787F00002100000060ABF559327922419713B7E7C94D53412A213BC331762241BC5B1A74FA4953411C605F884D6D224191F5EB7C504653419A24CA22DD5E2241F01ED10DF04253414724669F6E4B22418304095FFA3F53417C502529C133224185849C8E8C3D5341249B4EB0BD1822411FDDE981BE3B53418D69DBF66DFB214107658EFAA13A534178AAF559F2DC2141C613B7E7413A534167EB0FBD76BE214110658EFAA13A5341DFB99C0327A1214132DDE981BE3B5341A004C68A23862141A2849C8E8C3D5341EE308514766E2141AB04095FFA3F5341B8302191075B21411F1FD10DF04253414EF58B2B974C2141C7F5EB7C504653414E34B0F0B2432141F65B1A74FA49534121AAF559B2402141D413B7E7C94D53414D34B0F0B2432141B4CB535B995153414DF58B2B974C2141E031825243555341B7302191075B214184089DC1A3585341EE308514766E2141FA226570995B53419F04C68A23862141FEA2D140075E5341DEB99C0327A12141684A844DD55F534166EB0FBD76BE214183C2DFD4F160534178AAF559F2DC2141C413B7E7516153418D69DBF66DFB214179C2DFD4F1605341259B4EB0BD182241534A844DD55F53417B502529C1332241E0A2D140075E53414924669F6E4B2241D2226570995B53419A24CA22DD5E224156089DC1A35853411B605F884D6D2241AA318252435553412C213BC33176224178CB535B9951534160ABF559327922419713B7E7C94D5341
11	30	km	0102000020787F00002100000030ACF55952C722416A13B7E7C94D5341DCDCDD77D1C222419FFF4BBA12485341393B941F7BB52241646686C793425341E5613487D29F22417824DE20833D534156611EC2AC822241D9FCB19A123953419223BD90285F2241E03C0FE26D35534185137B5BA3362241CB4103CFB83253411B494EC5AB0A2241A50DFA030E31534177AAF559F2DC2141C613B7E77D305341E10B9DEE38AF2141B40DFA030E3153419841705841832141E84103CFB8325341BF312E23BC5A21410D3D0FE26D3553413AF4CCF13737214118FDB19A12395341ECF3B62C121A2141C824DE20833D5341D11A579469042141C26686C79342534152790D3C13F7204108004CBA124853410FAAF55992F22041D513B7E7C94D534153790D3C13F72041A427221581535341D11A579469042141EBC0E70700595341ECF3B62C121A2141E20290AE105E534139F4CCF1373721418F2ABC3481625341BF312E23BC5A214197EA5EED256653419841705841832141B8E56A00DB685341DF0B9DEE38AF2141E21974CB856A534177AAF559F2DC2141C513B7E7156B53411A494EC5AB0A2241D51974CB856A534185137B5BA336224197E56A00DB6853419323BD90285F224166EA5EED2566534156611EC2AC8222414D2ABC3481625341E6613487D29F22418F0290AE105E5341393B941F7BB5224189C0E70700595341DCDCDD77D1C222413B2722158153534130ACF55952C722416A13B7E7C94D5341
11	40	km	0102000020787F0000210000005BADF559721523412313B7E7C94D5341E598802C710F23416EA37D002B4653419F16C9B6A8FD224125D72012D73E5341689F9EEBC7E02241F229EB3316385341879ED6E4EAB9224127F55AD62A325341BCF654F88F8A224136F581354F2D5341EB8BA7068954224175A61C1CB3295341A928C193E919224144B6650D7A27534178AAF559F2DC2141C713B7E7B92653415B2C2A20FB9F214159B6650D7A27534156C943AD5B6521419EA61C1CB3295341E45E96BB542F214179F581354F2D53418EB714CFF9FF204186F55AD62A3253412AB74CC81CD920416F2AEB33163853415C4022FD3BBC2041BCD72012D73E534162BE6A8773AA204119A47D002B46534107AAF55972A42041D713B7E7C94D534162BE6A8773AA20419583F0CE685553415C4022FD3BBC2041F34F4DBDBC5C534127B74CC81CD920413DFD829B7D6353418BB714CFF9FF2041263213F968695341E15E96BB542F21413132EC99446E534154C943AD5B652141088151B3E07153415A2C2A20FB9F2141427108C21974534176AAF559F2DC2141C413B7E7D9745341A928C193E91922412C7108C219745341ED8BA70689542241DB8051B3E0715341BEF654F88F8A2241E931EC99446E53418A9ED6E4EAB92241C13113F968695341689F9EEBC7E02241B9FC829B7D635341A116C9B6A8FD2241554F4DBDBC5C5341E698802C710F2341E682F0CE685553415BADF559721523412313B7E7C94D5341
11	50	km	0102000020787F000021000000FEAEF55992632341BB12B7E7C94D53415E5523E1105C23411E47AF464344534165F2FD4DD6452341CA47BB5C1A3B53412CDD0850BD2123415B2FF846A9325341E6DB8E0729F1224169ED0312432B5341FDC9EC5FF7B5224188ADF488302553415C04D4B16E7222411C0B3669AD2053413A08346227292241E55ED116E61D534178AAF559F2DC2141C613B7E7F51C5341D74CB751BD902141FD5ED116E61D53411651170276472141510B3669AD2053410D8CFE53ED032141E4ADF48830255341E57A5CACBBC82041F2ED0312432B53416C7AE263279820411730F846A9325341ED65ED650E742041B448BB5C1A3B53417503C8D2D35D20412C48AF464344534102AAF55952562041D713B7E7C94D53417403C8D2D35D204185DFBE8850575341ED65ED650E742041F7DEB272796053416A7AE2632798204197F77588EA685341E37A5CACBBC82041BB396ABD507053410B8CFE53ED032141C7797946637653411251170276472141561C3866E67A5341D64CB751BD9021419FC89CB8AD7D534177AAF559F2DC2141C413B7E79D7E5341390834622729224185C89CB8AD7D53415E04D4B16E7222411B1C3866E67A534100CAEC5FF7B522416379794663765341E9DB8E0729F1224127396ABD5070534132DD0850BD212341D1F67588EA68534166F2FD4DD645234103DEB272796053415F5523E1105C23416FDEBE8850575341FEAEF55992632341BB12B7E7C94D5341
11	60	km	0102000020787F0000210000003AB1F559B2B123412312B7E7C94D53416612C695B0A82341A1EAE08C5B4253419FCE32E5038E234151B855A75D3753414A1B73B4B2622341AE34055A3C2D53417719472A672823419FE5AC4D5B245341579D84C75EE12241D46567DC111D5341D57C005D54902241C16F4FB6A7175341CBE7A6306538224184073D205214534179AAF559F2DC2141C713B7E731135341536D44837F812141A0073D2052145341D7D8EA569029214104704FB6A717534138B966EC85D820414D6667DC111D5341403EA4897D9120415EE6AC4D5B245341B03D78FF31572041BE35055A3C2D5341818BB8CEE02B2041B0B955A75D3753418A48251E341120413BECE08C5B42534102AAF55932082041D713B7E7C94D53418B48251E34112041743B8D4238595341808BB8CEE02B2041FF6D182836645341AE3D78FF31572041F1F16875576E53413E3EA4897D9120414F41C1813877534135B966EC85D8204161C106F3817E5341D4D8EA5690292141A4B71E19EC835341526D44837F812141FD1F31AF4187534176AAF559F2DC2141C513B7E761885341CDE7A63065382241DC1F31AF41875341D87C005D5490224156B71E19EC8353415C9D84C75EE12241D9C006F3817E53417C19472A672823417B40C18138775341501B73B4B2622341CBF06875576E5341A3CE32E5038E23418C6C1828366453416812C695B0A82341D0398D42385953413AB1F559B2B123412312B7E7C94D5341
11	70	km	0102000020787F00002100000038B4F559D2FF23415011B7E7C94D534121D0684A50F52341EE8D12D3734053416DAB677C31D62341AB28F0F1A0335341CF59DD18A8A32341E139126DCF2753414757FF4CA55F2341C5DD5589731D5341D0701C2FC60C2341171EDA2FF314534158F52C083AAE224165D46803A20E53415EC719FFA247224122B0A829BE0A534177AAF559F2DC2141C813B7E76D095341D28DD1B44172214146B0A829BE0A53419B60BEABAA0B2141B8D46803A20E534166E6CE841EAD2041B51EDA2FF31453419C01EC663F5A2041CBDE5589731D5341F6000E9B3C162041643B126DCF2753412B62076F66C71F41A92AF0F1A0335341411B05D328891F414C9012D3734053410354EBB324741F41D713B7E7C94D5341401B05D328891F4163975BFC1F5B53412862076F66C71F4107FD7DDDF2675341F3000E9B3C1620414CEC5B62C47353419901EC663F5A2041E6481846207E534164E6CE841EAD2041F708949FA08653419860BEABAA0B2141F35205CCF18C5341CF8DD1B4417221415C77C5A5D590534177AAF559F2DC2141C513B7E72592534160C719FFA24722413377C5A5D59053415DF52C083AAE2241915205CCF18C5341D7701C2FC60C23414108949FA08653415157FF4CA55F2341BD471846207E5341D759DD18A8A32341A3EA5B62C473534176AB677C31D62341E7FA7DDDF267534126D0684A50F52341F1945BFC1F5B534138B4F559D2FF23415011B7E7C94D5341
11	80	km	0102000020787F0000210000001EB8F559F24D24412910B7E7C94D5341BA8E0BFFEF412441F23044198C3E5341F0889C135F1E2441CE988A3CE42F5341D198477D9DE42341F33E1F80622253416295B76FE3962341D6D5FEC48B1653416E44B4962D38234152D64C83D40C5341E86D59B31FCC2241053982509C055341F7A68CCDE0562241C25814332A01534179AAF559F2DC2141C713B7E7A9FF52414FAE5EE603632141E95814332A01534160E89100C5ED20416B3982509C0553419713371DB78120411ED74C83D40C5341FBC433440123204137D7FEC48B1653417988476D8EAA1F410B411F806222534155AD9D400B371F41A29B8A3CE42F53416EA5BF69E9EF1E415C3444198C3E53410354EBB3E4D71E41D913B7E7C94D53416BA5BF69E9EF1E4153F329B6075D534152AD9D400B371F410D8CE392AF6B53417488476D8EAA1F41A6E64E4F31795341F8C433440123204179506F0A088553419213371DB78120419050214CBF8E53415CE89100C5ED204141EEEB7EF79553414DAE5EE603632141BACE599C699A534176AAF559F2DC2141C413B7E7E99B5341F6A68CCDE05622418ACE599C699A5341F06D59B31FCC2241C7EDEB7EF79553417844B4962D3823419F4F214CBF8E53417095B76FE3962341E34E6F0A08855341DE98477D9DE423414EE44E4F31795341FC889C135F1E2441FF88E392AF6B5341C08E0BFFEF412441C7EF29B6075D53411EB8F559F24D24412910B7E7C94D5341
\.


--
-- Data for Name: webgis_toolbar_tools; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_toolbar_tools (tool_idx, tool_name, tool_description, tool_icon) FROM stdin;
1	search_OSM	Ricerca localita con OSM	\N
13	zoomSelector	Menu a tendina con elenco zoom disponibili	\N
4	anime	Pannello per animazione layer raster	/common/icons/toolbar_icons/film2-26.png
5	dialog0	Strumento di gestione Piene con alcuni grafici	/common/icons/toolbar_icons/flood_dav.png
6	dialog_upload	Strumento di upload dati per Rischio Industriale	/common/icons/toolbar_icons/up_and_download-dav.png
7	list_alert	Elenco avvisi sui temporali	/common/icons/toolbar_icons/storm_intenso_lightning_black.png
8	flanis_anime	Animazione tramite plugin Flanis su radar	/common/icons/toolbar_icons/radar_flanis.png
11	cookies_diy	Impostazione di cookie tecnici personalizzati	/common/icons/toolbar_icons/mixer.png
14	tickets	Strumento per rilascio ticket su malfunzionamenti del servizio	/common/icons/toolbar_icons/ticket_davide.png
2	combo	Menu a tendina per ricerca rapida su un layer - occorre specificare il layer su toolbar_tools.js	\N
10	expo_meteo	Link a bollettino meteo per Expo2015 (o altro specificato in toolbar_tools.js-expo_meteo)	\N
9	expo_bullettin	Link a previsioni probabilistiche per Expo2015 (o altro specificato in toolbar_tools.js-expo_meteo)	\N
12	news_btn	Novita sul WebGis - contenuto della tabella config.news_message	/common/icons/toolbar_icons/news.png
15	split_link	Menu a tendina con alcuni link a pagine esterne (specificato in toolbar_tools.js-split_link)	\N
3	dialog	Menu con informazioni sul servizio WebGIS e credits (credit_tab.js, toolbar_panels.js, toolbar_tools.js-info_panel)	/common/icons/toolbar_icons/info2-dav.png
17	combo_layers	Scelta di layer e feature da menu a tendina - IN SVILUPPO!	\N
16	multiselect	Possibilita di selezione multipla - IN SVILUPPO!	/common/icons/toolbar_icons/multiselect.png
18	report_evento	Dal clic su mappa apre una maschera per inserire un evento meteorologico	/common/icons/toolbar_icons/query_map_star.png
\.


--
-- Name: webgis_toolbar_tools_tool_idx_seq; Type: SEQUENCE SET; Schema: config; Owner: postgres
--

SELECT pg_catalog.setval('config.webgis_toolbar_tools_tool_idx_seq', 18, true);


--
-- Data for Name: webgis_tools; Type: TABLE DATA; Schema: config; Owner: postgres
--

COPY config.webgis_tools (webgis_idx, tools_idx) FROM stdin;
1	1
1	3
1	4
1	7
1	8
1	11
1	13
1	14
1	15
1	17
1	16
1	18
\.


--
-- Name: animazione_webgis_label_attivo_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.animazione_webgis
    ADD CONSTRAINT animazione_webgis_label_attivo_key UNIQUE (label, attivo);


--
-- Name: animazione_webgis_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.animazione_webgis
    ADD CONSTRAINT animazione_webgis_pkey PRIMARY KEY (gid);


--
-- Name: anomalie_severita_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.anomalie_severita
    ADD CONSTRAINT anomalie_severita_pkey PRIMARY KEY (severita_idx);


--
-- Name: httpd_authn_pkey; Type: CONSTRAINT; Schema: config; Owner: apache_rw; Tablespace: 
--

ALTER TABLE ONLY config.httpd_users
    ADD CONSTRAINT httpd_authn_pkey PRIMARY KEY (username);


--
-- Name: id_tipo_evento; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.tab_tipo_evento
    ADD CONSTRAINT id_tipo_evento PRIMARY KEY (id_tipo_evento);


--
-- Name: news_message_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.news_message
    ADD CONSTRAINT news_message_pkey PRIMARY KEY (gid);


--
-- Name: pk_sistema; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.anomalie_sistemi
    ADD CONSTRAINT pk_sistema PRIMARY KEY (id_sistema);


--
-- Name: webgis_base_layers_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_base_layers
    ADD CONSTRAINT webgis_base_layers_pkey PRIMARY KEY (baselayer_idx);


--
-- Name: webgis_groups_group_idx_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_groups
    ADD CONSTRAINT webgis_groups_group_idx_key UNIQUE (group_idx);


--
-- Name: webgis_groups_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_groups
    ADD CONSTRAINT webgis_groups_pkey PRIMARY KEY (pedice);


--
-- Name: webgis_indici_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_indici
    ADD CONSTRAINT webgis_indici_pkey PRIMARY KEY (webgis_name);


--
-- Name: webgis_indici_webgis_idx_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_indici
    ADD CONSTRAINT webgis_indici_webgis_idx_key UNIQUE (webgis_idx);


--
-- Name: webgis_layers_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_layers
    ADD CONSTRAINT webgis_layers_pkey PRIMARY KEY (ol_layer_idx, webgis_idx);


--
-- Name: webgis_layers_webgis_idx_legend_name_legend_group_idx_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_layers
    ADD CONSTRAINT webgis_layers_webgis_idx_legend_name_legend_group_idx_key UNIQUE (webgis_idx, legend_name, legend_group_idx);


--
-- Name: webgis_ol_layers_default_legend_variable_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_ol_layers
    ADD CONSTRAINT webgis_ol_layers_default_legend_variable_key UNIQUE (default_legend_variable);


--
-- Name: webgis_ol_layers_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_ol_layers
    ADD CONSTRAINT webgis_ol_layers_pkey PRIMARY KEY (layer_idx);


--
-- Name: webgis_popups_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_popups
    ADD CONSTRAINT webgis_popups_pkey PRIMARY KEY (ol_layer_idx, webgis_idx);


--
-- Name: webgis_query_map_extra_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_query_map_extra
    ADD CONSTRAINT webgis_query_map_extra_pkey PRIMARY KEY (query_map_idx);


--
-- Name: webgis_query_map_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_query_map
    ADD CONSTRAINT webgis_query_map_pkey PRIMARY KEY (query_map_idx);


--
-- Name: webgis_target_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_target
    ADD CONSTRAINT webgis_target_pkey PRIMARY KEY (webgis_idx, radius);


--
-- Name: webgis_toolbar_tools_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_toolbar_tools
    ADD CONSTRAINT webgis_toolbar_tools_pkey PRIMARY KEY (tool_idx);


--
-- Name: webgis_toolbar_tools_tool_name_key; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_toolbar_tools
    ADD CONSTRAINT webgis_toolbar_tools_tool_name_key UNIQUE (tool_name);


--
-- Name: webgis_tools_pkey; Type: CONSTRAINT; Schema: config; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY config.webgis_tools
    ADD CONSTRAINT webgis_tools_pkey PRIMARY KEY (webgis_idx, tools_idx);


--
-- Name: webgis_indici query_map_extra_ins; Type: RULE; Schema: config; Owner: postgres
--

CREATE RULE query_map_extra_ins AS
    ON INSERT TO config.webgis_indici
   WHERE (NOT (new.query_map_extra_idx <@ ( SELECT (array_agg(webgis_query_map_extra.query_map_idx))::character varying[] AS array_agg
           FROM config.webgis_query_map_extra))) DO INSTEAD NOTHING;


--
-- Name: webgis_indici query_map_extra_upd; Type: RULE; Schema: config; Owner: postgres
--

CREATE RULE query_map_extra_upd AS
    ON UPDATE TO config.webgis_indici
   WHERE (NOT (new.query_map_extra_idx <@ ( SELECT (array_agg(webgis_query_map_extra.query_map_idx))::character varying[] AS array_agg
           FROM config.webgis_query_map_extra))) DO INSTEAD NOTHING;


--
-- Name: trigger_update_legend_variable; Type: TRIGGER; Schema: config; Owner: postgres
--

CREATE TRIGGER trigger_update_legend_variable AFTER INSERT ON config.webgis_ol_layers FOR EACH ROW EXECUTE PROCEDURE config.update_legend_variable();


--
-- Name: httpd_access_username_fkey; Type: FK CONSTRAINT; Schema: config; Owner: apache_rw
--

ALTER TABLE ONLY config.httpd_access
    ADD CONSTRAINT httpd_access_username_fkey FOREIGN KEY (username) REFERENCES config.httpd_users(username) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: httpd_access_webgis_type_fkey; Type: FK CONSTRAINT; Schema: config; Owner: apache_rw
--

ALTER TABLE ONLY config.httpd_access
    ADD CONSTRAINT httpd_access_webgis_type_fkey FOREIGN KEY (webgis_type) REFERENCES config.webgis_indici(webgis_name);


--
-- Name: webgis_groups_group_father_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_groups
    ADD CONSTRAINT webgis_groups_group_father_fkey FOREIGN KEY (group_father) REFERENCES config.webgis_groups(pedice) ON UPDATE CASCADE;


--
-- Name: webgis_indici_default_raster_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_indici
    ADD CONSTRAINT webgis_indici_default_raster_fkey FOREIGN KEY (default_raster) REFERENCES config.animazione_webgis(gid);


--
-- Name: webgis_indici_defaultgrid_layeridx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_indici
    ADD CONSTRAINT webgis_indici_defaultgrid_layeridx_fkey FOREIGN KEY (defaultgrid_layeridx) REFERENCES config.webgis_ol_layers(layer_idx) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: webgis_indici_query_map_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_indici
    ADD CONSTRAINT webgis_indici_query_map_idx_fkey FOREIGN KEY (query_map_idx) REFERENCES config.webgis_query_map(query_map_idx);


--
-- Name: webgis_layers_legend_group_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_layers
    ADD CONSTRAINT webgis_layers_legend_group_idx_fkey FOREIGN KEY (legend_group_idx) REFERENCES config.webgis_groups(group_idx);


--
-- Name: webgis_layers_ol_layer_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_layers
    ADD CONSTRAINT webgis_layers_ol_layer_idx_fkey FOREIGN KEY (ol_layer_idx) REFERENCES config.webgis_ol_layers(layer_idx);


--
-- Name: webgis_layers_webgis_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_layers
    ADD CONSTRAINT webgis_layers_webgis_idx_fkey FOREIGN KEY (webgis_idx) REFERENCES config.webgis_indici(webgis_idx) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: webgis_popups_webgis_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_popups
    ADD CONSTRAINT webgis_popups_webgis_idx_fkey FOREIGN KEY (webgis_idx, ol_layer_idx) REFERENCES config.webgis_layers(webgis_idx, ol_layer_idx) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: webgis_tools_tools_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_tools
    ADD CONSTRAINT webgis_tools_tools_idx_fkey FOREIGN KEY (tools_idx) REFERENCES config.webgis_toolbar_tools(tool_idx);


--
-- Name: webgis_tools_webgis_idx_fkey; Type: FK CONSTRAINT; Schema: config; Owner: postgres
--

ALTER TABLE ONLY config.webgis_tools
    ADD CONSTRAINT webgis_tools_webgis_idx_fkey FOREIGN KEY (webgis_idx) REFERENCES config.webgis_indici(webgis_idx);


--
-- Name: SCHEMA config; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA config FROM PUBLIC;
REVOKE ALL ON SCHEMA config FROM postgres;
GRANT ALL ON SCHEMA config TO postgres;
GRANT USAGE ON SCHEMA config TO PUBLIC;
GRANT USAGE ON SCHEMA config TO webgis_r;
GRANT ALL ON SCHEMA config TO radar_rw;


--
-- Name: TABLE animazione_webgis; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.animazione_webgis FROM PUBLIC;
REVOKE ALL ON TABLE config.animazione_webgis FROM postgres;
GRANT ALL ON TABLE config.animazione_webgis TO postgres;
GRANT SELECT ON TABLE config.animazione_webgis TO webgis_r;


--
-- Name: TABLE anomalie_severita; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.anomalie_severita FROM PUBLIC;
REVOKE ALL ON TABLE config.anomalie_severita FROM postgres;
GRANT ALL ON TABLE config.anomalie_severita TO postgres;
GRANT SELECT ON TABLE config.anomalie_severita TO webgis_r;
GRANT ALL ON TABLE config.anomalie_severita TO radar_rw;


--
-- Name: TABLE anomalie_sistemi; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.anomalie_sistemi FROM PUBLIC;
REVOKE ALL ON TABLE config.anomalie_sistemi FROM postgres;
GRANT ALL ON TABLE config.anomalie_sistemi TO postgres;
GRANT SELECT ON TABLE config.anomalie_sistemi TO webgis_r;
GRANT ALL ON TABLE config.anomalie_sistemi TO radar_rw;


--
-- Name: TABLE httpd_access; Type: ACL; Schema: config; Owner: apache_rw
--

REVOKE ALL ON TABLE config.httpd_access FROM PUBLIC;
REVOKE ALL ON TABLE config.httpd_access FROM apache_rw;
GRANT ALL ON TABLE config.httpd_access TO apache_rw;
GRANT SELECT ON TABLE config.httpd_access TO radar_rw;
GRANT ALL ON TABLE config.httpd_access TO webgis_r;


--
-- Name: TABLE httpd_users; Type: ACL; Schema: config; Owner: apache_rw
--

REVOKE ALL ON TABLE config.httpd_users FROM PUBLIC;
REVOKE ALL ON TABLE config.httpd_users FROM apache_rw;
GRANT ALL ON TABLE config.httpd_users TO apache_rw;
GRANT ALL ON TABLE config.httpd_users TO radar_rw;


--
-- Name: TABLE news_message; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.news_message FROM PUBLIC;
REVOKE ALL ON TABLE config.news_message FROM postgres;
GRANT ALL ON TABLE config.news_message TO postgres;
GRANT SELECT ON TABLE config.news_message TO webgis_r;
GRANT ALL ON TABLE config.news_message TO radar_rw;


--
-- Name: TABLE tab_tipo_evento; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.tab_tipo_evento FROM PUBLIC;
REVOKE ALL ON TABLE config.tab_tipo_evento FROM postgres;
GRANT ALL ON TABLE config.tab_tipo_evento TO postgres;
GRANT SELECT ON TABLE config.tab_tipo_evento TO webgis_r;
GRANT ALL ON TABLE config.tab_tipo_evento TO radar_rw;


--
-- Name: TABLE webgis_groups; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_groups FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_groups FROM postgres;
GRANT ALL ON TABLE config.webgis_groups TO postgres;
GRANT SELECT ON TABLE config.webgis_groups TO webgis_r;
GRANT ALL ON TABLE config.webgis_groups TO radar_rw;


--
-- Name: TABLE webgis_indici; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_indici FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_indici FROM postgres;
GRANT ALL ON TABLE config.webgis_indici TO postgres;
GRANT SELECT ON TABLE config.webgis_indici TO webgis_r;


--
-- Name: TABLE webgis_layers; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_layers FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_layers FROM postgres;
GRANT ALL ON TABLE config.webgis_layers TO postgres;
GRANT SELECT ON TABLE config.webgis_layers TO webgis_r;
GRANT ALL ON TABLE config.webgis_layers TO radar_rw;


--
-- Name: TABLE webgis_ol_layers; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_ol_layers FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_ol_layers FROM postgres;
GRANT ALL ON TABLE config.webgis_ol_layers TO postgres;
GRANT SELECT ON TABLE config.webgis_ol_layers TO webgis_r;


--
-- Name: TABLE v_webgis_custom_settings; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.v_webgis_custom_settings FROM PUBLIC;
REVOKE ALL ON TABLE config.v_webgis_custom_settings FROM postgres;
GRANT ALL ON TABLE config.v_webgis_custom_settings TO postgres;
GRANT SELECT ON TABLE config.v_webgis_custom_settings TO webgis_r;


--
-- Name: TABLE webgis_toolbar_tools; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_toolbar_tools FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_toolbar_tools FROM postgres;
GRANT ALL ON TABLE config.webgis_toolbar_tools TO postgres;
GRANT SELECT ON TABLE config.webgis_toolbar_tools TO webgis_r;


--
-- Name: TABLE webgis_tools; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_tools FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_tools FROM postgres;
GRANT ALL ON TABLE config.webgis_tools TO postgres;
GRANT SELECT ON TABLE config.webgis_tools TO webgis_r;


--
-- Name: TABLE v_webgis_general_config; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.v_webgis_general_config FROM PUBLIC;
REVOKE ALL ON TABLE config.v_webgis_general_config FROM postgres;
GRANT ALL ON TABLE config.v_webgis_general_config TO postgres;
GRANT SELECT ON TABLE config.v_webgis_general_config TO webgis_r;


--
-- Name: TABLE v_webgis_ol_layers; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.v_webgis_ol_layers FROM PUBLIC;
REVOKE ALL ON TABLE config.v_webgis_ol_layers FROM postgres;
GRANT ALL ON TABLE config.v_webgis_ol_layers TO postgres;
GRANT ALL ON TABLE config.v_webgis_ol_layers TO radar_rw;
GRANT SELECT ON TABLE config.v_webgis_ol_layers TO webgis_r;


--
-- Name: TABLE webgis_popups; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_popups FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_popups FROM postgres;
GRANT ALL ON TABLE config.webgis_popups TO postgres;
GRANT SELECT ON TABLE config.webgis_popups TO webgis_r;


--
-- Name: TABLE v_webgis_popups; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.v_webgis_popups FROM PUBLIC;
REVOKE ALL ON TABLE config.v_webgis_popups FROM postgres;
GRANT ALL ON TABLE config.v_webgis_popups TO postgres;
GRANT SELECT ON TABLE config.v_webgis_popups TO webgis_r;


--
-- Name: TABLE webgis_base_layers; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_base_layers FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_base_layers FROM postgres;
GRANT ALL ON TABLE config.webgis_base_layers TO postgres;
GRANT SELECT ON TABLE config.webgis_base_layers TO webgis_r;


--
-- Name: TABLE webgis_query_map; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_query_map FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_query_map FROM postgres;
GRANT ALL ON TABLE config.webgis_query_map TO postgres;
GRANT SELECT ON TABLE config.webgis_query_map TO webgis_r;


--
-- Name: TABLE webgis_query_map_extra; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_query_map_extra FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_query_map_extra FROM postgres;
GRANT ALL ON TABLE config.webgis_query_map_extra TO postgres;
GRANT SELECT ON TABLE config.webgis_query_map_extra TO webgis_r;


--
-- Name: TABLE webgis_target; Type: ACL; Schema: config; Owner: postgres
--

REVOKE ALL ON TABLE config.webgis_target FROM PUBLIC;
REVOKE ALL ON TABLE config.webgis_target FROM postgres;
GRANT ALL ON TABLE config.webgis_target TO postgres;
GRANT SELECT ON TABLE config.webgis_target TO webgis_r;
GRANT ALL ON TABLE config.webgis_target TO radar_rw;


--
-- PostgreSQL database dump complete
--

