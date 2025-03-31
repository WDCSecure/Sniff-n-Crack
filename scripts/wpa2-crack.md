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

5. **Python Script for Wordlist Generation**  
   - Use the `/wordlist-from-file.py` script to create custom wordlists from a file (e.g., a CSV file). This script can generate variations of passwords based on input data, making it a powerful tool for targeted attacks.

6. **Script Requirements**  
   - A bash or zsh shell (the script is POSIX compliant).
   - The script assumes you have basic Unix tools (grep, sed, etc.).

## Process Overview

1. **Determine the Channel**  
   - Know on which channel your target network is broadcasting.

2. **Capture Packets**  
   - Use Wireless Diagnostics to capture on the target channel.
   - Save the file as (for example) `raw_capture.pcap`.

3. **Analyze in Wireshark**  
   - Open `raw_capture.pcap` in Wireshark.
   - Identify the AP BSSID and the Client MAC.

4. **Generate a Dedicated Filter**  
   - Use the provided script (or the standalone filter script) to generate a Wireshark display filter.
   - The filter will capture:
     - Beacon frames (for the ESSID)
     - Probe responses
     - Authentication/Association frames
     - EAPOL handshake messages

5. **Apply the Filter and Export**  
   - Use `tshark` with the generated filter to export only the required packets:
     ```bash
     tshark -r raw_capture.pcap -Y "<your_filter>" -w filtered_capture.pcap -F pcap
     ```

6. **Clean the Capture with wpaclean**  
   - Run `wpaclean` to remove extraneous packets:
     ```bash
     wpaclean cleaned_handshake.pcap filtered_capture.pcap
     ```

7. **Verify the Handshake**  
   - Use `aircrack-ng` to check that a complete handshake is present:
     ```bash
     aircrack-ng cleaned_handshake.pcap
     ```
   - You should see a valid handshake for your target network.

8. **Crack the Handshake**  
   - With a wordlist (e.g., `wordlist.txt`), run:
     ```bash
     aircrack-ng -w wordlist.txt -b <BSSID> cleaned_handshake.pcap
     ```
   - Replace `<BSSID>` with your AP’s BSSID.

## Automation with the Script

A bash/zsh script named `wpa2-crack.sh` is provided. It encapsulates all of the above steps into functions:
- It accepts the AP BSSID, Client MAC, and Wordlist as parameters.
- It automatically generates the Wireshark filter.
- It uses `tshark` to filter the raw capture.
- It runs `wpaclean` to prepare the handshake.
- It verifies the handshake and optionally starts the cracking process.

Make sure the script is executable:
```bash
chmod +x wpa2-crack.sh
```

Then run it with the required flags:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap
```

### Optional Flags

#### Save Outputs (`-s` or `--save`)
The `-s` or `--save` flag creates a directory named `wpa2_cracking_<timestamp>` where all output files are saved:
1. The generated Wireshark filter (`filters.txt`).
2. The filtered capture file (`filtered_capture.pcap`).
3. The cleaned handshake file (`cleaned_handshake.pcap`).

Example:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap -s
```

After running the script, you will find all the saved files in the `wpa2_cracking_<timestamp>` directory.

#### Enable Logging (`-l` or `--log`)
To enable logging, use the `-l` or `--log` flag. This will generate a log file in the same directory as the saved files:
```bash
./wpa2-crack.sh -b 00:14:22:01:23:45 -c 12:34:56:78:9a:bc -w wordlist.txt -i raw_capture.pcap -l
```

If the `-l` flag is not provided, no log file will be created.

## Generating Custom Wordlists

The `/wordlist-from-file.py` script allows you to create custom wordlists from a file (e.g., a CSV file). It supports generating variations of passwords based on input data.

### Example Usage:
1. Prepare a CSV file with potential password components (e.g., names, dates, keywords).
2. Run the script:
   ```bash
   python3 /path/to/wordlist-from-file.py -i input.csv -o wordlist.txt
   ```
3. Use the generated `wordlist.txt` with `aircrack-ng`:
   ```bash
   aircrack-ng -w wordlist.txt -b <BSSID> cleaned_handshake.pcap
   ```

This approach is particularly useful for targeted attacks where you have some knowledge of the target's password patterns.

## Notes and Limitations

- **macOS Limitations**: Due to the lack of native support for monitor mode and channel hopping, capturing packets on macOS requires external tools like Wireless Diagnostics.
- **Wordlist Quality**: The success of cracking depends heavily on the quality of the wordlist. Use the `/wordlist-from-file.py` script to generate targeted wordlists for better results.
- **Legal Disclaimer**: Ensure you have permission to test the network. Unauthorized access is illegal and unethical.

*Happy cracking responsibly!*
