create database hotele

create table Hotels (
	HotelCode int primary key,
	HotelName varchar(10) not null,
	City varchar(100) not null,
	Description text
)

create table HotelRooms (
	RoomCode int primary key,
	HotelCode int not null,
	NumberOfGuests int not null,
	CostOfNight money not null


	constraint "FK_HotelCode_HotelRooms" foreign key (
		HotelCode
	) references Hotels (
		HotelCode
	)
)

create table Reservations (
	ReservationCode int identity(1, 1) primary key,
	RoomCode int not null,
	DateFrom date not null,
	DateTo date not null,
	TotalCost money,


	constraint "FK_Reservations_RoomCode" foreign key (
		RoomCode	
	) references HotelRooms (
		RoomCode
	)
)

alter table HotelRooms
add IsReserved bit
default 0

alter table Hotels
alter column HotelName nvarchar(100)


-- wstawianie wartosci
insert into Hotels
	(HotelCode, HotelName, City)
values 
	(1, 'hotel1', 'miasto1'),
	(2, 'hotel2', 'miasto2')

insert into HotelRooms
	(RoomCode, NumberOfGuests,HotelCode, CostOfNight)
values 
	(1, 1, 1, 2.50),
	(2, 10, 2, 5.50),
	(3, 15, 1, 4.50),
	(4, 2, 2, 3.50)

insert into Reservations
	(RoomCode, DateFrom, DateTo)
values 
	(1, '2020-01-01', '2020-01-10'),
	(2, '2021-01-01', '2021-01-10'),
	(3, '2022-01-01', '2022-01-10'),
	(4, '2023-01-01', '2023-01-10')