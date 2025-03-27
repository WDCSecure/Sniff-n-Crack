# Managed Mode

## What is Managed Mode?

Managed Mode is the default mode for most wireless network interfaces. In this mode, the wireless adapter connects to a specific access point (AP) and communicates only with that AP. It is used for regular network activities like browsing the internet, file transfers, and streaming.

Unlike Monitor Mode, Managed Mode filters out packets not addressed to the device, ensuring efficient and secure communication with the connected network.

## How to Set Up Managed Mode in Linux

### Prerequisites
1. A wireless network adapter.
2. Administrative privileges (root access) on your Linux system.
3. Tools like `airmon-ng` or `iw`.

### Steps to Enable Managed Mode

#### Using `airmon-ng`:
1. Disable Monitor Mode (if enabled):
   ```bash
   sudo airmon-ng stop wlan0mon
   ```
   This will revert the interface back to Managed Mode.

2. Verify the mode:
   ```bash
   iwconfig
   ```
   The interface should now show `Mode: Managed`.

#### Using `iw`:
1. Bring the interface down:
   ```bash
   sudo ip link set wlan0 down
   ```
2. Set the interface to Managed Mode:
   ```bash
   sudo iw wlan0 set type managed
   ```
3. Bring the interface back up:
   ```bash
   sudo ip link set wlan0 up
   ```
4. Verify the mode:
   ```bash
   iwconfig
   ```

### Connecting to a Wireless Network
1. Scan for available networks:
   ```bash
   sudo iwlist wlan0 scan
   ```
2. Connect to a network using `nmcli`:
   ```bash
   nmcli dev wifi connect "SSID" password "your_password"
   ```

### Disabling Managed Mode
To switch to Monitor Mode, follow the steps outlined in the Monitor Mode guide.

## What You Can Do in Managed Mode

1. **Internet Access**: Connect to wireless networks for browsing, streaming, and downloading.
2. **File Sharing**: Transfer files over the network.
3. **Secure Communication**: Communicate securely with the access point using encryption protocols like WPA2 or WPA3.

## Why Switch to Managed Mode?

Managed Mode is necessary for regular wireless network usage. For example:
- **Daily Activities**: Accessing the internet, sending emails, or streaming videos.
- **Secure Connections**: Ensuring encrypted communication with the access point.
- **Network Stability**: Maintaining a stable connection to a specific access point.

Switching back to Managed Mode ensures that your wireless adapter functions as intended for everyday tasks.
