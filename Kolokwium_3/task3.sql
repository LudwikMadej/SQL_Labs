create nonclustered index "users_id_users" 
on users_user (user_id)

create nonclustered index "users_id_rent" 
on bicicle_rent (user_id)

create nonclustered index "rend_dates"
on bicicle_rent (rented_at, returned_at)


--create clustered index "bicycle_station_index"
--on bicycle_station (station_id)

create index "names"
on users_user (last_name, first_name)
