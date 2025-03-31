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

### 2. `tool.sh`
An advanced Bash script that extends the functionality of `wifi-toolkit.sh` by supporting multiple network interfaces simultaneously. It allows:
- One interface to operate in monitor mode while another operates in managed mode.
- Seamless switching and management of multiple interfaces for advanced wireless security tasks.

- **Usage**:
  ```bash
  ./tool.sh [command] [options]
  ```
- See [wifi-toolkit.md](./wifi-toolkit.md) for detailed documentation (shared command set).

### 3. `wordlist-from-file.py`
A Python script to generate wordlists from input files (CSV or TXT). It extracts words, optionally generates variations, and saves them to an output file.

- **Usage**:
  ```bash
  python3 wordlist-from-file.py [input_file] [options]
  ```
- See [wordlist-from-file.md](./wordlist-from-file.md) for detailed documentation.

### 4. `wpa2-crack.sh`
A Bash script to automate WPA2 handshake extraction and password cracking. It includes:
- Generating Wireshark filters.
- Filtering raw captures with `tshark`.
- Cleaning captures with `wpaclean`.
- Verifying handshakes with `aircrack-ng`.
- Cracking passwords using a wordlist.

- **Usage**:
  ```bash
  ./wpa2-crack.sh -b <AP_BSSID> -c <CLIENT_MAC> -w <wordlist.txt> -i <raw_capture.pcap> [options]
  ```
- See [wpa2-crack.md](./wpa2-crack.md) for detailed documentation.

## Disclaimer
These tools are intended for ethical security testing and research purposes only. Unauthorized use against networks you do not own or have explicit permission to test is illegal.
