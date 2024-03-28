### Récupérer les attributs d'une table, dans le composer par exemple:

with_variable('tbdep',
	array_foreach(
		string_to_array(
		  aggregate(
			layer:='Départements_Fr_7c8132b8_7408_45f8_8bb3_e988ca935248',
			aggregate:='concatenate',
			expression:="INSEE_DEP",
			concatenator:='@@',
			order_by:="INSEE_DEP"), '@@'
		), attributes(
			get_feature('Départements_Fr_7c8132b8_7408_45f8_8bb3_e988ca935248', 'INSEE_DEP', @element))
	),
	array_foreach(@tbdep, map_get(@element,'INSEE_DEP'))
)

-------------------

### Expression régulière
A partir de champs composés d'horaires (1 champ par jour de la semaine, sauf le dimanche), calculer des durées d'ouverture des locaux
Le champs peuvent contenir des horaires sous ces formes:
```09:00 - 12:00 / 14:00 - 17:00```
```09:00 - 12:00```
```14:00 - 17:00```
```NULL```
avec parfois des erreurs
```00:00 - 00:00 / 09:00 - 12:00```

L'expression suivante retourne la somme des intervales de temps en minutes.
L'expression régulière envoi chaque horaire dans un groupe, et ```regexp_matches``` convertit chaque groupe en un élément de tableau.

``` 
array_sum(
	with_variable(
		'fields',
		array("h_lundi","h_mardi","h_mercredi","h_jeudi","h_vendredi","h_samedi"),
			array_foreach(@fields, 
				case when @element is not null then 
					with_variable( 
						'arr',
						regexp_matches(@element, 
						'(\\d{2}:\\d{2}) - (\\d{2}:\\d{2})(?:./.(\\d{2}:\\d{2}) - (\\d{2}:\\d{2}))?'
						),
						(to_int(substr(@arr[1],1,2))*60 + to_int(substr(@arr[1],4,2))) - 
						(to_int(substr(@arr[0],1,2))*60 + to_int(substr(@arr[0],4,2))) + 
						case when array_length(@arr) = 4 and @arr[0] != @arr[2] 
							then ((to_int(substr(@arr[3],1,2))*60 + to_int(substr(@arr[3],4,2)))-
								(to_int(substr(@arr[2],1,2))*60 + to_int(substr(@arr[2],4,2))))
							else 0 end
					)
				else 0 end
			)
	)
)
```
