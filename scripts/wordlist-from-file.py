"""
Script: wordlist-from-file.py

Description:
This script generates a wordlist from a given input file (CSV or TXT). It extracts words, optionally generates variations 
of the words, and writes the resulting wordlist to an output file. The script is useful for creating dictionaries for 
password cracking or other purposes.

Inputs:
- input_file: Path to the input file (CSV or TXT).
- -o, --output: Path to the output wordlist file (default: "wordlist.txt").
- -e, --extra: Flag to generate extra variations of the words.
- -c, --column: CSV column name for passwords (if applicable, default: "password").

Outputs:
- A wordlist file containing the extracted and optionally modified words.

Dependencies:
- Python standard libraries: csv, argparse, os, re
"""

import csv
import argparse
import os
import re  # Used for cleaning and splitting text

def detect_file_type(filepath):
    """
    Detect the type of the input file based on its extension.

    Parameters:
    - filepath (str): Path to the input file.

    Returns:
    - str: 'csv' if the file is a CSV, 'txt' if it's a TXT, 'unknown' otherwise.
    """
    ext = os.path.splitext(filepath)[1].lower()
    if ext == '.csv':
        return 'csv'
    elif ext == '.txt':
        return 'txt'
    else:
        return 'unknown'

def recursive_split(s, delimiters):
    """
    Recursively split a string using a list of delimiters.

    Parameters:
    - s (str): The input string to split.
    - delimiters (list): List of delimiters to use for splitting.

    Returns:
    - set: A set of all tokens obtained by splitting the string.
    """
    tokens = set()
    s = s.strip()  # Remove leading/trailing whitespace
    if not s:
        return tokens

    tokens.add(s)  # Add the original string to the set

    if not delimiters:
        return tokens

    # Split using the first delimiter and recursively process the parts
    first_delim = delimiters[0]
    remaining_delims = delimiters[1:]

    for part in s.split(first_delim):
        part = part.strip()
        if part:
            tokens.update(recursive_split(part, remaining_delims))
    
    return tokens

def extract_from_csv(filepath):
    """
    Extract words from a CSV file.

    Parameters:
    - filepath (str): Path to the CSV file.

    Returns:
    - set: A set of unique words extracted from the file.
    """
    words = set()
    delimiters = [' ', '.', ',', ':', ';', '-', '/', '\\', '_']  # Common delimiters
    
    with open(filepath, newline='', encoding='utf-8') as csvfile:
        reader = csv.reader(csvfile)
        for row in reader:
            for cell in row:
                cell = cell.strip()  # Remove leading/trailing whitespace
                if not cell:
                    continue
                
                # Recursive splitting with delimiters
                tokens = recursive_split(cell, delimiters)
                words.update(tokens)
                
                # Regex split adjusted to preserve apostrophes
                regex_tokens = re.split(r"[^A-Za-z0-9']+", cell)
                for token in regex_tokens:
                    token = token.strip()
                    if token:
                        words.add(token)
                        
    return words

def extract_from_txt(filepath):
    """
    Extract words from a TXT file.

    TODO: Improve the word extraction process with TXT files.

    Parameters:
    - filepath (str): Path to the TXT file.

    Returns:
    - list: A list of words extracted from the file.
    """
    words = []
    with open(filepath, 'r', encoding='utf-8') as f:
        for line in f:
            words.append(line.strip())  # Add each line as a word
    return words

def generate_variations(word): 
    """
    Generate variations of a given word.

    TODO: Improve the variations generated.

    Parameters:
    - word (str): The input word.

    Returns:
    - set: A set of variations of the word.
    """
    variations = set()
    # Original word
    variations.add(word)
    # Uppercase
    variations.add(word.upper())
    # Capitalize first letter
    variations.add(word.capitalize())
    # Append some common numbers
    for num in ['1', '123', '2025']:
        variations.add(word + num)
    # Prepend some common symbols
    for sym in ['!', '@', '#']:
        variations.add(sym + word)
    return variations

def process_file(input_file, extra_flag=False, password_column=None):
    """
    Process the input file to extract words and optionally generate variations.

    Parameters:
    - input_file (str): Path to the input file.
    - extra_flag (bool): Whether to generate extra variations of the words.
    - password_column (str): CSV column name for passwords (if applicable).

    Returns:
    - set: A set of processed words.
    """
    file_type = detect_file_type(input_file)
    if file_type == 'csv':
        words = extract_from_csv(input_file)
    elif file_type == 'txt':
        words = extract_from_txt(input_file)
    else:
        raise ValueError("Unsupported file format")
    
    # Remove duplicates
    words = set(words)

    if extra_flag:
        extra_words = set()
        for word in words:
            extra_words.update(generate_variations(word))
        words = extra_words

    return words

def write_wordlist(words, output_file):
    """
    Write the wordlist to an output file.

    Parameters:
    - words (set): The set of words to write.
    - output_file (str): Path to the output file.

    Returns:
    - None
    """
    with open(output_file, 'w', encoding='utf-8') as f:
        for word in words:
            f.write(word + "\n")

def main():
    """
    Main function to parse arguments and execute the script.
    """
    parser = argparse.ArgumentParser(description="Generate a dictionary/wordlist for password cracking.")
    parser.add_argument("input_file", help="Path to input file (CSV, TXT, etc.)")
    parser.add_argument("-o", "--output", default="wordlist.txt", help="Output wordlist file")
    parser.add_argument("-e", "--extra", action="store_true", help="Generate extra variations")
    parser.add_argument("-c", "--column", default="password", help="CSV column name for passwords (if applicable)")
    
    args = parser.parse_args()

    try:
        words = process_file(args.input_file, extra_flag=args.extra, password_column=args.column)
        write_wordlist(words, args.output)
        print(f"Wordlist generated: {args.output}")
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    main()
