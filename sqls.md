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


------ QGIS VL: Liste des communes d'un epci
select group_concat(c.INSEE_COMM) comms from comm_31 c
inner join N_EPCI_ZSUP_031 epci ON st_within(st_centroid(c.geometry), epci.geometry)
group by c.INSEE_DEPT;


------ Postgis Dissolve geometrie dans une nouvelle table. (ici dans un schéma nommé rpg)
------ Fusion des départements
create table rpg.france as
    select id, st_union(geom)::geometry(multipolygon, 2154) geom
    from (select 1 id, geom from rpg.dep) all_dep
    group by id;

ALTER TABLE rpg.france ADD PRIMARY KEY (id);
CREATE INDEX france_gix ON rpg.france USING GIST (geom);

------ Postgis exploser polygones multiples en entités simples
select (st_dump(geom)).geom as the_geom from rpg.france


------ Postgis, dissolve 2 couches
SELECT st_union(u.geom) geom, MAX(u.t1),  MAX(u.t2) sd
from (
select l1.geom, titre t1, NULL t2	from layer_1 l1
union
select l2.geom, NULL t1, titre t2 from  layer_2 l2
) u

```
