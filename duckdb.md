### Créer un slug
-> Enlever les caractères spéciaux d'une chaîne de caractères, ce qui peut aider pour comparer des chaînes entre elles.
```sql
select lower(strip_accents(regexp_replace( 'L''attaque des "Clones" est arrivée', '["|''| ]+', '-', 'g')))
```
exemple:
```sql
load spatial;
with attr as (
	SELECT dossier, appellation_zone,
	lower(strip_accents(regexp_replace( appellation_zone, '["|''| ]+', '-', 'g'))) slug
	FROM st_read('C:\UwAmp\www\za_enr\downloads\zaenr_2d.gpkg', layer="attributs")
	--where dossier = '15778802'
), polygs as (
	select cast(dossier as varchar) pdossier, description,
	lower(strip_accents(regexp_replace( description, '["|''| ]+', '-', 'g'))) pslug
	from st_read('C:\UwAmp\www\za_enr\downloads\zaenr_2d.gpkg', layer="polygones")
	--where dossier = '15778802'
)
select * 
from attr a
left join polygs p on p.pdossier = a.dossier and p.pslug = a.slug
where a.dossier = '15670422'
```
--------------------------------------------
!!! Attention, les géométries du gpkg doivent être en 2d: 
### Conversion d'un gpkg en 2d:
```batch
"C:\Program Files\QGIS3.28\bin\ogr2ogr" -f "gpkg" zaenr_2d.gpkg zaenr.gpkg -dim 2
```

-------------------------------------------
### csv -> gpkg avec changement de projection
!!! st_point(lat, lon) in duckdb (https://duckdb.org/2023/04/28/spatial.html) ... but st_point(lon, lat) in postgis :/ (https://postgis.net/docs/ST_Point.html)
```sql
copy(
select
	id_fs,
	st_point(latitude, longitude).st_transform('EPSG:4326','EPSG:2154') geometry, 
	* EXCLUDE (id_fs, longitude, latitude)
FROM
	read_csv('C:\donnees\maisons_france_services\2024\data\liste-fs-20240307.csv')) 
	to 'C:\donnees\maisons_france_services\2024\data\fs.gpkg'
	WITH (FORMAT GDAL, DRIVER 'GPKG', LAYER_NAME 'structures', SRS 'EPSG:2154');
```
