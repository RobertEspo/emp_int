import os
import tgt

# IPA to SAMPA mapping
ipa_to_sampa_dict = {
    "p": "p",
    "b": "b",
    "t̪": "t",
    "d̪": "d",
    "k": "k",
    "ɡ": "g",
    "tʃ": "tS",
    "ɟʝ": "jj",
    "f": "f",
    "β": "B",
    "θ": "T",
    "ð": "D",
    "s": "s",
    "x": "x",
    "ɣ": "G",
    "m": "m",
    "n": "n",
    "ɲ": "J",
    "l": "l",
    "ʎ": "L",
    "ɾ": "r",
    "r": "rr",
    "j": "j",
    "w": "w",
    "i": "i",
    "e": "e",
    "a": "a",
    "o": "o",
    "u": "u"
}

def ipa_to_sampa(ipa_text):
    sampa_text = ipa_text
    for ipa, sampa in ipa_to_sampa_dict.items():
        sampa_text = sampa_text.replace(ipa, sampa)
    return sampa_text

def convert_textgrid_file(input_file, output_file):
    print(f"Processing TextGrid file: {input_file}")
    
    tg = tgt.read_textgrid(input_file)
    
    for tier in tg.tiers:
        print(f"Tier name: {tier.name}")
    
    phones_tier = tg.get_tier_by_name("phones")
    
    if phones_tier:
        print("Found 'phones' tier, starting conversion...")
        for interval in phones_tier.intervals:
            original_text = interval.text
            converted_text = ipa_to_sampa(interval.text)
            interval.text = converted_text
            print(f"Converted '{original_text}' to '{converted_text}'")
    else:
        print("No 'phones' tier found in this file.")
    
    tgt.write_to_file(tg, output_file)

def convert_directory(input_directory, output_directory):
    if not os.path.exists(output_directory):
        os.makedirs(output_directory)
    
    for file_name in os.listdir(input_directory):
        if file_name.endswith('.TextGrid'):
            input_file = os.path.join(input_directory, file_name)
            output_file = os.path.join(output_directory, file_name)
            convert_textgrid_file(input_file, output_file)


# Example usage
input_directory = 'C:\\Users\\rober\\Desktop\\emp_int\\textgrids_test'
output_directory = 'C:\\Users\\rober\\Desktop\\emp_int\\textgrids_test\\sampa'
convert_directory(input_directory, output_directory)
