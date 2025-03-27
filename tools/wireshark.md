# Wireshark

## Manual

```
WIRESHARK
Interactively dump and analyze network traffic

SYNOPSIS
    wireshark [ -a <capture autostop condition> ] ... [ -b <capture ring buffer option> ] ... [ -B <capture buffer size> ]  [ -c <capture packet count> ] [ -C <configuration profile> ] [ -D ] [ --display=<X display to use> ]  [ -f <capture filter> ] [ -g <packet number> ] [ -h ] [ -H ] [ -i <capture interface>|- ] [ -I ] [ -j ] [ -J <jump filter> ] [ -k ] [ -K <keytab> ] [ -l ] [ -L ] [ -m <font> ] [ -n ] [ -N <name resolving flags> ]  [ -o <preference/recent setting> ] ... [ -p ] [ -P <path setting>] [ -r <infile> ] [ -R <read (display) filter> ] [ -s <capture snaplen> ] [ -S ] [ -t a|ad|adoy|d|dd|e|r|u|ud|udoy ] [ -v ] [ -w <outfile> ] [ -X <eXtension option> ] [ -y <capture link type> ] [ -Y <displaY filter> ] [ -z <statistics> ] [ <infile> ]

DESCRIPTION
    Wireshark is a GUI network protocol analyzer. It lets you interactively browse packet data from a live network or from a previously saved capture file. Wireshark's native capture file format is pcap format, which is also the format used by tcpdump and various other tools.

    Wireshark can read/import the following file formats:
        - pcap
        - pcap-ng
        - snoop and atmsnoop captures
        - Shomiti/Finisar Surveyor captures
        - Novell LANalyzer captures
        - Microsoft Network Monitor captures
        - AIX's iptrace captures
        - Cinco Networks NetXRay captures
        - Network Associates Windows-based Sniffer captures
        - Network General/Network Associates DOS-based Sniffer (compressed or uncompressed) captures
        - AG Group/WildPackets EtherPeek/TokenPeek/AiroPeek/EtherHelp/PacketGrabber captures
        - RADCOM's WAN/LAN analyzer captures
        - Network Instruments Observer version 9 captures
        - Lucent/Ascend router debug output
        - Files from HP-UX's nettl
        - Toshiba's ISDN routers dump output
        - The output from i4btrace from the ISDN4BSD project
        - Traces from the EyeSDN USB S0
        - The output in IPLog format from the Cisco Secure Intrusion Detection System
        - pppd logs (pppdump format)
        - The output from VMS's TCPIPtrace/TCPtrace/UCX$TRACE utilities
        - The text output from the DBS Etherwatch VMS utility
        - Visual Networks' Visual UpTime traffic capture
        - The output from CoSine L2 debug
        - The output from InfoVista's 5View LAN agents
        - Endace Measurement Systems' ERF format captures
        - Linux Bluez Bluetooth stack hcidump -w traces
        - Catapult DCT2000 .out files
        - Gammu generated text output from Nokia DCT3 phones in Netmonitor mode
        - IBM Series (OS/400) Comm traces (ASCII & UNICODE)
        - Juniper Netscreen snoop files
        - Symbian OS btsnoop files
        - TamoSoft CommView files
        - Textronix K12xx 32bit .rf5 format files
        - Textronix K12 text file format captures
        - Apple PacketLogger files
        - Files from Aethra Telecommunications' PC108 software for their test instruments
        - MPEG-2 Transport Streams as defined in ISO/IEC 13818-1
        - Rabbit Labs CAM Inspector files

    Wireshark automatically determines the file type and can read compressed files using gzip. The `.gz` extension is not required.

    Wireshark's main window shows three views of a packet:
        1. A summary line describing the packet.
        2. A packet details display for drilling down into protocol or field details.
        3. A hex dump showing the packet's raw data.

    Wireshark can assemble all packets in a TCP conversation and display ASCII, EBCDIC, or hex data. Its display filters are powerful and support a rich syntax.

    Packet capturing uses the pcap library, and the capture filter syntax follows pcap rules. Compressed file support requires the zlib library.

    The pathname of a capture file can be specified with the `-r` option or as a command-line argument.

OPTIONS
    Most users will want to start Wireshark without options and configure it from the menus instead. Those users may just skip this section.

    Refer to this link to see all the options: https://manpages.org/wireshark

NOTES
    The latest version of Wireshark can be found at http://www.wireshark.org.
    HTML versions of the Wireshark project man pages are available at: http://www.wireshark.org/docs/man-pages.

AUTHORS
    For the list of authors, see https://manpages.org/wireshark.
```

## Wireshark Filters

Wireshark provides powerful filtering capabilities to analyze specific types of packets or fields. Below is a comprehensive guide to filtering various types of traffic and messages.

### Filtering by MAC Address

#### Sender MAC Address
To filter packets sent by a specific MAC address:
```
wlan.sa == aa:bb:cc:dd:ee:ff
```

#### Receiver MAC Address
To filter packets received by a specific MAC address:
```
wlan.da == aa:bb:cc:dd:ee:ff
```

#### Host MAC Address
To filter packets where a specific MAC address is either the sender or receiver:
```
wlan.addr == aa:bb:cc:dd:ee:ff
```

#### Access Point (AP) MAC Address
To filter packets involving a specific AP MAC address:
```
wlan.bssid == aa:bb:cc:dd:ee:ff
```

### Filtering by Frame Type

#### Deauthentication Messages
To filter deauthentication frames:
```
wlan.fc.type_subtype == 0x0c
```

#### Beacon Messages
To filter beacon frames:
```
wlan.fc.type_subtype == 0x08
```

#### Probe Request Messages
To filter probe request frames:
```
wlan.fc.type_subtype == 0x04
```

#### Probe Response Messages
To filter probe response frames:
```
wlan.fc.type_subtype == 0x05
```

#### Authentication Request/Response Messages
To filter authentication frames:
```
wlan.fc.type_subtype == 0x0b
```

#### Association Request Messages
To filter association request frames:
```
wlan.fc.type_subtype == 0x00
```

#### Association Response Messages
To filter association response frames:
```
wlan.fc.type_subtype == 0x01
```

### Filtering by Protocol

#### EAPOL Messages
To filter EAPOL (Extensible Authentication Protocol over LAN) messages:
```
eapol
```

#### 802.11 Messages
To filter all 802.11 wireless LAN frames:
```
wlan
```

### Filtering by Specific Fields

#### SSID (Network Name)
To filter packets containing a specific SSID:
```
wlan.ssid == "YourNetworkName"
```

#### BSSID
To filter packets involving a specific BSSID:
```
wlan.bssid == aa:bb:cc:dd:ee:ff
```

### Combining Filters

Wireshark allows combining multiple filters using logical operators:
- **AND**: `&&`
- **OR**: `||`
- **NOT**: `!`

#### Example: Filter Deauthentication Frames from a Specific Sender
```
wlan.fc.type_subtype == 0x0c && wlan.sa == aa:bb:cc:dd:ee:ff
```

#### Example: Filter Beacon Frames from a Specific BSSID
```
wlan.fc.type_subtype == 0x08 && wlan.bssid == aa:bb:cc:dd:ee:ff
```

### Notes on Filters

- Filters are case-sensitive.
- Use double quotes (`"`) for strings like SSIDs.
- MAC addresses should be written in lowercase and separated by colons (`:`).

This section provides a starting point for filtering common types of traffic in Wireshark. For more advanced filtering options, refer to the Wireshark documentation.
