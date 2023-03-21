INSERT INTO geo.h3_osm
SELECT ind.h3_index,
       ind.h3_lvl,
       osm.osm_source_table,
       osm.osm_obj_type,
       osm.osm_obj_tag,
       -- AREA
       SUM(
           CASE
               WHEN osm_source_table = 'multipolygons' THEN
           ST_Area(
               ST_Intersection(
                       ind.h3_index_geom_subdiv,
                       osm.valid_geom_subdiv)::geography)::real
                END

           ) AS total_shared_area,
       -- PERIMETER
       SUM(
           CASE
               WHEN osm_source_table = 'lines' OR osm_source_table = 'multilinestrings' THEN ST_Length(
               ST_Intersection(
                       ind.h3_index_geom_subdiv,
                       osm.valid_geom_subdiv)::geography)::real
               WHEN  osm_source_table = 'multipolygons' THEN st_perimeter(
               ST_Intersection(
                       ind.h3_index_geom_subdiv,
                       osm.valid_geom_subdiv)::geography)::real
               END) AS total_shared_length,
    -- COUNT Intersections
       SUM(
           CASE
               WHEN osm_source_table = 'multipolygons' THEN
               (ST_centroid(osm.valid_geom) && ind.h3_index_geom)::int
               -- NOT Using centroid, any intersection count as 1
               WHEN  osm_source_table = 'lines'
                         OR osm_source_table = 'points'
                         OR osm_source_table = 'multilinestrings' THEN
               ST_Intersects(osm.valid_geom_subdiv, ind.h3_index_geom_subdiv)::int
           END
           )                                            AS n_obj_centroids
    -- SHARED geog
--        ST_Union(ST_Intersection(
--                ind.h3_index_geom,
--                osm.valid_geom))::geography            AS shared_geog

FROM geo.h3_data as ind
         JOIN
     geo.osm_data as osm
     on osm.valid_geom_subdiv && ind.h3_index_geom_subdiv
WHERE
    ind.h3_lvl IN (4,3,2,1) AND
    ST_Intersects(
              ind.h3_index_geom_subdiv,
              osm.valid_geom_subdiv
          )
GROUP BY
    ind.h3_index,
    ind.h3_lvl,
    osm.osm_source_table,
    osm.osm_obj_type,
    osm.osm_obj_tag

;