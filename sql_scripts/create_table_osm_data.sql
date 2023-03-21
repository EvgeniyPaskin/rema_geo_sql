DROP TABLE IF EXISTS geo.osm_data;

CREATE TABLE IF NOT EXISTS geo.osm_data AS
(
SELECT
	osm_id,
	'lines' as                                                osm_source_table,
	-- ORDER MATTERS!
	CASE
		WHEN highway IS NOT NULL THEN 'highway'
        WHEN waterway IS NOT NULL THEN 'waterway'
        WHEN aerialway IS NOT NULL THEN 'aerialway'
		WHEN barrier IS NOT NULL THEN 'barrier'
		WHEN man_made IS NOT NULL THEN 'man_made'
   	END                                                       osm_obj_type,
    -- ORDER MATTERS! Should match CASE order
    coalesce(highway, waterway, aerialway, barrier, man_made) osm_obj_tag,
	name as                                                   osm_obj_name,
	other_tags,
	ST_MakeValid(wkb_geometry) as valid_geom,
	ST_MakeValid(wkb_geometry)::geography as valid_geog,
	st_subdivide(ST_MakeValid(wkb_geometry)) as valid_geom_subdiv
FROM public.lines
WHERE
	highway IS NOT NULL
    OR waterway IS NOT NULL
	OR aerialway IS NOT NULL
	OR barrier IS NOT NULL
	OR man_made IS NOT NULL

UNION

SELECT
	osm_id,
	'multilinestrings' as                                                osm_source_table,
	'type' AS                                                   osm_obj_type,
    type as osm_obj_tag,
	name as                                                   osm_obj_name,
	other_tags,
	ST_MakeValid(wkb_geometry) as valid_geom,
	ST_MakeValid(wkb_geometry)::geography as valid_geog,
	st_subdivide(ST_MakeValid(wkb_geometry)) as valid_geom_subdiv
FROM public.multilinestrings
WHERE
	type IS NOT NULL

UNION

SELECT
	osm_way_id AS osm_id, --<- osm_id has mostly nulls. Using way_id for substitution
	'multipolygons' as                                                osm_source_table,
	CASE
	    -- amenity column moved first. Other columns in OSM order
        WHEN amenity IS NOT NULL THEN 'amenity'
        WHEN aeroway IS NOT NULL THEN 'aeroway'
		WHEN barrier IS NOT NULL THEN 'barrier'
		WHEN boundary IS NOT NULL THEN 'boundary'
	    WHEN building IS NOT NULL THEN 'building'
        WHEN craft IS NOT NULL THEN 'craft'
        WHEN geological IS NOT NULL THEN 'geological'
		WHEN historic IS NOT NULL THEN 'historic'
		WHEN land_area IS NOT NULL THEN 'land_area'
		WHEN landuse IS NOT NULL THEN 'landuse'
        WHEN leisure IS NOT NULL THEN 'leisure'
        WHEN man_made IS NOT NULL THEN 'man_made'
		WHEN military IS NOT NULL THEN 'military'
		WHEN "natural" IS NOT NULL THEN 'natural'
	    WHEN office IS NOT NULL THEN 'office'
        WHEN place IS NOT NULL THEN 'place'
        WHEN shop IS NOT NULL THEN 'shop'
		WHEN sport IS NOT NULL THEN 'sport'
		WHEN tourism IS NOT NULL THEN 'tourism'
   	END                                                       osm_obj_type,
    -- ORDER MATTERS! Should match CASE order
    coalesce(
        amenity, -- <- Amenity first as in CASE statement above
        aeroway,
        barrier,
        boundary,
        building,
        craft,
        geological,
        historic,
        land_area,
        landuse,
        leisure,
        man_made,
        military,
        "natural",
        office,
        place,
        shop,
        sport,
        tourism
    ) osm_obj_tag,
	name as                                                   osm_obj_name,
	other_tags,
	ST_MakeValid(wkb_geometry) as valid_geom,
	ST_MakeValid(wkb_geometry)::geography as valid_geog,
	st_subdivide(ST_MakeValid(wkb_geometry)) as valid_geom_subdiv
FROM public.multipolygons
WHERE
	amenity IS NOT NULL OR
    aeroway IS NOT NULL OR
    barrier IS NOT NULL OR
    boundary IS NOT NULL OR
    building IS NOT NULL OR
    craft IS NOT NULL OR
    geological IS NOT NULL OR
    historic IS NOT NULL OR
    land_area IS NOT NULL OR
    landuse IS NOT NULL OR
    leisure IS NOT NULL OR
    man_made IS NOT NULL OR
    military IS NOT NULL OR
    "natural" IS NOT NULL OR
    office IS NOT NULL OR
    place IS NOT NULL OR
    shop IS NOT NULL OR
    sport IS NOT NULL OR
    tourism IS NOT NULL


UNION

SELECT
	osm_id,
	'points' as                                                osm_source_table,
	CASE
		WHEN place IS NOT NULL THEN 'place'
        WHEN barrier IS NOT NULL THEN 'barrier'
        WHEN highway IS NOT NULL THEN 'highway'
		WHEN man_made IS NOT NULL THEN 'man_made'
   	END                                                       osm_obj_type,
    coalesce(place, barrier, highway, man_made) osm_obj_tag,
	name as                                                   osm_obj_name,
	other_tags,
	ST_MakeValid(wkb_geometry) as valid_geom,
	ST_MakeValid(wkb_geometry)::geography as valid_geog,
	st_subdivide(ST_MakeValid(wkb_geometry)) as valid_geom_subdiv
FROM public.points
WHERE
	place IS NOT NULL
    OR barrier IS NOT NULL
	OR highway IS NOT NULL
	OR man_made IS NOT NULL
);

DROP INDEX IF EXISTS idx_spatial_osm_data_geom;
DROP INDEX IF EXISTS idx_spatial_osm_data_geog;
DROP INDEX IF EXISTS idx_spatial_osm_data_geom_subdiv;
DROP INDEX IF EXISTS idx_spatial_osm_data_geom;
DROP INDEX IF EXISTS idx_spatial_osm_data_geom;
DROP INDEX IF EXISTS idx_spatial_osm_data_geom;

CREATE INDEX idx_spatial_osm_data_geom ON geo.osm_data USING gist (valid_geom);
CREATE INDEX idx_spatial_osm_data_geog ON geo.osm_data USING gist (valid_geog);
CREATE INDEX idx_spatial_osm_data_geom_subdiv ON geo.osm_data USING gist (valid_geom_subdiv);

CREATE INDEX idx_osm_data_source_table ON geo.osm_data (osm_source_table);
CREATE INDEX idx_osm_data_obj_type ON geo.osm_data (osm_obj_type);
CREATE INDEX idx_osm_data_obj_tag ON geo.osm_data (osm_obj_tag);
