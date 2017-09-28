```python
# Lance des unions successives.
import processing;
path = "C:/Users/ldonot/Documents/sig/PAC_PLUi_Lauragais/datas/rpg/81/decoupe/champ_harmonise/";
processing.runalg("qgis:union", path + "rpg2009_81_epci_fok.shp", path + "rpg2010_81_epci_fok.shp", path + "union_2009_2014_1.shp");
processing.runalg("qgis:union", path + "union_2009_2014_1.shp", path + "rpg2011_81_epci_fok.shp", path + "union_2009_2014_2.shp");
processing.runalg("qgis:union", path + "union_2009_2014_2.shp", path + "rpg2012_81_epci_fok.shp", path + "union_2009_2014_3.shp");
processing.runalg("qgis:union", path + "union_2009_2014_3.shp", path + "rpg2013_81_epci_fok.shp", path + "union_2009_2014_4.shp");
processing.runalg("qgis:union", path + "union_2009_2014_4.shp", path + "rpg2014_81_epci_fok.shp", path + "union_2009_2014.shp");

```
