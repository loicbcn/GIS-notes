```sql
------ QGIS Virtual layer, écrit dans un seul champ l'emprise en wgs 84 d'une couche.
select 'w:' || st_maxx(st_transform(geometry,4326)) || 
		   ',s:' || st_miny(st_transform(geometry,4326)) ||
		   ',e:' || st_minx(st_transform(geometry,4326)) ||
		   ',n:' || st_maxy(st_transform(geometry,4326))
 as bounds    
 from dep_31
 
 
------ POSTGIS, Idem
 select 'w:' || st_xmax(st_transform(geom,4326)) || 
		   ',s:' || st_ymin(st_transform(geom,4326)) ||
		   ',e:' || st_xmin(st_transform(geom,4326)) ||
		   ',n:' || st_ymax(st_transform(geom,4326))
 as bounds    
 from dep_31
 
 
 ------ QGIS Virtual Idem sans reprojection
 select 'w:' || st_maxx(geometry) || 
		   ',s:' || st_miny(geometry) ||
		   ',e:' || st_minx(geometry) ||
		   ',n:' || st_maxy(geometry)
 as bounds    
 from dep_31
 
 
 ------ POSTGIS Idem sans reprojection
select 'w:' || st_xmax(geom) || 
		   ',s:' || st_ymin(geom) ||
		   ',e:' || st_xmin(geom) ||
		   ',n:' || st_ymax(geom)
 as bounds    
 from dep_31
 
 
 ------ Virtual layer get écrit dans 4 champs l'emprise en wgs 84 d'une couche.
select st_maxx(st_transform(geometry,4326)) w, 
		   st_miny(st_transform(geometry,4326)) s,
		   st_minx(st_transform(geometry,4326)) e,
		   st_maxy(st_transform(geometry,4326)) n
 from dep_31
 
 
 ------ POSTGIS Idem
select st_xmax(st_transform(geom,4326)) w, 
		   st_ymin(st_transform(geom,4326)) s,
		   st_xmin(st_transform(geom,4326)) e,
		   st_ymax(st_transform(geom,4326)) n
 from dep_31


------ QGIS Virtual layer Créer une couche de l'emprise
select st_envelope(geom) from matable; -- Puis charger comme nouvelle couche


------ Postgis layer Créer une couche de l'emprise
create table bounds(
	geom geometry(POLYGON,2154),
	id serial PRIMARY KEY
);

INSERT INTO bounds
select st_envelope(geom)
 from matable;
 ``` 
