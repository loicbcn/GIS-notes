```sql
-- Créer une table ou une vue visible dans qgis
CREATE TABLE "isochrones300" ( 
    `fid` INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT, 
    `geom` POLYGON, `s3ic` TEXT ( 255 ), 
    `siret` TEXT ( 255 ), 
    `wkt` TEXT );

INSERT INTO `gpkg_contents`(`table_name`,`data_type`,`identifier`,`min_x`,`min_y`,`max_x`,`max_y`,`srs_id`)
    VALUES (
    select  'isochrones300' as tablename, 
            'features' as datatype, 
            'isochrones300' as identifier, 
            (ST_MinX(geom) || ',' || ST_MinY(geom) || ',' || ST_MaxX(geom) || ',' || ST_MaxY(geom)) as ext,
            2154 as srid 
    from (select extent(geom) geom from isochrones300)
);


INSERT INTO `gpkg_geometry_columns`(`table_name`,`column_name`,`geometry_type_name`,`srs_id`,`z`,`m`)
VALUES ('isochrones300','geom','POLYGON',2154,0,0);

```
