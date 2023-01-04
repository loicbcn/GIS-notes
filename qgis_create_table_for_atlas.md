### Plusieurs entités par page dans un atlas QGIS.

Un atlas QGIS crée une page par entité de la couche de couverture choisie. Si la table a 100 enregistrements, l'atlas générera 100 pages.

Pour avoir plusieurs entités par page, l'idée est de créer une table attributaire qui contiendra une ligne par page et une colonne pour chaque entité souhaitée sur la page.

ex: La couche **"prefs_r76"** utilisée dans la requête ci-dessous contient 43 entités. L'atlas comportera 4 cartes par page.
Il faut donc créer une table contenant 11 lignes (11*4 > 43) et 4 colonnes (et une 5ème si on veut un id).

La couche **"prefs_r76"** est issue de la couche chefs-lieux d'admin express de l'IGN. C'est une couche de points.

Les données à passer à l'atlas, qui seront dans les 4 colonnes seront stockées en json, et contiendront le nom de la commune et l'emprise (xmin, ymin, xmax, ymax) à renseigner dans les propriétés de l'objet carte dans le composer.

Voici la requête générant la table à utiliser dans l'atlas.

```sql
with datas as (
	select p.*, 
	cast(ceil(cast(ROW_NUMBER() OVER () as float) / 4) as int) page,
	(ROW_NUMBER() OVER ())%4 +1 idcarte,
		json_object('nom', nom_chf, 'emprise', 
			json_array(	
				xmin(st_buffer(geometry, 1000)), 
				ymin(st_buffer(geometry, 1000)), 
				xmax(st_buffer(geometry, 1000)), 
				ymax(st_buffer(geometry, 1000)))) as jsondata
	from prefs_r76 p
	order by page, idcarte
)		
select page, 
	max(case when idcarte = 1 then jsondata end) elem1,
	max(case when idcarte = 2 then jsondata end) elem2,
	max(case when idcarte = 3 then jsondata end) elem3,
	max(case when idcarte = 4 then jsondata end) elem4
from datas
group by page
```
Les champs des 4 colonnes contiennent les données au format json, sous cette forme:

```json
{"nom":"Mairie de Brive-la-Gaillarde","emprise":[583824.3,6451231.3,585824.3,6453231.3]}
```
Dans le composer QGIS, pour l'emprise, les différents champs sont à renseigner: from_json("elem0")['emprise'][0] 
Pour utiliser le nom dans une étiquette: [%from_json( "elem0" )['nom']%]

Pour masquer les vignettes sans données (dernière page), dans rendu - opacité: case when "elem1" is null then 0 else 100 end


