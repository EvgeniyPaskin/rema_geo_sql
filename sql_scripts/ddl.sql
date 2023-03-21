CREATE SCHEMA if not exists geo;

drop materialized view if exists geo.mv_geo_parcel;

CREATE materialized view if not exists geo.mv_geo_parcel AS
    (
        SELECT
            geo_raw.cad_num,
            facts.cad_num_parent,
            facts.object_type,
            COUNT(geo_raw.cad_num) > 1 as is_multishape,
            SUM(ST_Area(ST_transform(geo_raw.shape ,4326)::geography)::real) as agg_shape_area,
            SUM(ST_Perimeter(ST_transform(geo_raw.shape ,4326)::geography)::real) as agg_shape_perimeter,

            -- Calculating centroid using aggregation for multi-shape objects
            ST_transform(st_centroid(
                st_union(geo_raw.shape)),4326)::geography  AS centroid_shape,

            -- Getting Lan Long for calculated centroid
            ST_YMax(
                ST_transform(st_centroid(
                st_union(geo_raw.shape)),4326)
            ) AS centroid_lat,
            ST_XMax(
                ST_transform(st_centroid(
                st_union(geo_raw.shape)),4326)
            ) AS centroid_lon,

            --  Calculating SCI: Shape Complexity Index
            ROUND((1 - ST_Area(st_union(geo_raw.shape)) /  ST_Area(ST_convexhull(st_union(geo_raw.shape))))::numeric, 8)::real AS sci_area,
            ( (ST_perimeter(ST_convexhull(st_union(geo_raw.shape)))^2) / ST_Area(st_union(geo_raw.shape))/16 )::real AS sci_perimeter, -- Divide by 16 as value for square with equal sides = 16

            -- Distance to Moscow center
            ST_Distance(ST_transform(st_union(geo_raw.shape),4326)::geography, ST_Point(37.618423, 55.751244, 4326)::geography)::INT AS distance_to_msk, --meters

            -- Direction degrees from Moscow center in clockwise: N=0, E=90, S=180, W=270
            degrees(ST_Azimuth(
                    ST_Point(37.618423, 55.751244, 4326),
                    ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)
                    ))::real as direction_to_msk,

            -- Calculating H3 Index in different levels
            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 1
                ) as h3_lvl_1,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 2
                ) as h3_lvl_2,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 3
                ) as h3_lvl_3,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 4
                ) as h3_lvl_4,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 5
                ) as h3_lvl_5,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 6
                ) as h3_lvl_6,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 7
                ) as h3_lvl_7,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 8
                ) as h3_lvl_8,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 9
                ) as h3_lvl_9,

            h3_lat_lng_to_cell(
                ST_transform(st_centroid(st_union(geo_raw.shape)), 4326)::point
                , 10
                ) as h3_lvl_10

        FROM
            rrapi_facts.mv_full_data AS facts JOIN
            public.parcel AS geo_raw ON facts.object_cn = geo_raw.cad_num
        GROUP BY
            geo_raw.cad_num,
            facts.cad_num_parent,
            facts.object_type
    );