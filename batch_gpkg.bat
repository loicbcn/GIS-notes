rem -- A partir des données nationales au format shp "epci" et "communes" d'admin express
rem -- Créer un gpkg contenant les epci contenant des communes du 31, et toutes les communes de ces epci.
del data.gpkg
set datapath=D:\commandes\epci_2_5d\admin_expess_2019-08-19\

rem créer data.gpkg en mettant dans un layer "communes" les communes qui appartiennent à des EPCI Contenant des communes du 31
"C:\Program Files\QGIS 3.8\bin\ogr2ogr" -f "GPKG" data.gpkg %datapath%COMMUNE.shp -dialect "SQLITE" -sql "select * from COMMUNE where CODE_EPCI IN(select distinct CODE_EPCI from COMMUNE where INSEE_DEP = '31')" -lco "GEOMETRY_NAME=geom" -nlt MULTIPOLYGON -lco "SPATIAL_INDEX=YES" -nln communes

rem Créer une table epci_data qui contient les codes et populations des epcis
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "DROP TABLE epci_data"
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "CREATE TABLE epci_data as select CODE_EPCI, cast(sum(POPULATION) as integer) POPULATION from communes group by CODE_EPCI"

rem Ajouter tous les epcis dans un layer nommé "epci_all" de data.gpkg
"C:\Program Files\QGIS 3.8\bin\ogr2ogr" -f "GPKG" data.gpkg %datapath%EPCI.shp -append -dialect "SQLITE" -lco "GEOMETRY_NAME=geom" -nlt MULTIPOLYGON -lco "SPATIAL_INDEX=YES" -nln epci_all

rem Créer la table "epci" qui ne contient que les epci concernés par la zone d'étude, puis supprimer la table "epci_all"
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "DROP TABLE epci"
"C:\Program Files\QGIS 3.8\bin\ogr2ogr" data.gpkg data.gpkg -append -dialect "sqlite" -sql "SELECT ea.*, ed.POPULATION FROM epci_all ea INNER JOIN epci_data ed ON ed.CODE_EPCI = ea.CODE_EPCI" -nln epci
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "DROP TABLE epci_all"
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "DROP TABLE epci_data"

rem Compacter
"C:\Program Files\QGIS 3.8\bin\ogrinfo" data.gpkg -sql "VACUUM"
