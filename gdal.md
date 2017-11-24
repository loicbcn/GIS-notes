Assemblage de tuiles ecw/jp2 en jp2 (JP2OpenJPEG)
Passer par un .vrt puis faire un translate car le driver JP2OpenJPEG ne permet pas de faire l'assemblage directement.

gdalbuildvrt D:/donnees/scan50/Output.vrt "D:\donnees\scan50\SCANEXPRESS50_1-0_JP2-E100_LAMB93_D031_2017-06-01\SCANEXPRESS50\1_DONNEES_LIVRAISON_2017-07-00119\SCEXP50_STD_JP2-E100_LAMB93_D31\*.jp2"

gdal_translate -of JP2OpenJPEG -co "QUALITY=100" -co "REVERSIBLE=YES"  D:/donnees/scan50/Output.vrt D:/donnees/scan50/Output.jp2
