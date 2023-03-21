CREATE STATISTICS osm_data_stats (dependencies) on
    osm_source_table, osm_obj_type, osm_obj_name from geo.osm_data;

CREATE STATISTICS h3_data_stats (dependencies) on
    h3_lvl, h3_index from geo.h3_data;

ANALYZE geo.osm_data;
ANALYZE geo.h3_data;

