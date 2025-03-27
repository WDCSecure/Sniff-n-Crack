# Monitor Mode

## What is Monitor Mode?

Monitor Mode is a special mode for wireless network interfaces that allows a device to capture all wireless traffic in its range, regardless of whether the traffic is addressed to it. This mode is essential for tasks like network analysis, packet sniffing, and wireless security auditing.

Unlike Managed Mode, where the wireless interface only processes packets addressed to it or broadcast packets, Monitor Mode enables the interface to listen to all packets on a specific channel.

## How to Set Up Monitor Mode in Linux

### Prerequisites
1. A wireless network adapter that supports Monitor Mode.
2. Administrative privileges (root access) on your Linux system.
3. Tools like `airmon-ng` (part of the Aircrack-ng suite) or `iw`.

### Steps to Enable Monitor Mode

#### Using `airmon-ng`:
1. Install the Aircrack-ng suite:
   ```bash
   sudo apt update
   sudo apt install aircrack-ng
   ```
2. Identify your wireless interface:
   ```bash
   iwconfig
   ```
   Look for the interface name (e.g., `wlan0`).

3. Enable Monitor Mode:
   ```bash
   sudo airmon-ng start wlan0
   ```
   This will create a new interface (e.g., `wlan0mon`) in Monitor Mode.

4. Verify the mode:
   ```bash
   iwconfig
   ```
   The interface should now show `Mode: Monitor`.

#### Using `iw`:
1. Bring the interface down:
   ```bash
   sudo ip link set wlan0 down
   ```
2. Set the interface to Monitor Mode:
   ```bash
   sudo iw wlan0 set type monitor
   ```
3. Bring the interface back up:
   ```bash
   sudo ip link set wlan0 up
   ```
4. Verify the mode:
   ```bash
   iwconfig
   ```

### Disabling Monitor Mode
To switch back to Managed Mode:
- Using `airmon-ng`:
  ```bash
  sudo airmon-ng stop wlan0mon
  ```
- Using `iw`:
  ```bash
  sudo ip link set wlan0 down
  sudo iw wlan0 set type managed
  sudo ip link set wlan0 up
  ```

## What You Can Do in Monitor Mode

1. **Packet Sniffing**: Capture all wireless packets for analysis using tools like `Wireshark` or `tcpdump`.
2. **Network Auditing**: Identify vulnerabilities in wireless networks.
3. **Channel Scanning**: Monitor traffic on specific channels.
4. **Wireless Intrusion Detection**: Detect unauthorized devices or rogue access points.

## Why Switch to Monitor Mode?

Monitor Mode is necessary for tasks that require passive listening to wireless traffic. For example:
- **Penetration Testing**: To identify security flaws in a network.
- **Troubleshooting**: To diagnose wireless network issues.
- **Research**: To study wireless protocols and traffic patterns.

Switching to Monitor Mode allows you to gather data that is otherwise inaccessible in Managed Mode.
