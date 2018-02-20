BEGIN;

SET search_path = config, pg_catalog;

ALTER SEQUENCE webgis_indici_idx_seq RESTART WITH 1;
ALTER SEQUENCE news_message_gid_seq RESTART WITH 1;
ALTER SEQUENCE webgis_ol_layers_layer_idx_seq RESTART WITH 1;


INSERT INTO webgis_indici (webgis_name, webgis_description, default_raster, zoom_center, lon_center, lat_center, query_map_idx, baselayers, collapsed_grid, defaultgrid_layeridx, attivo)
VALUES ('iris_base', 'IRIS minimale per distribuzione', 3, 8, 8.2, 45.2, 1, '{4,14,5,8,2,3,12,11,10,9}', true, NULL, 1);

INSERT INTO news_message (messaggio, icona_iniziale, data_validita, data_scadenza, webgis_idx)
VALUES ('Benvenuto in IRIS! Il sistema usa dei cookie tecnici per migliorarne l''utilizzo', 'common/icons/toolbar_icons/smile.png', '2015-12-10', NULL, NULL);
INSERT INTO news_message (messaggio, icona_iniziale, data_validita, data_scadenza, webgis_idx)
VALUES ('Tieni sempre sotto controllo le novita'' del WebGIS!!', 'common/icons/toolbar_icons/news.png', '2015-12-01', NULL, NULL);

INSERT INTO webgis_ol_layers (openlayer_name, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title)
VALUES ('rete_meteoidro', 'iris_base.dati_di_base.rete_meteoidrografica', 'mapserver', 'stazioni meteo RUPAR area piemontese e limitrofe', 'stile secondo tipo stazione campo meteo_tab', false, 'store_meteoidro', 'columns_meteoidro', false, NULL, false, 'POINT', 23032, 'Anagrafica stazioni rete a terra (double-click to zoom on interested station)');

INSERT INTO webgis_ol_layers (openlayer_name, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title)
VALUES ('temperatura_tiny','iris_base.realtime.v_last_terma','tinyows','Dati termometrici - ultimo valore','stile secondo il campo ultimovalore, con etichetta nel cerchio',true,NULL,NULL,false,NULL,true,'POINT',23032,NULL);

INSERT INTO webgis_ol_layers (openlayer_name, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title)
VALUES ('datistazioni_tiny','iris_base.realtime.v_last_vento','tinyows','Dati anemometrici - ultimo valore','stile con oggetto grafico esterno secondo valore e direzione vento',true,NULL,NULL,false,NULL,true,'POINT',23032,NULL);

INSERT INTO webgis_ol_layers (openlayer_name, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title)
VALUES ('nivo_tiny','iris_base.realtime.v_last_nivo','tinyows','Dati neve fresca dalle 8','stile secondo il campo ultimovalore, con etichetta nel cerchio',true,NULL,NULL,false,NULL,true,'POINT',23032,NULL);

INSERT INTO webgis_ol_layers (openlayer_name, db_table_view_name, service, layer_description, theme_description, ol_cluster_enabled, store_definition, column_definition, filter_defined, filter_description, mobile_friendly, geom_type, geom_srid, grid_title)
VALUES ('rete_pluv_expo','iris_base.realtime.v_last_pluv','tinyows','Dati pluviometrici - cumulata ultime 3 ore','stile secondo il campo ultimovalore, con etichetta nel cerchio',true,NULL,NULL,false,NULL,true,'POINT',4326,NULL);


INSERT INTO webgis_tools VALUES (1, 1);
INSERT INTO webgis_tools VALUES (1, 3);
INSERT INTO webgis_tools VALUES (1, 4);
INSERT INTO webgis_tools VALUES (1, 7);
INSERT INTO webgis_tools VALUES (1, 8);
INSERT INTO webgis_tools VALUES (1, 11);
INSERT INTO webgis_tools VALUES (1, 12);
INSERT INTO webgis_tools VALUES (1, 13);
INSERT INTO webgis_tools VALUES (1, 14);
INSERT INTO webgis_tools VALUES (1, 15);
INSERT INTO webgis_tools VALUES (1, 16);
INSERT INTO webgis_tools VALUES (1, 17);

INSERT INTO webgis_layers (webgis_idx, legend_name, legend_group_idx, select_highlight, visible, order_in_webgis, ol_layer_idx)
VALUES (1, 'Rete meteoidro', 6, 3, 0, 1, 1);

INSERT INTO webgis_popups VALUES (1, 1, 'grafici_rete', '', '', '', 'meteoidro', 'TERMA', '', '', 'codice_istat_comune', 'codice_istat_comune', 'progr_punto_com', 'tipo_staz', 'grafici_stazione', '{2}');

COMMIT;