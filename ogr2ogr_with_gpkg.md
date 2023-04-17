```bat
rem écrire dans un gpkg déjà existant
ogr2ogr -f GPKG mobilite.gpkg centoids_epci.shp -append -update -t_srs EPSG:2154
```
```bat
rem Reprojeter les fichiers d'un répertoire et écrire le résultat dans le répertoire 2154 
rem source: https://georezo.net/forum/viewtopic.php?id=101118
FOR %F in (*.gpkg) DO "C:\Program Files\QGIS3.16\bin\ogr2ogr" -t_srs EPSG:2154  "2154/%F" "%F"
```

```bat
rem extraitre une couche et ses styles d'un gpkg vers un autre gpkg
rem ex: extraction de la couche département de la BDcarto et de son style
ogr2ogr -f "gpkg" -dialect "sqlite" -sql "select * from departement where code_insee='31'" departement.gpkg bdcarto_2022_R76.gpkg -nln "departement"
ogr2ogr -f "gpkg" -dialect "sqlite" -sql "select * from layer_styles where f_table_name='departement'" departement.gpkg bdcarto_2022_R76.gpkg -nln "layer_styles" -append -update
```
