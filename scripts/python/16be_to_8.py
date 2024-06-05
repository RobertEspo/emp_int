import os

def convert_textgrid_encoding(file_path):
    # Read TextGrid file in UTF-16BE encoding
    with open(file_path, 'rb') as file:
        text = file.read().decode('utf-16')

    # Write TextGrid file in UTF-8 encoding
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(text)

def convert_directory_encoding(directory):
    # Walk through directory recursively
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.TextGrid'):
                file_path = os.path.join(root, file)
                convert_textgrid_encoding(file_path)

# Replace 'directory_path' with the path to your directory containing TextGrid files
directory_path = 'C:/Users/rober/Desktop/emp_int/textgrids_test'
convert_directory_encoding(directory_path)
