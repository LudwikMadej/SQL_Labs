insert into users_user
	(email, first_name, last_name, is_active)
values
	('1@', 'name1', 'name11', 1),
	('2@', 'name2', 'name22', 1),
	('3@', 'name3', 'name33', 1)

insert into bicycle_station
	(city, adress, racks_amounts, avaiable_racks)
values 
	('city2', 'adress2', 2000, 2000),
	('city1', 'adress1', 1000, 1000),
	('city3', 'adress3', 3000, 3000)

insert into bicycle
	(rover_type)
values 
	('type1'),
	('type2'),
	('type3')

insert into bicicle_rent
	(rent_id, user_id, bicycle_id, rent_station, return_station)
values 
	(1,1,2,3,1),
	(2, 2,1,1,1),
	(3, 2,3,2,2)