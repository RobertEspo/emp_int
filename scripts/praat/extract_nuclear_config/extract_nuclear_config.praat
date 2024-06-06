# Praat script to extract data from TextGrid files and write to a text file

form Arguments
	sentence textgrid_directory C:\Users\rober\Desktop\emp_int\textgrids_ToBI
	positive tier_pas 6
endform

appendInfoLine: "Debug: INITIATE"

# Create list object for all files in textgrid dir
Create Strings as file list... file_list 'textgrid_directory$'/*.TextGrid
object_list = selected("Strings")

# Get number of files
numberOfFiles = Get number of strings

# Iterate through each file in the directory
for ifile to numberOfFiles
	# Get the filename
	select object_list
   	filename$ = Get string... ifile
	fullPath$ = textgrid_directory$+"\"+filename$
	appendInfoLine: "Debug: fullPath$ = ", fullPath$

	# Load the TextGrid file
	Read from file... 'fullPath$'
	textgrid_obj = selected("TextGrid")

	# Get number of intervals in tier_pas
	numberOfPoints = Get number of points... tier_pas
	appendInfoLine: "Debug: numberOfIntervals = ", numberOfPoints

	# Get the last two point labels from the tier_pas
	boundary$ = Get label of point: tier_pas, numberOfPoints
	nuclear_pitch$ = Get label of point: tier_pas, numberOfPoints-1

	# Write data to the output file
	appendFileLine: "C:\Users\rober\Desktop\emp_int\data\nuclear_configs.txt", filename$ + " " + nuclear_pitch$ + " " + boundary$
endfor

# Close the output file
select object_list
Remove
