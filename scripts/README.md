# Wireless Security Tool - Advanced Edition

## Preparation
To run this script, you need a Linux system with the required dependencies installed.

### Install Dependencies
Run the following command to install the necessary tools:
```bash
sudo apt update && sudo apt install -y aircrack-ng hashcat hping3 network-manager iw
```

## Overview
This script provides a comprehensive toolkit for wireless security analysis and penetration testing. It includes commands for setting monitor mode, scanning networks, deauthenticating clients, capturing handshakes, and cracking WPA passwords.

## Usage
Run the script with the following syntax:
```bash
./wifi-toolkit.sh [command] [options]
```

### Commands and Options

#### 1. Monitor Mode
Enable monitor mode on the specified interface.
```bash
./wifi-toolkit.sh monitor [INTERFACE]
```
Options:
- `-i INTERFACE` : Specify the wireless interface (default: `wlo1`).

#### 2. Managed Mode
Set the wireless interface back to managed mode.
```bash
./wifi-toolkit.sh managed [INTERFACE]
```
Options:
- `-i INTERFACE` : Specify the wireless interface (default: `wlo1`).

#### 3. Scan for Networks (Airodump-ng)
Perform a wireless scan using `airodump-ng`.
```bash
./wifi-toolkit.sh scan [INTERFACE]
```
Options:
- `-i INTERFACE` : Specify the wireless interface (default: `wlo1`).

#### 4. Scan for Networks (NetworkManager)
Perform a network scan using `nmcli`.
```bash
./wifi-toolkit.sh scan-nm [INTERFACE]
```
Options:
- `-i INTERFACE` : Specify the wireless interface (default: `wlo1`).

#### 5. Deauthentication Attack
Send deauthentication packets to disconnect a client from an AP.
```bash
./wifi-toolkit.sh deauth [AP_MAC] [CLIENT_MAC]
```
Options:
- `-a AP_MAC` : Target Access Point MAC address.
- `-c CLIENT_MAC` : Target Client MAC address.

#### 6. Set Wireless Channel
Change the wireless interface to a specific channel.
```bash
./wifi-toolkit.sh set-channel [CHANNEL] [INTERFACE]
```
Options:
- `-c CHANNEL` : Channel number (1-14).
- `-i INTERFACE` : Specify the wireless interface.

#### 7. ICMP Flood Attack
Send a continuous flood of ICMP packets.
```bash
./wifi-toolkit.sh ping-flood [SRC_IP] [DST_IP]
```
Options:
- `-s SRC_IP` : Spoofed source IP address.
- `-d DST_IP` : Target destination IP address.

#### 8. Capture WPA Handshake
Capture WPA handshake packets.
```bash
./wifi-toolkit.sh capture-handshake [CHANNEL] [BSSID] [OUTPUT]
```
Options:
- `-c CHANNEL` : Channel number.
- `-b BSSID` : Target AP BSSID.
- `-o OUTPUT` : Output file prefix.

#### 9. Crack WPA Handshake
Attempt to crack a captured WPA handshake.
```bash
./wifi-toolkit.sh crack [WORDLIST] [CAP]
```
Options:
- `-w WORDLIST` : Path to the wordlist file.
- `-f CAP` : Path to the captured handshake file.

#### 10. Convert Capture to Hashcat Format
Convert a `.pcapng` file to Hashcat format for cracking.
```bash
./wifi-toolkit.sh convert-hc [PCAP] [HASH_FILE]
```
Options:
- `-p PCAP` : Path to the capture file.
- `-H HASH_FILE` : Output hash file.

#### 11. Crack Hash with Hashcat
Run Hashcat on the captured handshake.
```bash
./wifi-toolkit.sh hashcat [HASH_FILE] [WORDLIST]
```
Options:
- `-H HASH_FILE` : Path to the hash file.
- `-w WORDLIST` : Path to the wordlist.

#### 12. Help Menu
Display all available commands.
```bash
./wifi-toolkit.sh help
```

## Dependencies
Ensure the following tools are installed before running the script:
- `aircrack-ng`
- `hashcat`
- `hping3`
- `nmcli`
- `iw`
- `systemctl`

## Disclaimer
This toolkit is intended for ethical security testing and research purposes only. Unauthorized use against networks you do not own or have explicit permission to test is illegal.

