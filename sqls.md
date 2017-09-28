```sql
------ Postgis tester validité géométrique
SELECT st_isvalidreason(geom) as raison, st_isValidDetail(geom) as geometry
FROM rpg."2014_11_epci"  WHERE not st_isvalid(geom);

------ Postgis Correction de géométries invalides:
update rpg."2009_11_epci" 
SET geom = st_multi(st_simplify(ST_Multi(ST_CollectionExtract(ST_ForceCollection(ST_MakeValid(geom)),3)),0)) 
WHERE ST_GeometryType(geom) = 'ST_MultiPolygon';

------ QGIS VL: Normaliser les noms des champs avec cast du type de champs (sqlite pour virtual layer)
------ types possibles:(text, real, integer)
------ https://sqlite.org/datatype3.html
select cast(ID_ILOT as text) id_ilot, geometry from rpg2009_31_epci
select cast(substr(Num_ilot, 5) as text) id_ilot, geometry from rpg2010_31_epci


------ QGIS VL: Récupérer les pertes
select * from union_2009_2014 where geometry is not null and (
(id_ilot is not null and id_ilot_2 is null and id_ilot_3 is null and id_ilot_4 is null and id_ilot_5 is null and id_ilot_6 is null)
OR (id_ilot_2 is not null and id_ilot_3 is null and id_ilot_4 is null and id_ilot_5 is null and id_ilot_6 is null)
OR (id_ilot_3 is not null and id_ilot_4 is null and id_ilot_5 is null and id_ilot_6 is null)
OR (id_ilot_4 is not null and id_ilot_5 is null and id_ilot_6 is null)
OR (id_ilot_5 is not null and id_ilot_6 is null));
```
