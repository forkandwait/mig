SET CLIENT_ENCODING TO UTF8;
SET STANDARD_CONFORMING_STRINGS TO ON;
BEGIN;
CREATE TABLE "puma100" (gid serial PRIMARY KEY,
"statefp00" varchar(2),
"puma1ce00" varchar(5),
"puma1id00" varchar(7),
"namelsad00" varchar(11),
"mtfcc00" varchar(5),
"funcstat00" varchar(1),
"aland00" float8,
"awater00" float8,
"intptlat00" varchar(11),
"intptlon00" varchar(12));
SELECT AddGeometryColumn('','puma100','the_geom','4269','MULTIPOLYGON',2);
CREATE INDEX "puma100_the_geom_gist" ON "puma100" using gist ("the_geom" gist_geometry_ops);
COMMIT;
