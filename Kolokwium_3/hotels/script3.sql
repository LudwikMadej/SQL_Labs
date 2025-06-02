create nonclustered index "HotelCode_Hotels" 
on Hotels (HotelCode)

create nonclustered index "HotelCode_Rooms" 
on HotelRooms (HotelCode)

create unique index "Hotels_UniqueHotelName"
on Hotels (HotelName)

create nonclustered index "HotelRooms_NumberOfGuests"
on HotelRooms (NumberOfGuests)


create clustered index "Reservations"
on Reservations (ReservationCode)


create nonclustered index "Reservations_Dates"
on Reservations (DateFrom, DateTo)