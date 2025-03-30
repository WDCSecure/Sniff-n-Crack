# tcpdump

## Manual

# Manual

```
TCPDUMP
    dump traffic on a network

SYNOPSIS
    tcpdump [ -AbdDefhHIJKlLnNOpqStuUvxX# ] [ -B buffer_size ]
             [ -c count ] [ --count ] [ -C file_size ]
             [ -E spi@ipaddr algo:secret,... ]
             [ -F file ] [ -G rotate_seconds ] [ -i interface ]
             [ --immediate-mode ] [ -j tstamp_type ]
             [ --lengths ] [ -m module ]
             [ -M secret ] [ --number ] [ --print ]
             [ --print-sampling nth ] [ -Q in|out|inout ] [ -r file ]
             [ -s snaplen ] [ --skip count ] [ -T type ] [ --version ]
             [ -V file ] [ -w file ] [ -W filecount ] [ -y datalinktype ]
             [ -z postrotate-command ] [ -Z user ]
             [ --time-stamp-precision=tstamp_precision ]
             [ --micro ] [ --nano ]
             [ expression ]

DESCRIPTION
    tcpdump prints out a description of the contents of packets on a network interface that match the Boolean expression (see pcap-filter(7) for the expression syntax); the description is preceded by a time stamp, printed, by default, as hours, minutes, seconds, and fractions of a second since midnight. It can also be run with the -w flag, which causes it to save the packet data to a file for later analysis, and/or with the -r flag, which causes it to read from a saved packet file rather than to read packets from a network interface. It can also be run with the -V flag, which causes it to read a list of saved packet files. In all cases, only packets that match expression will be processed by tcpdump.

    tcpdump will, if not run with the -c flag, continue capturing packets until it is interrupted by a SIGINT signal (generated, for example, by typing your interrupt character, typically control-C) or a SIGTERM signal (typically generated with the kill(1) command); if run with the -c flag, it will capture packets until it is interrupted by a SIGINT or SIGTERM signal or the specified number of packets have been processed.

    When tcpdump finishes capturing packets, it will report counts of:

        packets "captured" (this is the number of packets that tcpdump has received and processed);
        packets "received by filter" (the meaning of this depends on the OS on which you're running tcpdump, and possibly on the way the OS was configured - if a filter was specified on the command line, on some OSes it counts packets regardless of whether they were matched by the filter expression and, even if they were matched by the filter expression, regardless of whether tcpdump has read and processed them yet, on other OSes it counts only packets that were matched by the filter expression regardless of whether tcpdump has read and processed them yet, and on other OSes it counts only packets that were matched by the filter expression and were processed by tcpdump);
        packets "dropped by kernel" (this is the number of packets that were dropped, due to a lack of buffer space, by the packet capture mechanism in the OS on which tcpdump is running, if the OS reports that information to applications; if not, it will be reported as 0).

    On platforms that support the SIGINFO signal, such as most BSDs (including macOS), it will report those counts when it receives a SIGINFO signal (generated, for example, by typing your "status" character, typically control-T, although on some platforms, such as macOS, the "status" character is not set by default, so you must set it with stty(1) in order to use it) and will continue capturing packets. On platforms that do not support the SIGINFO signal, the same can be achieved by using the SIGUSR1 signal.

    Using the SIGUSR2 signal along with the -w flag will forcibly flush the packet buffer into the output file.

    Reading packets from a network interface may require that you have special privileges; see the pcap(3PCAP) man page for details. Reading a saved packet file doesn't require special privileges.

OPTIONS
    -A
        Print each packet (minus its link level header) in ASCII. Handy for capturing web pages. No effect when -x[x] or -X[X] options are used.
    -b
        Print the AS number in BGP packets using "asdot" rather than "asplain" representation, in RFC 5396 terms.
    -B buffer_size
    --buffer-size=buffer_size
        Set the operating system capture buffer size to buffer_size, in units of KiB (1024 bytes).
    -c count
        Exit after receiving or reading count packets. If the --skip option is used, the count starts after the skipped packets.
    --count
        Print only on stdout the packet count when reading capture file(s) instead of parsing/printing the packets. If a filter is specified on the command line, tcpdump counts only packets that were matched by the filter expression.
    -C file_size
        Before writing a raw packet to a savefile, check whether the file is currently larger than file_size and, if so, close the current savefile and open a new one. Savefiles after the first savefile will have the name specified with the -w flag, with a number after it, starting at 1 and continuing upward. The default unit of file_size is millions of bytes (1,000,000 bytes, not 1,048,576 bytes).
        By adding a suffix of k/K, m/M or g/G to the value, the unit can be changed to 1,024 (KiB), 1,048,576 (MiB), or 1,073,741,824 (GiB) respectively.
    -d
        Dump the compiled packet-matching code in a human-readable form to standard output and stop.
    -dd
        Dump packet-matching code as a C array of struct bpf_insn structures.
    -ddd
        Dump packet-matching code as decimal numbers (preceded with a count).
    -D
    --list-interfaces
        Print the list of the network interfaces available on the system and on which tcpdump can capture packets. For each network interface, a number and an interface name, possibly followed by a text description of the interface, are printed.
    -e
        Print the link-level header on each dump line. This can be used, for example, to print MAC layer addresses for protocols such as Ethernet and IEEE 802.11.
    -E
        Use spi@ipaddr algo:secret for decrypting IPsec ESP packets that are addressed to addr and contain Security Parameter Index value spi.
    -f
        Print `foreign' IPv4 addresses numerically rather than symbolically.
    -F file
        Use file as input for the filter expression. An additional expression given on the command line is ignored.
    -G rotate_seconds
        Rotates the dump file specified with the -w option every rotate_seconds seconds.
    -h
    --help
        Print the tcpdump and libpcap version strings, print a usage message, and exit.
    --version
        Print the tcpdump and libpcap version strings and exit.
    -H
        Attempt to detect 802.11s draft mesh headers.
    -i interface
    --interface=interface
        Listen, report the list of link-layer types, or report the results of compiling a filter expression on interface.
    -I
    --monitor-mode
        Put the interface in "monitor mode"; this is supported only on IEEE 802.11 Wi-Fi interfaces.
    --immediate-mode
        Capture in "immediate mode". In this mode, packets are delivered to tcpdump as soon as they arrive.
    -j tstamp_type
    --time-stamp-type=tstamp_type
        Set the time stamp type for the capture to tstamp_type.
    -J
    --list-time-stamp-types
        List the supported time stamp types for the interface and exit.
    --time-stamp-precision=tstamp_precision
        Set the time stamp precision for the capture to tstamp_precision.
    --micro
    --nano
        Shorthands for --time-stamp-precision=micro or --time-stamp-precision=nano.
    -K
    --dont-verify-checksums
        Don't attempt to verify IP, TCP, or UDP checksums.
    -l
        Make stdout line buffered. Useful if you want to see the data while capturing it.
    -L
    --list-data-link-types
        List the known data link types for the interface, in the specified mode, and exit.
    --lengths
        Print the captured and original packet lengths.
    -m module
        Load SMI MIB module definitions from file module.
    -M secret
        Use secret as a shared secret for validating the digests found in TCP segments with the TCP-MD5 option (RFC 2385), if present.
    -n
        Don't convert addresses (i.e., host addresses, port numbers, etc.) to names.
    -N
        Don't print domain name qualification of host names.
    -#
    --number
        Print a packet number at the beginning of the line.
    -O
    --no-optimize
        Do not run the packet-matching code optimizer.
    -p
    --no-promiscuous-mode
        Don't put the interface into promiscuous mode.
    --print
        Print parsed packet output, even if the raw packets are being saved to a file with the -w flag.
    --print-sampling=nth
        Print every nth packet.
    -Q direction
    --direction=direction
        Choose send/receive direction direction for which packets should be captured.
    -q
        Quick output. Print less protocol information so output lines are shorter.
    -r file
        Read packets from file (which was created with the -w option or by other tools that write pcap or pcapng files).
    -S
    --absolute-tcp-sequence-numbers
        Print absolute, rather than relative, TCP sequence numbers.
    -s snaplen
    --snapshot-length=snaplen
        Snarf snaplen bytes of data from each packet rather than the default of 262144 bytes.
    --skip count
        Skip count packets before writing or printing.
    -T type
        Force packets selected by "expression" to be interpreted the specified type.
    -t
        Don't print a timestamp on each dump line.
    -tt
        Print the timestamp, as seconds since January 1, 1970, 00:00:00, UTC.
    -ttt
        Print a delta (microsecond or nanosecond resolution depending on the --time-stamp-precision option) between current and previous line.
    -tttt
        Print a timestamp, as hours, minutes, seconds, and fractions of a second since midnight, preceded by the date.
    -ttttt
        Print a delta (microsecond or nanosecond resolution depending on the --time-stamp-precision option) between current and first line.
    -u
        Print undecoded NFS handles.
    -U
    --packet-buffered
        Make the printed packet output "packet-buffered".
    -v
        Produce verbose output.
    -vv
        Even more verbose output.
    -vvv
        Even more verbose output.
    -V file
        Read a list of filenames from file.
    -w file
        Write the raw packets to file rather than parsing and printing them out.
    -W filecount
        Used in conjunction with the -C option, this will limit the number of files created to the specified number.
    -x
        Print the data of each packet (minus its link level header) in hex.
    -xx
        Print the data of each packet, including its link level header, in hex.
    -X
        Print the data of each packet (minus its link level header) in hex and ASCII.
    -XX
        Print the data of each packet, including its link level header, in hex and ASCII.
    -y datalinktype
    --linktype=datalinktype
        Set the data link type to use while capturing packets.
    -z postrotate-command
        Used in conjunction with the -C or -G options, this will make tcpdump run "postrotate-command file".
    -Z user
    --relinquish-privileges=user
        Change the user ID to user and the group ID to the primary group of user.
    expression
        Selects which packets will be dumped. If no expression is given, all packets on the net will be dumped.

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

EXAMPLES
    ...

OUTPUT FORMAT
    ...

NOTES
    tcpdump requires root or administrator privileges to capture packets on most systems. Use with caution, as it can capture sensitive data.

    For more information, refer to the official tcpdump documentation at https://www.tcpdump.org.

SEE ALSO
    stty(1), pcap(3PCAP), pcap-savefile(5), pcap-filter(7), pcap-tstamp(7)
    https://www.iana.org/assignments/media-types/application/vnd.tcpdump.pcap

AUTHORS
    The original authors are:
    Van Jacobson, Craig Leres and Steven McCanne, all of the Lawrence Berkeley National Laboratory, University of California, Berkeley, CA.

    It is currently maintained by The Tcpdump Group.

    The current version is available via HTTPS:
    https://www.tcpdump.org/

    The original distribution is available via anonymous FTP:
    ftp://ftp.ee.lbl.gov/old/tcpdump.tar.Z

    IPv6/IPsec support is added by WIDE/KAME project. This program uses OpenSSL/LibreSSL, under specific configurations.
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
