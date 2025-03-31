# WPA2 Password Cracking on macOS – Full Rule-Set Guide

## Introduction

On macOS, due to the deprecation of the `airport` command-line tool, there is no built-in way to switch between monitor and managed modes, perform scanning on multiple channels, or capture packets directly from the terminal. This limitation makes it challenging to perform wireless security assessments. However, this guide provides a practical workaround using macOS tools like Wireless Diagnostics, Wireshark, and the `wpa2-crack.sh` script to automate the process of WPA2 handshake extraction and cracking.

This guide also introduces a Python script, `/wordlist-from-file.py`, which allows you to generate custom wordlists from a file (e.g., a CSV file) with variations. This can be particularly useful for targeted password cracking.

## Prerequisites

1. **Wireless Diagnostics**  
   - Use Wireless Diagnostics (or equivalent) to capture packets on a known channel.
   - Save the capture as a `.pcap` file.

2. **Wireshark**  
   - Install [Wireshark](https://www.wireshark.org) to inspect and filter the capture file.
   - Open the `.pcap` file in Wireshark to verify the packets.

3. **Aircrack-ng Suite**  
   - Install [aircrack-ng](https://www.aircrack-ng.org/) (this includes tools like `wpaclean` and `aircrack-ng`).
   - On macOS, you can install via Homebrew:
     ```bash
     brew install aircrack-ng
     ```

4. **tshark**  
   - Ensure `tshark` (command-line version of Wireshark) is installed to apply filters automatically.
   - You can install it via Homebrew:
     ```bash
     brew install wireshark
     ```

5. **Script Requirements**  
   - A bash or zsh shell (the script is POSIX compliant).
   - The script assumes you have basic Unix tools (grep, sed, etc.).

## Process Overview

1. **Determine the Channel**  
   - Know on which channel your target network is broadcasting.

2. **Capture Packets**  
   - Use Wireless Diagnostics to capture on the target channel.
   - Save the file as (for example) `raw_capture.pcap`.

3. **Run the Script**  
   - Use the `wpa2-crack.sh` script to automate the process:
     - Extract the STA MAC address (if not provided).
     - Remove broken packets from the capture file.
     - Generate a Wireshark filter.
     - Filter the raw capture using `tshark`.
     - Clean the capture using `wpaclean` (optional).
     - Finalize the capture to ensure the 4-way handshake is the last sequence.
     - Verify the handshake using `aircrack-ng`.
     - Optionally, crack the handshake using a wordlist.

4. **Verify the Handshake**  
   - The script uses `aircrack-ng` to check that a complete handshake is present.

5. **Crack the Handshake**  
   - If a valid handshake is found, the script can start cracking using a wordlist.

### Automatic STA MAC Address Extraction
1. If the `-c` option is not provided, the script uses the `extract_sta_mac` function.
2. The function analyzes the EAPOL messages in the input pcap file.
3. If a single unique STA MAC address is found, it is used as the `CLIENT_MAC`.
4. If multiple STA MAC addresses are found, the script prompts the user to select one or automatically selects the first.

### Broken Packet Removal
The script uses `editcap` to remove broken packets from the input pcap file before filtering. This ensures the capture file is clean and ready for processing.

### Example Usage
If the STA MAC address is not known, simply omit the `-c` option:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -w wordlist.txt -i raw_capture.pcap --cleaning
```

The script will automatically extract the STA MAC address, clean the capture, and finalize it for handshake verification.

## Automation with the Script

The `wpa2-crack.sh` script encapsulates all of the above steps into functions:
- It accepts the AP BSSID, Client MAC, and Wordlist as parameters.
- It automatically generates the Wireshark filter.
- It uses `tshark` to filter the raw capture.
- It removes broken packets using `editcap`.
- It runs `wpaclean` to prepare the handshake (if the `--cleaning` flag is provided).
- It finalizes the capture to ensure the 4-way handshake is the last sequence.
- It verifies the handshake and optionally starts the cracking process.

Make sure the script is executable:
```bash
chmod +x wpa2-crack.sh
```

Then run it with the required flags:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap --cleaning
```

### Optional Flags

#### Save Outputs (`-s` or `--save`)
The `-s` or `--save` flag creates a directory named `wpa2_cracking_<timestamp>` where all output files are saved:
1. The generated Wireshark filter (`filters.txt`).
2. The filtered capture file (`filtered_capture.pcap`).
3. The cleaned handshake file (`cleaned_handshake.pcap`).
4. The finalized handshake file (`finalized_handshake.pcap`).

Example:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap --cleaning -s
```

#### Enable Logging (`-l` or `--log`)
To enable logging, use the `-l` or `--log` flag. This will generate a log file in the same directory as the saved files:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap --cleaning -l
```

#### Optional Cleaning Step (`--cleaning`)
To enable the cleaning step, use the `--cleaning` flag:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap --cleaning
```

If the flag is not provided, the script skips the cleaning step and directly finalizes the capture.

#### Skip Filtering (`--skip-filtering`)
If the input pcap file is already filtered, use the `--skip-filtering` flag to bypass the filtering step:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i filtered_capture.pcap --skip-filtering
```

## Notes and Limitations

- **macOS Limitations**: Due to the lack of native support for monitor mode and channel hopping, capturing packets on macOS requires external tools like Wireless Diagnostics.
- **Wordlist Quality**: The success of cracking depends heavily on the quality of the wordlist. Use the `/wordlist-from-file.py` script to generate targeted wordlists for better results.
- **Legal Disclaimer**: Ensure you have permission to test the network. Unauthorized access is illegal and unethical.

*Happy cracking responsibly!*
