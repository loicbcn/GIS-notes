```bat
rem écrire dans un gpkg déjà existant
ogr2ogr -f GPKG mobilite.gpkg centoids_epci.shp -append -update -t_srs EPSG:2154
```
