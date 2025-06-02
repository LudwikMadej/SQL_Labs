create procedure reservation
	@NameOfHotel nvarchar(100),
	@NumberOfGuests int,
	@StartDate date,
	@EndDate date
as
begin
	
	declare @roomCode int

	set @roomCode = (
		select top 1
			roomCode
		from HotelRooms
		where 
			IsReserved = 0  and
			NumberOfGuests = @NumberOfGuests
	)

	set @roomCode = ISNULL(@roomCode, -1)

	if @roomCode < 0
		begin
			
			declare @cityName varchar(100)
			select @cityName =
				City
				from Hotels
				where HotelName = @NameOfHotel

			select @roomCode = 
				r.RoomCode
				from HotelRooms r
				join Hotels h on h.HotelCode = r.HotelCode
				where r.IsReserved = 0 and h.City = @cityName

			set @roomCode = isnull(@roomCode, -1)

			if @roomCode = -1
				print 'Niestety nie ma pokoi spe³niajacych warunki'

			else
				begin
					
					declare @HotelCode int
					select @HotelCode = 
						HotelCode
						from HotelRooms
						where RoomCode = @roomCode
					
					declare @price money
					set @price = DATEDIFF(DAY, @StartDate, @EndDate) * (select CostOfNight from HotelRooms where RoomCode = @roomCode)
					
					print @HotelCode
					print cast(@roomCode as varchar)
					print cast(@price as varchar)

				end
		end

	else
		begin

			insert into Reservations
				(RoomCode, DateFrom, DateTo, TotalCost)
			values 
				(@roomCode, @StartDate, @EndDate, 
				DATEDIFF(DAY, @StartDate, @EndDate) * (select CostOfNight from HotelRooms where RoomCode = @roomCode))

			update HotelRooms
			set IsReserved = 1
			where RoomCode = @roomCode

			select *
			from Reservations
			where RoomCode = @roomCode and DateFrom = @StartDate and @EndDate = DateTo

			select *
			from HotelRooms
			where RoomCode = @roomCode
		end



end



exec reservation 'hotel1', 1, '2025-01-01', '2025-01-10'