# Part 1-d

def validate_insert(inserted_statement):

    if inserted_statement.startswith('INSERT INTO') and inserted_statement.endswith(';'):

        try:
            table_name_start = inserted_statement.index('INTO') + 5
            table_name_end = inserted_statement.index('VALUES')
            table_name = inserted_statement[table_name_start:table_name_end].strip()
            values = inserted_statement[inserted_statement.index('('):inserted_statement.index(');') + 1]
            print(f"\nInserting {values} into {table_name} table")

        except:
            print('\nInvalid insert')
    
    else:
        print('\nInvalid insert')

validate_insert("INSERT INTO Students VALUES (1, 'Jane', 'B+');")
validate_insert("INSERT INTO Students VALUES (1, 'Jane', 'B+')")
validate_insert("INSERT Students VALUES (1, 'Jane', 'B+');")
validate_insert("INSERT INTO Phones VALUES (42, '312-667-1213');")
