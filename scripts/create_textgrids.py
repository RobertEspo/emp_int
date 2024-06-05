import os
import wave
from praatio import textgrid

# Directory containing your .wav files
wav_dir = r"C:\Users\rober\Desktop\emp_int\puertorican_corpus"

# Path to the text file
text_file = r"C:\Users\rober\Desktop\emp_int\scripts\sentences.txt"

# Output directory for TextGrid files
output_dir = r"C:\Users\rober\Desktop\emp_int\textgrids"  # Saving TextGrids in the same directory as .wav files

# Read the text file
with open(text_file, 'r', encoding='utf-8') as file:
    sentences = file.readlines()

# List all .wav files
wav_files = [f for f in os.listdir(wav_dir) if f.endswith('.wav')]

# Ensure there are as many sentences as there are .wav files
assert len(sentences) == len(wav_files), "Number of sentences does not match number of .wav files"

def get_audio_duration(wav_path):
    with wave.open(wav_path, 'r') as wav_file:
        frames = wav_file.getnframes()
        rate = wav_file.getframerate()
        duration = frames / float(rate)
        return duration

# Iterate through each wav file and corresponding sentence
for wav_file, sentence in zip(wav_files, sentences):
    sentence = sentence.strip()  # Remove any trailing newline or spaces
    if not sentence:
        continue

    # Create a new TextGrid
    tg = textgrid.Textgrid()
    tier_name = "Sentence"
    
    # Load the audio file to get its duration
    wav_path = os.path.join(wav_dir, wav_file)
    max_time = get_audio_duration(wav_path)  # Set the interval duration to the audio duration

    # Add a tier and insert the sentence as an interval
    interval_tier = textgrid.IntervalTier(tier_name, [(0, max_time, sentence)], 0, max_time)
    tg.addTier(interval_tier)
    
    # Save the TextGrid with the same name as the .wav file
    output_file = os.path.join(output_dir, os.path.splitext(wav_file)[0] + ".TextGrid")
    tg.save(output_file, includeBlankSpaces=True, format="short_textgrid")

print("TextGrids created successfully.")
