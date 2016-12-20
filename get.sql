select
d.id_day, d.day_date, d.day_type, d.day_name, d.day_shortdesc, d.day_longdesc, d.day_status, d.audio, f.ID as fav, dw.ID as downloaded
from days d
left join favoritos f on f.id_day = d.id_day and f.id_device = 'd8e9abfd9c31d7f4a36f90cdbf9fc570'
left join downloads dw on dw.id_day = dw.id_day and dw.id_device = 'd8e9abfd9c31d7f4a36f90cdbf9fc570'
where d.day_status = 1
order by d.day_date asc