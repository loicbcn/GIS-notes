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
