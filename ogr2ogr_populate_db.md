```bat
CHCP 65001

set servi=A7
set savpath=C:\Users\me\Documents\SUP\%servi%\130010747_%servi%_031_20170727\Donnees_geographiques
set pgconn="PG:dbname='SUP' host='' port='5432' user='myuser' password='mypwd'"

del "%savpath%\%servi%_ACTE_SUP.*"
del "%savpath%\%servi%_GESTIONNAIRE_SUP.*"
del "%savpath%\%servi%_SERVITUDE_ACTE_SUP.*"
del "%savpath%\%servi%_SERVITUDE.*"
del "%savpath%\%servi%_ASSIETTE_SUP_S.*"
del "%savpath%\%servi%_GENERATEUR_SUP_S.*"


ogr2ogr "%savpath%\%servi%_ACTE_SUP.dbf" %pgconn% -sql "SELECT idacte ""idActe"", nomacte ""nomActe"", reference, typeacte ""typeActe"", fichier, decision, to_char(datedecis, 'YYYYMMDD') ""dateDecis"", to_char(datepub, 'YYYYMMDD') ""datePub"", CASE aplan WHEN FALSE THEN 'F' WHEN TRUE THEN 'T' ELSE NULL END ""aPlan"" FROM sups.acte_sup WHERE idacte LIKE 'A7%%'" -lco ENCODING=UTF-8
ogr2ogr "%savpath%\%servi%_GESTIONNAIRE_SUP.dbf" %pgconn% -sql "SELECT idgest ""idGest"", nomgest ""nomGest"", nomcorres ""nomCorres"", numtel ""numTel"", courriel, adresse FROM sups.gestionnaire_sup WHERE idgest = '130010747'" -lco ENCODING=UTF-8
ogr2ogr "%savpath%\%servi%_SERVITUDE_ACTE_SUP.dbf" %pgconn% -sql "SELECT idsup ""idSup"", idacte ""idActe"" FROM sups.servitude_acte_sup WHERE idsup like 'A7%%'" -lco ENCODING=UTF-8
ogr2ogr "%savpath%\%servi%_SERVITUDE.dbf" %pgconn% -sql "SELECT idsup ""idSup"", idgest ""idGest"", nomsup ""nomSup"", nomsuplitt ""nomSupLitt"", categorie, idintgest ""idIntGest"", descriptio, to_char(datemaj, 'YYYYMMDD') ""dateMaj"", echnum ""echnum"", CASE validegest WHEN FALSE THEN 'F' WHEN TRUE THEN 'T' ELSE NULL END ""valideGest"", obsvalidat ""obsValidat"", modeprod ""modeProd"", quiprod ""quiProd"", docsource ""docSource"" FROM sups.servitude_sup WHERE idsup like 'A7%%';" -lco ENCODING=UTF-8

del "%savpath%\*.cpg"

ogr2ogr "%savpath%\%servi%_ASSIETTE_SUP_S.shp" %pgconn% -sql "SELECT geom_s, idass ""idAss"", idgen ""idGen"", nomass ""nomAss"", typeass ""typeAss"", modegeoass ""modeGeoAss"", paramcalc ""paramCalc"", srcgeoass ""srcGeoAss"", to_char(datesrcass, 'YYYYMMDD') ""dateSrcAss"" FROM sups.assiette_sup where idass like 'A7%%'" -lco ENCODING=UTF-8
ogr2ogr "%savpath%\%servi%_GENERATEUR_SUP_S.shp" %pgconn% -sql "SELECT geom_s, idgen ""idGen"", idsup ""idSup"", nomgen ""nomGen"", typegen ""typeGen"", modegenere ""modeGenere"", srcgeogen ""srcGeoGen"", to_char(datesrcgen, 'YYYYMMDD') ""dateSrcGen"", refbdext ""refBDExt"", idbdext ""idBDExt"" FROM sups.generateur_sup where idgen like 'A7%%'" -lco ENCODING=UTF-8

```
