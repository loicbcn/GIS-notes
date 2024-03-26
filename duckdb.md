### Créer un slug
```sql
select lower(strip_accents(regexp_replace( 'L''attaque des "Clones" est arrivée', '["|''| ]+', '-', 'g')))
```
exemple:
```sql
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
!!! Attention, les géométries du gpkg doivent être en 2d: 

### Conversion d'un gpkg en 2d:
```batch
"C:\Program Files\QGIS3.28\bin\ogr2ogr" -f "gpkg" zaenr_2d.gpkg zaenr.gpkg -dim 2
```
