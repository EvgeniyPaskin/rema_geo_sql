create table if not exists geo.h3_osm AS
(

--- amenity
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'amenity' AS osm_obj_type,
	osm.amenity AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

    --  ~ 10x execution time
-- 	ST_Union(ST_Intersection(
-- 			ind.h3_index_geom,
-- 			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.amenity IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.amenity

UNION

--- aeroway
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'aeroway' AS osm_obj_type,
	osm.aeroway AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.aeroway IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.aeroway

UNION

--- building
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'building' AS osm_obj_type,
	osm.building AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.building IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.building


UNION

--- landuse
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'landuse' AS osm_obj_type,
	osm.landuse AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.landuse IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.landuse

UNION

--- landuse
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'landuse' AS osm_obj_type,
	osm.landuse AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.landuse IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.landuse

UNION

--- leisure
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'leisure' AS osm_obj_type,
	osm.leisure AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.leisure IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.leisure

UNION
--- man_made
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'man_made' AS osm_obj_type,
	osm.man_made AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.man_made IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.man_made

UNION
--- military
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'military' AS osm_obj_type,
	osm.military AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.military IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.military

UNION
--- natural
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'natural' AS osm_obj_type,
	osm.natural AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.natural IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.natural

UNION
--- office
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'office' AS osm_obj_type,
	osm.office AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.office IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.office


UNION
--- place
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'place' AS osm_obj_type,
	osm.place AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.place IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.place


UNION
--- shop
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'shop' AS osm_obj_type,
	osm.shop AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.shop IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.shop

UNION
--- sport
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'sport' AS osm_obj_type,
	osm.sport AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.sport IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.sport


UNION
--- tourism
SELECT
	ind.h3_index,
	ind.h3_lvl,
	'tourism' AS osm_obj_type,
	osm.tourism AS osm_obj_details,
	SUM(ST_Area(
		ST_Intersection(
			ind.h3_index_geog,
			ST_MakeValid(osm.wkb_geometry)::geography))::real) AS total_shared_area,
	SUM(
		(ST_centroid(ST_MakeValid(osm.wkb_geometry))::geography && ind.h3_index_geog)::int
	)
	AS n_obj_centroids,

	ST_Union(ST_Intersection(
			ind.h3_index_geom,
			ST_MakeValid(osm.wkb_geometry))) as shared_geog
FROM
		geo.h3_data as ind JOIN
		public.multipolygons as osm
		on osm.wkb_geometry && ind.h3_index_geom
WHERE
	osm.tourism IS NOT NULL
	AND
	ST_Intersects(
		ind.h3_index_geom,
		ST_MakeValid(osm.wkb_geometry)
	)
GROUP BY
	ind.h3_index,
	ind.h3_lvl,
	osm.tourism

)