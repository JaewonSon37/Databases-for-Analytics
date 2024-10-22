# Dictionary

# Define a dictionary
extensions = {111: 'Alex', 222: 'Jane'} 

# Access the value
print("")
print(extensions[111])
print(extensions[222])
print("")

# Add a new key-value pair
extensions[333] = 'Mike'
print(extensions[333])
extensions['Default'] = 'Operator'
print(extensions['Default'])
print("")

# Update the value
extensions[333] = 'Mike2'
print(extensions[333])
print("")

# Check if key 555 exists in the dictionary
if 555 in extensions:
    extensions[555]

# Add a new key-value pair
extensions[555] = 'dummy' 

# Remove the key-value pair
extensions.pop(555) 

# Get all the keys
for key in extensions.keys():
    print(key)
print("")

# Get all the values
for value in extensions.values():
    print(value)
print("")

# Get all key-value pairs
for (key, value) in extensions.items():
    print(key, '->', value)
print("")


# Lambda

# Define a function
def times_two(x):
    return x * 2

def square(x):
    return x * x

def apply_function(my_function, value):
    return my_function(value)

# Apply function
print(apply_function(times_two, 10))
print(apply_function(square, 10))
print("")

# Define a inline lambda function
lambda x: x * x
print(apply_function(lambda x: x * x, 10))
print("")

# Assign the lambda function to a variable
square2 = lambda x: x * x
print(apply_function(square2, 10))
print("")
