DROP MATERIALIZED VIEW IF EXISTS geo.mv_h3_osm;

create materialized view if not exists geo.mv_h3_osm AS
(

SELECT ind.h3_index,
       ind.h3_lvl,
       osm_mv.osm_source_table,
       osm_mv.osm_obj_type,
       osm_mv.osm_obj_tag,
       -- AREA
       SUM(
           CASE
               WHEN osm_source_table = 'multipolygons' THEN
           ST_Area(
               ST_Intersection(
                       ind.h3_index_geog,
                       osm_mv.valid_geom::geography))::real
                END

           ) AS total_shared_area,
       -- PERIMETER
       SUM(
           CASE
               WHEN osm_source_table = 'lines' OR osm_source_table = 'multilinestrings' THEN ST_Length(
               ST_Intersection(
                       ind.h3_index_geog,
                       osm_mv.valid_geom::geography))::real
               WHEN  osm_source_table = 'multipolygons' THEN st_perimeter(
               ST_Intersection(
                       ind.h3_index_geog,
                       osm_mv.valid_geom::geography))::real
               END) AS total_shared_length,
    -- COUNT Intersections
       SUM(
           CASE
               WHEN osm_source_table = 'multipolygons' THEN
               (ST_centroid(osm_mv.valid_geom) && ind.h3_index_geom)::int
               -- NOT Using centroid, any intersection count as 1
               WHEN  osm_source_table = 'lines'
                         OR osm_source_table = 'points'
                         OR osm_source_table = 'multilinestrings' THEN
               ST_Intersects(osm_mv.valid_geom, ind.h3_index_geom)::int
           END
           )                                            AS n_obj_centroids,
       -- SHARED geog
       ST_Union(ST_Intersection(
               ind.h3_index_geom,
               osm_mv.valid_geom))::geography            AS shared_geog
FROM geo.h3_data as ind
         JOIN
     geo.mv_osm_data as osm_mv
     on osm_mv.valid_geom && ind.h3_index_geom
WHERE ST_Intersects(
              ind.h3_index_geom,
              osm_mv.valid_geom
          )
GROUP BY
    ind.h3_index,
    ind.h3_lvl,
    osm_mv.osm_source_table,
    osm_mv.osm_obj_type,
    osm_mv.osm_obj_tag

);