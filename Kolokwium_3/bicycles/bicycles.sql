create database bicycles

create table bicycle_station (
	station_id integer identity(1, 1) primary key,
	city nvarchar(100),
	adress nvarchar(1000),
	racks_amounts int,
	avaiable_racks int
)

create table users_user(
	user_id int identity(1, 1) primary key,
	email nvarchar(255),
	first_name nvarchar(200),
	last_name nvarchar(200),
	is_active bit,
	age datetime,
	current_balance money
)

create table bicycle (
	rover_id int identity(1, 1) primary key,
	rover_type nvarchar(100) default 'Adventure Road Bike',
	origin nvarchar(80) default 'NextBike'
)

create table bicicle_rent (
	rent_id integer primary key,
	user_id integer,
	bicycle_id integer,
	rented_at datetime,
	returned_at datetime,
	rent_station int,
	return_station int,
	total_cost money,
	is_finished bit default 0,
	is_returned_manually bit default 0

	constraint "FK_user_id_renting" foreign key (
		user_id
	) references users_user (
		user_id
	),

	constraint "FK_bicycle_id_renting" foreign key (
		bicycle_id
	) references bicycle (
		rover_id
	),

	constraint "FK_station_id_renting" foreign key (
		rent_station
	) references bicycle_station (
		station_id
	),

	constraint "FK_station_id_returning" foreign key (
		return_station
	) references bicycle_station (
		station_id
	)
)