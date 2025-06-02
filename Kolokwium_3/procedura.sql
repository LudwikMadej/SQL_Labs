create procedure procedura 
	@user_id int,
	@rent_id int,
	@station_id int
as 
begin
	declare @duration_in_minutes int

	select @duration_in_minutes =
		isnull(abs(DATEDIFF(MINUTE, returned_at, rented_at)), -1)
		from bicicle_rent
		where user_id = @user_id and rent_id = @rent_id

	declare @cost money
	set @cost = case
		when @duration_in_minutes < 20 then 0
		when @duration_in_minutes < 60 then 1
		when @duration_in_minutes < 120 then 3
		else CEILING(@duration_in_minutes / 60) * 7
	end

	declare @is_place bit
	set @is_place = case 
		when exists (
		select *
		from bicycle_station
		where 
			station_id = @station_id and
			avaiable_racks > 0
		) then 1
		else 0
	end
	
	if @is_place = 1
		begin

			update bicicle_rent
			set 
				returned_at = GETDATE(),
				rented_at = @station_id,
				total_cost = @cost,
				is_finished = 1
			where rent_id = @rent_id

			update users_user
			set current_balance = current_balance - @cost
			where user_id = @user_id

			update bicycle_station
			set avaiable_racks = avaiable_racks - 1
			where station_id = @station_id

		end

	else
		begin
			
			update bicicle_rent
			set 
				returned_at = GETDATE(),
				rented_at = @station_id,
				total_cost = @cost,
				is_returned_manually = 1,
				is_finished = 1
			where rent_id = @rent_id

			update bicycle_station
			set avaiable_racks = avaiable_racks - 1
			where station_id = @station_id

		end

end
