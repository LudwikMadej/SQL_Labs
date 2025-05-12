from db_connection import cnx_mssql

class kolokwium_przykladowe:
    """
    Brak parametryzacji zapytań SQL (podatność na SQL injection).
    Nie ma żadnej walidacji danych wejściowych (input() zwraca str, a CategoryID powinno być int).
    Brak obsługi wyjątków (try/except), co może prowadzić do awarii.
    Nie ma sprawdzenia, czy dana kategoria istnieje przed aktualizacją/usunięciem.
    Wstawienie kategorii bez pola Description, mimo że może być wymagane lub istotne.
    Nie sprawdzono, czy kategoria ma przypisane produkty przed usunięciem (ryzyko naruszenia integralności).
    Nie zamknięto kursora i połączenia (cursor.close() i conn.close()).

    cursor.execute("SELECT COUNT(*) FROM [Order Details] WHERE ProductID = %s", (delete_id,))
    """
    def __init__(self):
        self.cursor = cnx_mssql.cursor()

    def task_01(self):
        self.cursor.execute("""
            create table "Faktury" (
                "FakturaID" "bigint" identity (1, 1) not null,
                "kwota_netto" "money" not null,
                "kwota_brutto" "money" not null,
                "nr_konta" nvarchar (26) not null
            )
        """)

    def task_02(self):
        self.cursor.execute("""
            delete 
            from Faktury
        """)

        for kwota in [100, 200, 300]:
            query = "insert into " + "Faktury (kwota_netto, kwota_brutto, nr_konta) " + f"values ({kwota}, {kwota*1.23}, 'brak numeru es')"
            print(query)
            self.cursor.execute(query)

        self.cursor.execute("""
            update Faktury
            set kwota_brutto = 2 * kwota_brutto
            
            insert into Faktury (kwota_netto, kwota_brutto, nr_konta)
            values  
        """ + f" ({1000/1.23}, {1000}, 'brak numeru es')")

        self.cursor.execute("select FakturaID from Faktury")
        ilosc_recordow = len(self.cursor.fetchall())
        print(ilosc_recordow)

        import numpy as np

        random_indices = np.random.choice(list(range(ilosc_recordow)), replace=False, size=3)

        counter = 0
        to_change = []
        self.cursor.execute("select FakturaID from Faktury")
        for record in self.cursor.fetchall():
            if counter in random_indices:
                to_change.append(str(record[0]))
                print(record)

            counter += 1

        print(to_change)
        self.cursor.execute("""
            update Faktury
            set kwota_brutto = 2137
            where FakturaID in (
        """ + ",".join(to_change) + ")")

