```sql
-- Dans un gpkg, créer une vue (nommée ici siren_simplifie) qui pourra être vue et chargée dans QGIS:

-- Effacer les références à la vue au cazou
drop view if exists siren_simplifie;
delete from gpkg_geometry_columns where table_name = 'siren_simplifie';
delete from gpkg_contents where identifier = 'siren_simplifie';
delete from gpkg_ogr_contents where table_name = 'siren_simplifie';

-- Créer la vue
create view siren_simplifie as
select s.geom, s.siret, s.nomunitelegale, s.denominationunitelegale, s.denominationusuelleetablissement, s.categorieentreprise,
n3.libelle as libcategoriejuridiqueuniteLegale,
n1.libelle as  libtrancheeffectifsetablissement,
s.activiteprincipaleetablissement, n2.libsousclasse as libactiviteprincipaleetablissement,
strftime('%Y-%m-%d',substr(s.datedebut,1,10)) datedebut

from siren s

left join nomenclatures n1 on n1.champ = 'trancheEffectifsEtablissement' and n1.code = s.trancheeffectifsetablissement
inner join nafrev2 n2 on n2.sousclasse = s.activiteprincipaleetablissement
left join nomenclatures n3 on n3.champ = 'categorieJuridiqueUniteLegale' and n3.code = s.categoriejuridiqueuniteLegale;

-- Déclarer la vue dans gpkg_contents ... Ici on récupère certaines valeurs d'une autre table
INSERT INTO gpkg_contents (table_name, data_type, identifier, last_change, min_x, min_y, max_x, max_y, srs_id) 
	select 'siren_simplifie', data_type, 'siren_simplifie', last_change, min_x, min_y, max_x, max_y, srs_id 
	from gpkg_contents where table_name = 'siren';

-- Déclarer la vue dans gpkg_geometry_columns
INSERT INTO gpkg_geometry_columns (table_name,column_name,geometry_type_name,srs_id,z,m) VALUES ('siren_simplifie', 'geom', 'POINT',2154,0,0);





------------------------------------------------------------------------------------------------


-- Créer une table ou une vue visible dans qgis (Pour une table de polygones nommée isochrones300)
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

-- Triggers visibles dans le dbmanager de QGIS
CREATE TRIGGER "trigger_insert_feature_count_isochrones300" 
    AFTER INSERT ON "isochrones300" 
    BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count + 1 
    WHERE lower(table_name) = lower('isochrones300'); 
END;

CREATE TRIGGER "trigger_delete_feature_count_isochrones300" 
    AFTER DELETE ON "isochrones300" 
    BEGIN UPDATE gpkg_ogr_contents SET feature_count = feature_count - 1 
    WHERE lower(table_name) = lower('isochrones300'); 
END;

```
