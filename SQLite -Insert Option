import sqlite3

db_path = r"C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Database Files\\Database for Tutorial 0301.db"
conn = sqlite3.connect(db_path) # Connect to the database
c = conn.cursor() # Create a cursor object to interact with the database

# Insert option 1
mike1 = ['83456', 'Mike P1', 'Grad']
new_row_insert1 = "INSERT INTO Student VALUES ('%s', '%s', '%s');" 
c.execute(new_row_insert1 % (mike1[0], mike1[1], mike1[2]))

# Insert option 2
mike2 = ['83457', 'Mike P2', 'Grad']
new_row_insert2 = "INSERT INTO Student VALUES ('%s', '%s', '%s');" 
c.execute(new_row_insert2 % tuple(mike2))

# Insert option 3
mike3 = ['83458', 'Mike P3', 'Grad']
new_row_insert3 = "INSERT INTO Student VALUES (?, ?, ?);"
c.execute(new_row_insert3, mike3)

conn.commit() # Commit all the changes
conn.close() # Close the connection
