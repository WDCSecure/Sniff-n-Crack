# tcpdump

## Manual

```
TCPDUMP
A powerful command-line packet analyzer

SYNOPSIS
    tcpdump [options] [expression]

DESCRIPTION
    tcpdump is a command-line tool for capturing and analyzing network packets. It allows users to intercept and display packets being transmitted or received over a network to which the computer is attached. tcpdump uses the libpcap library for packet capturing.

    tcpdump can capture packets from a live network interface or read packets from a previously saved capture file in pcap format. It provides powerful filtering capabilities to capture only the packets of interest.

OPTIONS
    Common options:
        -i <interface>
            Specify the network interface to listen on. If not specified, tcpdump will use the first interface it finds.
        -w <file>
            Write the captured packets to a file in pcap format for later analysis.
        -r <file>
            Read packets from a saved pcap file instead of capturing live packets.
        -c <count>
            Stop capturing after <count> packets.
        -n
            Do not resolve hostnames (display IP addresses instead).
        -nn
            Do not resolve hostnames or port names (display IP addresses and port numbers).
        -v
            Provide verbose output.
        -vv
            Provide more verbose output.
        -vvv
            Provide the most verbose output.
        -e
            Display the link-layer header of each packet.
        -q
            Provide less verbose output (quiet mode).
        -X
            Display packet contents in both hex and ASCII.
        -xx
            Display packet contents in hex (including link-layer headers).
        -A
            Display packet contents in ASCII.
        -s <snaplen>
            Set the snapshot length to <snaplen> bytes. The default is 262144 bytes.
        -t
            Do not print a timestamp on each line of output.
        -tt
            Print an unformatted timestamp on each line of output.
        -ttt
            Print a delta (microsecond) timestamp between packets.
        -tttt
            Print a human-readable timestamp on each line of output.
        -z <postrotate-command>
            Run the specified command after rotating the dump file (used with -C or -G).
        -C <file-size>
            Rotate the dump file after it reaches <file-size> megabytes.
        -G <seconds>
            Rotate the dump file every <seconds> seconds.

    Filtering options:
        -f
            Do not attempt to print human-readable hostnames.
        -l
            Make stdout line-buffered. Useful if you want to see the data while capturing.
        -K
            Do not attempt to verify IP checksum.
        -E <spi@ipaddr:algo:secret>
            Decrypt IPsec ESP packets using the provided parameters.

    Expression:
        The expression specifies which packets will be captured. If no expression is given, all packets on the network will be captured. Expressions can filter packets based on protocols, source/destination IP addresses, ports, and more.

        Examples:
            - Capture all traffic on port 80:
              ```
              tcpdump port 80
              ```
            - Capture traffic from a specific IP address:
              ```
              tcpdump src 192.168.1.1
              ```
            - Capture traffic to a specific IP address:
              ```
              tcpdump dst 192.168.1.1
              ```
            - Capture traffic between two IP addresses:
              ```
              tcpdump host 192.168.1.1 and 192.168.1.2
              ```
            - Capture traffic for a specific protocol (e.g., TCP):
              ```
              tcpdump tcp
              ```

NOTES
    tcpdump requires root or administrator privileges to capture packets on most systems. Use with caution, as it can capture sensitive data.

    For more information, refer to the official tcpdump documentation at https://www.tcpdump.org.

AUTHORS
    tcpdump was originally written by Van Jacobson, Craig Leres, and Steven McCanne. It is maintained by the tcpdump team. For a full list of contributors, see https://www.tcpdump.org.
```

## tcpdump Filters

tcpdump provides powerful filtering capabilities to capture specific types of packets. Below is a guide to common filters.

### Filtering by IP Address

#### Source IP Address
To capture packets from a specific source IP:
```
src 192.168.1.1
```

#### Destination IP Address
To capture packets to a specific destination IP:
```
dst 192.168.1.1
```

#### Host IP Address
To capture packets where a specific IP is either the source or destination:
```
host 192.168.1.1
```

### Filtering by Port

#### Specific Port
To capture packets on a specific port:
```
port 80
```

#### Source Port
To capture packets from a specific source port:
```
src port 80
```

#### Destination Port
To capture packets to a specific destination port:
```
dst port 80
```

### Filtering by Protocol

#### TCP Packets
To capture only TCP packets:
```
tcp
```

#### UDP Packets
To capture only UDP packets:
```
udp
```

#### ICMP Packets
To capture only ICMP packets:
```
icmp
```

### Combining Filters

tcpdump allows combining multiple filters using logical operators:
- **AND**: `and`
- **OR**: `or`
- **NOT**: `not`

#### Example: Capture TCP Packets on Port 80 from a Specific Source
```
tcp and port 80 and src 192.168.1.1
```

#### Example: Capture All Traffic Except ICMP
```
not icmp
```

### Notes on Filters

- Filters are case-sensitive.
- Use quotes for complex expressions.
- Combine filters carefully to avoid unintended results.

This section provides a starting point for filtering common types of traffic in tcpdump. For more advanced filtering options, refer to the tcpdump documentation.
