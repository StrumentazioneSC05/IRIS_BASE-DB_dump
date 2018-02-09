--create function and trigger in the IRIS_BASE distribution package

BEGIN;

CREATE OR REPLACE FUNCTION realtime.cardinal2degree(text)
  RETURNS real AS
$BODY$
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
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION realtime.cardinal2degree(text) OWNER TO postgres;


CREATE OR REPLACE FUNCTION realtime.degree2cardinal(real)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE sql VOLATILE
  COST 100;
ALTER FUNCTION realtime.degree2cardinal(real) OWNER TO postgres;


CREATE OR REPLACE FUNCTION realtime.radian2cardinal(real)
  RETURNS text AS
$BODY$
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
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION realtime.radian2cardinal(real) OWNER TO postgres;


CREATE OR REPLACE FUNCTION public.zradar_humidex(
    real,
    real)
  RETURNS real AS
$BODY$
	DECLARE 
		tt    ALIAS for $1;
		rh    ALIAS for $2;

		humidex real;
		es real;
		e real;
		
        BEGIN
        case
            when rh > 0 then
		es = 6.1078 * 10^((7.5 * tt)/(237.3 + tt));
		e = es * rh / 100.;
		humidex = tt + 0.55556 * (e - 10.);
            else 
		humidex = null;
        end case;

                RETURN( humidex );


		 	
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.zradar_humidex(real, real) OWNER TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_humidex(real, real) TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_humidex(real, real) TO public;
GRANT EXECUTE ON FUNCTION public.zradar_humidex(real, real) TO postgres;
COMMENT ON FUNCTION public.zradar_humidex(real, real) IS 'Humidex from TT and RH';


CREATE OR REPLACE FUNCTION public.zradar_mslp(
    real,
    real,
    real,
    real)
  RETURNS real AS
$BODY$
	DECLARE 
		ps    ALIAS for $1;
		ts    ALIAS for $2;
		rh    ALIAS for $3;
		H0    ALIAS for $4;

                K  real;
                a  real;
                Ch real;

		es real;
		
        BEGIN
        
                K = 0.0148275;
                a = 0.0065;
                Ch = 0.12;
                
                es = 0.01 * rh * 6.112* exp (17.62 * ts/(243.12 + ts));

                RETURN(ps * 10^( (K * H0) / (273.15 + ts + a * H0 / 2 + es * Ch)) );


		 	
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.zradar_mslp(real, real, real, real) OWNER TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_mslp(real, real, real, real) TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_mslp(real, real, real, real) TO public;
GRANT EXECUTE ON FUNCTION public.zradar_mslp(real, real, real, real) TO postgres;
COMMENT ON FUNCTION public.zradar_mslp(real, real, real, real) IS 'Reduction to mean sea level pressure';


CREATE OR REPLACE FUNCTION public.zradar_td(
    real,
    real)
  RETURNS real AS
$BODY$
	DECLARE 
		tt    ALIAS for $1;
		rh    ALIAS for $2;

		td real;
		
        BEGIN
        case
            when rh > 0 then
		td = 243.04*(log(rh/100)+((17.625*tt)/(243.04+tt)))/(17.625-log(rh/100)-((17.625*tt)/(243.04+tt)));
            else 
		td = null;
        end case;

                RETURN( td );


		 	
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.zradar_td(real, real) OWNER TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_td(real, real) TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_td(real, real) TO public;
GRANT EXECUTE ON FUNCTION public.zradar_td(real, real) TO postgres;
COMMENT ON FUNCTION public.zradar_td(real, real) IS 'Dew point temperature from TT and RH';


CREATE OR REPLACE FUNCTION public.zradar_windchill(
    real,
    real)
  RETURNS real AS
$BODY$
	DECLARE 
		ts    ALIAS for $1;
		vv    ALIAS for $2;
		
        BEGIN

		RETURN(13.12 + 0.6215 * ts - 11.37 * (3.6 * vv) ^ 0.16 + 0.3965 * ts * (3.6 * vv) ^ 0.16 );
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.zradar_windchill(real, real) OWNER TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_windchill(real, real) TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_windchill(real, real) TO public;
GRANT EXECUTE ON FUNCTION public.zradar_windchill(real, real) TO postgres;
COMMENT ON FUNCTION public.zradar_windchill(real, real) IS 'Wind chill formula';


CREATE OR REPLACE FUNCTION public.zradar_at(
    real,
    real,
    real)
  RETURNS real AS
$BODY$
	DECLARE 
		ts    ALIAS for $1;
		vv    ALIAS for $2;
		rh    ALIAS for $3;

		es real;
		
        BEGIN
        
                es = 0.01 * rh * 6.112* exp (17.62 * ts/(243.12 + ts));

                RETURN( ts + 0.33*es - 0.70*vv - 4.00 );


		 	
        END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION public.zradar_at(real, real, real) OWNER TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_at(real, real, real) TO radar;
GRANT EXECUTE ON FUNCTION public.zradar_at(real, real, real) TO public;
GRANT EXECUTE ON FUNCTION public.zradar_at(real, real, real) TO postgres;
COMMENT ON FUNCTION public.zradar_at(real, real, real) IS 'Apperent temperature from Australian Bureau of Met.';


CREATE OR REPLACE FUNCTION config.update_legend_variable()
  RETURNS trigger AS
$BODY$
BEGIN
UPDATE config.webgis_ol_layers SET default_legend_variable = 'layer' || NEW.layer_idx WHERE NEW.layer_idx=layer_idx;
RETURN NULL;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION config.update_legend_variable() OWNER TO postgres;

CREATE TRIGGER trigger_update_legend_variable
  AFTER INSERT
  ON config.webgis_ol_layers
  FOR EACH ROW
  EXECUTE PROCEDURE config.update_legend_variable();


COMMIT;
