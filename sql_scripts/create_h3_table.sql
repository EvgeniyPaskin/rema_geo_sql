DROP table if exists geo.h3_data;

CREATE table if not exists geo.h3_data AS
    (
         SELECT -- H3 LVL 1
         1 as h3_lvl,  h3_lvl_1 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_1)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_1)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_1)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel group by h3_lvl_1

         UNION -- H3 LVL 2
         SELECT 2 as h3_lvl,  h3_lvl_2 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_2)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_2)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_2)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_2

         UNION -- H3 LVL 3
         SELECT 3 as h3_lvl,  h3_lvl_3 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_3)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_3)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_3)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_3

         UNION -- H3 LVL 4
         SELECT 4 as h3_lvl,  h3_lvl_4 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_4)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_4)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_4)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_4

         UNION -- H3 LVL 5
         SELECT 5 as h3_lvl,  h3_lvl_5 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_5)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_5)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_5)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_5

         UNION -- H3 LVL 6
         SELECT 6 as h3_lvl,  h3_lvl_6 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_6)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_6)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_6)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_6

         UNION -- H3 LVL 7
         SELECT 7 as h3_lvl,  h3_lvl_7 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_7)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_7)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_7)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_7

         UNION -- H3 LVL 8
         SELECT 8 as h3_lvl,  h3_lvl_8 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_8)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_8)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_8)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_8

         UNION -- H3 LVL 9
         SELECT 9 as h3_lvl,  h3_lvl_9 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_9)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_9)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_9)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_9

         UNION -- H3 LVL 10
         SELECT 10 as h3_lvl,  h3_lvl_10 as h3_index, count(cad_num) as n_cad_nums,
         h3_cell_to_boundary(h3_lvl_10)::geometry::geography as h3_index_geog,
         h3_cell_to_boundary(h3_lvl_10)::geometry::geography::geometry as h3_index_geom,
         st_subdivide(h3_cell_to_boundary(h3_lvl_10)::geometry::geography::geometry) as h3_index_geom_subdiv
         from geo.mv_geo_parcel  group by h3_lvl_10
    );

DROP INDEX IF EXISTS idx_spatial_h3_index_geog;
DROP INDEX IF EXISTS idx_spatial_h3_index_geom;
DROP INDEX IF EXISTS idx_spatial_h3_index_geom_subdiv;

DROP INDEX IF EXISTS idx_h3_data_h3_index;
DROP INDEX IF EXISTS idx_h3_data_h3_lvl;


CREATE INDEX idx_spatial_h3_index_geog ON geo.h3_data USING gist (h3_index_geog);
CREATE INDEX idx_spatial_h3_index_geom ON geo.h3_data USING gist (h3_index_geom);
CREATE INDEX idx_spatial_h3_index_geom_subdiv ON geo.h3_data USING gist (h3_index_geom_subdiv);

CREATE INDEX idx_h3_data_h3_index ON geo.h3_data (h3_index);
CREATE INDEX idx_h3_data_h3_lvl ON geo.h3_data (h3_lvl);