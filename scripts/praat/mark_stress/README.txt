mark_stress.praat
	Used to mark Spanish stressed syllables on a Syllables tier.
	This was created to be used in conjunction with etiToBI, so words that do not receive a pitch accent are not marked for stress.
	Requires two tiers:
		1) Words tier: Words written in regular Spanish orthography aligned to the signal.
		2) Syllables tier: Syllable boundaries aligned to the Words tier.

no_hiatus.txt
	A list of words that end in two vowels and do not exhibit hiatus eg "Bolivia".

no_pa.txt
	Words that do not receive a pitch accent.

non_reg_stress.txt
	Words that do not follow typical Spanish stress pattern eg bebé.
	Words that end in two vowels in hiatus eg leía will be marked for stress as expected, and thus do not need to be added to this list.

