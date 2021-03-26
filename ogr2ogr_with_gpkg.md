```bat
rem écrire dans un gpkg déjà existant
ogr2ogr -f GPKG mobilite.gpkg centoids_epci.shp -append -update -t_srs EPSG:2154
```
```bat
rem Reprojeter les fichiers d'un répertoire et écrire le résultat dans le répertoire 2154 
rem source: https://georezo.net/forum/viewtopic.php?id=101118
FOR %F in (*.gpkg) DO "C:\Program Files\QGIS3.16\bin\ogr2ogr" -t_srs EPSG:2154  "2154/%F" "%F"
```
