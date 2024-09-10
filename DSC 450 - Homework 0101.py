# Part 1
## A
def compute_average(file_path):

    total_sum = 0
    total_count = 0

    with open(file_path, 'r') as file:
        for line in file:
            numbers = line.strip().split(',')
            for number in numbers:
                total_sum += int(number)
                total_count += 1

    return total_sum / total_count if total_count > 0 else 0

average = compute_average("C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 1\\Data File\\numbers_with_comma.txt")
print('\nThe average in this text file is', average)

## B
def transformed_file(input_file_path, output_file_path):

    numbers_list = []

    with open(input_file_path, 'r') as input_file:
        for line in input_file:
            numbers = line.strip().split(',')
            numbers_list.extend(int(number.strip()) for number in numbers)

    with open(output_file_path, 'w') as output_file:
        for number in numbers_list:
            output_file.write(str(number) + '\n')

transformed_file("C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 1\\Data File\\numbers_with_comma.txt",
                 "C:\\Users\\wodnj\\OneDrive\\바탕 화면\\Databases for Analytics\\DSC 450 - Week 1\\Data File\\numbers_with_comma_transformed.txt")

## C
def generate_insert(table_name, value_list):

    def string_or_integer(value):

        try:
            return int(value)
        except ValueError:
            return f"'{value}'"
    
    formatted_value_list = [str(string_or_integer(entry)) for entry in value_list]
    
    comma_separated_values = ', '.join(formatted_value_list)

    return f"\nINSERT INTO {table_name} VALUES ({comma_separated_values});"

print(generate_insert('Students', ['37', 'Jaewon', 'A+']))
print(generate_insert('Phones', ['1', '989-621-7759']))