select top 0
	*
into ArchivedOrders
from Orders


 -- Ustawanie kluczów g³ownych i obcych dla tabeli ArchivedOrders
select top 0
	*
into ArchivedOrdersDetails
from [Order Details]

alter table ArchivedOrders
add constraint "PK_ArchivedOrders" primary key (
	OrderID
	)

alter table ArchivedOrders 
add constraint "FK_EmployeeID" foreign key (
	EmployeeID
) references Employees (
	EmployeeID
)

alter table ArchivedOrders 
add constraint "FK_ShipperID" foreign key (
	ShipVia
) references Shippers (
	ShipperID	
)

alter table ArchivedOrders 
add constraint "FK_CustomerID" foreign key (
	CustomerID
) references Customers (
	CustomerID	
)

alter table ArchivedOrders
add  ArchivedDate datetime


 -- Ustawianie ograniczeñ i kluczów g³ownych dla tabeli OrderDetailsArchived
alter table ArchivedOrdersDetails
add constraint "FK_OrderID" foreign key (
	OrderID
) references ArchivedOrders (
	OrderID
)

alter table ArchivedOrdersDetails
add constraint "FK_ProductID" foreign key (
	ProductID
) references Products (
	ProductID
)

alter table ArchivedOrdersDetails
add constraint "non_negative_quantity" check (quantity >= 0)

alter table ArchivedOrdersDetails
add constraint "non_negative_price" check (unitprice >= 0)


-- archiwizacja zamówieñ
begin transaction
	begin try
		declare @current_date datetime
		set @current_date = getdate()

		set identity_insert ArchivedOrders on

		insert into ArchivedOrders (OrderID, CustomerID, EmployeeID, OrderDate, RequiredDate, ShippedDate, ShipVia, Freight, ShipName, ShipAddress, ShipCity, ShipRegion, ShipPostalCode,ShipCountry, ArchivedDate)
		select *, @current_date
		from Orders
		where year(OrderDate) <= 1997

		set identity_insert ArchivedOrders off

		-- uzupe³nianie szczegó³ów zamówieñ
		
		insert into ArchivedOrdersDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
		select *
		from [Order Details] od
		where od.OrderID in (select OrderID from ArchivedOrders)


		delete 
		from [Order Details]
		where OrderID in (select OrderID from ArchivedOrders)

		delete 
		from Orders
		where year(OrderDate) <= 1997

		commit transaction
	end try

	begin catch
		rollback transaction
		
		throw
	end catch
