from db_connection import cnx_mssql

class Scenarios:
    def __init__(self):
        self.cursor = cnx_mssql.cursor()

    def perform_scenario_01(self):
        self.cursor.execute("""
            select *
            from Employees
        """)

        print("Employees' information")
        for rec in self.cursor.fetchall():
            print(rec)

        self.cursor.execute("""
                    select *
                    from Employees
                    where exists (
                        select *
                        from Orders o
                        where ShipCountry = 'France' and o.EmployeeID = EmployeeID
                    )
                """)

        print("Employees with French orders")

        for rec in self.cursor.fetchall():
            print(rec)


    def perform_scenario_02(self):
        self.cursor.execute("""
            begin transaction
            insert into Employees (FirstName, LastName)
            values ('Michał', 'Ziembowski'), ('Zbingnniew', 'Lonc')
            
            
            commit transaction
        """)

        self.cursor.commit()

        self.cursor.execute("""
            update Employees
            set LastName = 'Dembinska'
            where LastName = 'Ziembowski'
        """)
        self.cursor.commit()
