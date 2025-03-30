# Wordlist Generator from File

## Overview
The `wordlist-from-file.py` script generates a wordlist from a given input file (CSV or TXT). It extracts words, optionally generates variations, and writes the resulting wordlist to an output file. This tool is useful for creating dictionaries for password cracking or other purposes.

## Features
- Supports CSV and TXT input files.
- Extracts unique words from the input file.
- Optionally generates variations of the extracted words.
- Outputs the wordlist to a specified file.

## Usage
Run the script with the following syntax:
```bash
python3 wordlist-from-file.py [input_file] [options]
```

### Options
- `-o, --output` : Path to the output wordlist file (default: `wordlist.txt`).
- `-e, --extra` : Generate extra variations of the words.
- `-c, --column` : CSV column name for passwords (default: `password`).

### Examples
1. Generate a wordlist from a TXT file:
   ```bash
   python3 wordlist-from-file.py input.txt -o output.txt
   ```

2. Generate a wordlist from a CSV file with variations:
   ```bash
   python3 wordlist-from-file.py input.csv -e -c password -o wordlist.txt
   ```

## Dependencies
Ensure the following Python libraries are available:
- `csv`
- `argparse`
- `os`
- `re`

## Disclaimer
This script is intended for ethical use only. Unauthorized use against systems you do not own or have explicit permission to test is illegal.
