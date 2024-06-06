import os
import pandas as pd
import parselmouth

# Directory containing the TextGrid files
textgrid_directory = r'C:\Users\rober\Desktop\emp_int\textgrids_ToBI'

# Initialize an empty list to store data
data = []

# Iterate through each file in the directory
for filename in os.listdir(textgrid_directory):
    if filename.endswith(".TextGrid"):
        # Load the TextGrid file
        textgrid_file = os.path.join(textgrid_directory, filename)
        tg = parselmouth.read(textgrid_file)

        # Iterate over tiers to find Standardization tier
        standardization_tier = None
        for tier in tg.tiers:
            if tier.name == 'Standardization':
                standardization_tier = tier
                break

        # Get the last two point labels
        if standardization_tier:
            points = standardization_tier.points
            if len(points) >= 2:
                second_to_last_label = points[-2].mark
                last_label = points[-1].mark

                # Add data to the list
                data.append({
                    'Filename': filename.replace('.TextGrid', ''),
                    'Second-to-last label': second_to_last_label,
                    'Last label': last_label
                })

# Convert the list of dictionaries to a DataFrame
df = pd.DataFrame(data)

# Save the DataFrame to an Excel file
excel_filename = 'output.xlsx'
df.to_excel(excel_filename, index=False)

print(f"Data saved to {excel_filename}")
