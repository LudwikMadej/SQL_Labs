import configparser
import pyodbc

# parse config
cnf = configparser.ConfigParser()
cnf.read('cnf.ini')

print(cnf.sections())

server = cnf['mssqlDB']['server']
database = cnf['mssqlDB']['db']
driver = cnf['mssqlDB']['driver']

conn_str = (
    f'DRIVER={{{driver}}};'
    f'SERVER={server};'
    f'DATABASE={database};'
    f'Trusted_Connection=yes;'
)

conn = pyodbc.connect(conn_str)
cursor = conn.cursor()