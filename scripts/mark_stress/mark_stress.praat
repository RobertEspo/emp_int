form Arguments
	sentence textgrid_directory C:\Users\rober\Desktop\emp_int\textgrids_test
	positive tier_words 1
	positive tier_syllables 3
endform

appendInfoLine: "Debug 0: INITIATE"

# This is for stress_pattern()
no_pa$ = readFile$: "no_pa.txt"
# appendInfoLine: "Debug 0.1: no_pa$ = ", no_pa$
vowels$ = "aeiouAEOIU"
# appendInfoLine: "Debug 0.2: vowels$ = ", vowels$
non_reg_stress$ = readFile$: "non_reg_stress.txt"
# appendInfoLine: "Debug 0.3: non_reg_stress$ = ", non_reg_stress$

# This is for mark_stress()
no_hiatus$ = readFile$: "no_hiatus.txt"

###

Create Strings as file list... file_list 'textgrid_directory$'/*.TextGrid
object_list = selected("Strings")
# appendInfoLine: "Debug 1: object_list of textgrid_directory created."

numberOfFiles = Get number of strings
# appendInfoLine: "Debug 2: NumberOfFiles = ", numberOfFiles

###

for ifile to numberOfFiles
	select Strings file_list
	
	file$ = Get string... ifile
	# appendInfoLine: "Debug 3: current $file = ", file$
	
	file_path$ = textgrid_directory$+"\"+file$
	# appendInfoLine: "Debug 4: current file_path$ = ", file_path$

	call get_stress_pattern 'file_path$'
	
	Write to text file: "C:\Users\rober\Desktop\emp_int\textgrids_test\"+file$
	
endfor

###

procedure get_stress_pattern path$
	if fileReadable (path$)
		Read from file... 'path$'
		textgrid = selected ("TextGrid")
		# appendInfoLine: "Debug 5: Textgrid ", textgrid ," selected."

		num_words = Get number of intervals... tier_words
		# appendInfoLine: "Debug 6: Number of words = ", num_words

		for count_words from 1 to num_words
			
			current_word$ = Get label of interval... 'tier_words' count_words
			# appendInfoLine: "Debug 7: current_word$ = ", current_word$

			end_point = Get end point: tier_words, count_words
			# appendInfoLine: "Debug 7.1: ", current_word$ ," endpoint is = ", end_point
			
			last_letter$ = right$(current_word$, 1)
   			# appendInfoLine: "Debug 8: last_letter$ = ", last_letter$

			stress_pattern$ = ""
	
			if last_letter$ = "" or index(no_pa$, current_word$) > 0
				stress_pattern$ = "none"
				# appendInfoLine: "Debug 9: The stress pattern for ", current_word$ , " is = ", stress_pattern$
			else	
				if index(vowels$, last_letter$) > 0 and index(non_reg_stress$, current_word$) = 0 or last_letter$ = "s" or last_letter$ = "n" 
					stress_pattern$ = "paroxytone"
					# appendInfoLine: "Debug 9.1: The stress pattern for ", current_word$ , " is = ", stress_pattern$
				else
					stress_pattern$ = "oxytone"
					# appendInfoLine: "Debug 9.2: The stress pattern for ", current_word$ ," is = ", stress_pattern$
				endif
			endif
			
			call mark_stress
		endfor
	endif
endproc

###

procedure mark_stress
	if stress_pattern$ = "none"
		# appendInfoLine: "Debug 10: This is silence or the word does not receive a pitch accent."
	else
		if stress_pattern$ = "paroxytone"
			numberOfSyllables = Get number of intervals... tier_syllables
			for j from 1 to numberOfSyllables
				syllable_end = Get end point... tier_syllables j
				if syllable_end = end_point
					previous_syllable = j - 1
					Set interval text... 3 previous_syllable T
					# appendInfoLine: "Debug 11: Stress marker has been added."
				endif
			endfor
		else
			if stress_pattern$ = "oxytone"
			numberOfSyllables = Get number of intervals... tier_syllables
				for j from 1 to numberOfSyllables
					syllable_end = Get end point... tier_syllables j
					if syllable_end = end_point
						Set interval text... 3 j T
						# appendInfoLine: "Debug 12: Stress marker has been added."
					endif
				endfor
			endif
		endif
	endif
endproc

###
























