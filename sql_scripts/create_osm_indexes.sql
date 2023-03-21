CREATE INDEX idx_osm_multipolygons ON public.multipolygons USING gist (wkb_geometry);
CREATE INDEX idx_osm_multilinestrings ON public.multilinestrings USING gist (wkb_geometry);
CREATE INDEX idx_osm_lines ON public.lines USING gist (wkb_geometry);
CREATE INDEX idx_osm_points ON public.points USING gist (wkb_geometry);

