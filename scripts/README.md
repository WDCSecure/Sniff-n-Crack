# Sniff-Crack Toolkit

## Overview
The Sniff-Crack Toolkit is a collection of scripts designed for wireless security analysis and password cracking. It includes tools for generating wordlists, managing wireless interfaces, and performing advanced penetration testing tasks.

## Scripts

### 1. `wifi-toolkit.sh`
A Bash script providing a comprehensive toolkit for wireless security tasks, including:
- Enabling monitor mode.
- Scanning networks.
- Capturing WPA handshakes.
- Cracking WPA passwords.
- Converting captures to Hashcat format.

- **Usage**:
  ```bash
  ./wifi-toolkit.sh [command] [options]
  ```
- See [wifi-toolkit.md](./wifi-toolkit.md) for detailed documentation.

### 2. `wordlist-from-file.py`
A Python script to generate wordlists from input files (CSV or TXT). It extracts words, optionally generates variations, and saves them to an output file.

- **Usage**:
  ```bash
  python3 wordlist-from-file.py [input_file] [options]
  ```
- See [wordlist-from-file.md](./wordlist-from-file.md) for detailed documentation.

## Disclaimer
These tools are intended for ethical security testing and research purposes only. Unauthorized use against networks you do not own or have explicit permission to test is illegal.
