# tshark

# Manual

```
TSHARK
    Dump and analyze network traffic

SYNOPSIS
    tshark [ -2 ] [ -a <capture autostop condition> ] ... [ -b <capture ring buffer option>] ... [ -B <capture buffer size> ]  
           [ -c <capture packet count> ] [ -C <configuration profile> ] [ -d <layer type>==<selector>,<decode-as protocol> ] 
           [ -D ] [ -e <field> ] [ -E <field print option> ] [ -f <capture filter> ] [ -F <file format> ] [ -g ] [ -h ] 
           [ -H <input hosts file> ] [ -i <capture interface>|- ] [ -I ] [ -K <keytab> ] [ -l ] [ -L ] [ -n ] 
           [ -N <name resolving flags> ] [ -o <preference setting> ] ... [ -O <protocols> ] [ -p ] [ -P ] [ -q ] [ -Q ] 
           [ -r <infile> ] [ -R <Read filter> ] [ -s <capture snaplen> ] [ -S <separator> ] 
           [ -t a|ad|adoy|d|dd|e|r|u|ud|udoy ] [ -T fields|pdml|ps|psml|text ] [ -u <seconds type>] [ -v ] [ -V ] 
           [ -w <outfile>|- ] [ -W <file format option>] [ -x ] [ -X <eXtension option>] [ -y <capture link type> ] 
           [ -Y <displaY filter> ] [ -z <statistics> ] [ --capture-comment <comment> ] [ <capture filter> ]

DESCRIPTION
    TShark is a network protocol analyzer. It lets you capture packet data from a live network, or read packets from a previously saved capture file, 
    either printing a decoded form of those packets to the standard output or writing the packets to a file. TShark's native capture file format is 
    pcap format, which is also the format used by tcpdump and various other tools.

    ...existing description...

OPTIONS
    -2
        Perform a two-pass analysis. This causes tshark to buffer output until the entire first pass is done, but allows it to fill in fields that 
        require future knowledge, such as 'response in frame #' fields. Also permits reassembly frame dependencies to be calculated correctly.
    -a <capture autostop condition>
        Specify a criterion that specifies when TShark is to stop writing to a capture file. The criterion is of the form test:value, where test is one of:
            duration:value Stop writing to a capture file after value seconds have elapsed.
            filesize:value Stop writing to a capture file after it reaches a size of value kB.
            files:value Stop writing to capture files after value number of files were written.
    -b <capture ring buffer option>
        Cause TShark to run in "multiple files" mode. In "multiple files" mode, TShark will write to several capture files. When the first capture file 
        fills up, TShark will switch writing to the next file and so on.
        ...existing details...
    -B <capture buffer size>
        Set capture buffer size (in MiB, default is 2 MiB). This is used by the capture driver to buffer packet data until that data can be written to disk.
    -c <capture packet count>
        Set the maximum number of packets to read when capturing live data. If reading a capture file, set the maximum number of packets to read.
    -C <configuration profile>
        Run with the given configuration profile.
    -d <layer type>==<selector>,<decode-as protocol>
        Like Wireshark's Decode As... feature, this lets you specify how a layer type should be dissected.
        Example: -d tcp.port==8888,http will decode any traffic running over TCP port 8888 as HTTP.
    -D
        Print a list of the interfaces on which TShark can capture, and exit.
    -e <field>
        Add a field to the list of fields to display if -T fields is selected.
    -E <field print option>
        Set an option controlling the printing of fields when -T fields is selected.
    -f <capture filter>
        Set the capture filter expression.
    -F <file format>
        Set the file format of the output capture file written using the -w option.
    -g
        This option causes the output file(s) to be created with group-read permission.
    -G [column-formats|currentprefs|decodes|defaultprefs|fields|ftypes|heuristic-decodes|plugins|protocols|values]
        The -G option will cause Tshark to dump one of several types of glossaries and then exit.
    -h
        Print the version and options and exits.
    -H <input hosts file>
        Read a list of entries from a "hosts" file, which will then be written to a capture file.
    -i <capture interface> | -
        Set the name of the network interface or pipe to use for live packet capture.
    -I
        Put the interface in "monitor mode"; this is supported only on IEEE 802.11 Wi-Fi interfaces.
    -K <keytab>
        Load kerberos crypto keys from the specified keytab file.
    -l
        Flush the standard output after the information for each packet is printed.
    -L
        List the data link types supported by the interface and exit.
    -n
        Disable network object name resolution.
    -N <name resolving flags>
        Turn on name resolving only for particular types of addresses and port numbers.
    -o <preference>:<value>
        Set a preference value, overriding the default value and any value read from a preference file.
    -O <protocols>
        Similar to the -V option, but causes TShark to only show a detailed view of the comma-separated list of protocols specified.
    -p
        Don't put the interface into promiscuous mode.
    -P
        Decode and display the packet summary, even if writing raw packet data using the -w option.
    -q
        When capturing packets, don't display the continuous count of packets captured.
    -Q
        When capturing packets, only display true errors.
    -r <infile>
        Read packet data from infile, can be any supported capture file format.
    -R <Read filter>
        Cause the specified filter to be applied during the first pass of analysis.
    -s <capture snaplen>
        Set the default snapshot length to use when capturing live data.
    -S <separator>
        Set the line separator to be printed between packets.
    -t a|ad|adoy|d|dd|e|r|u|ud|udoy
        Set the format of the packet timestamp printed in summary lines.
    -T fields|pdml|ps|psml|text
        Set the format of the output when viewing decoded packet data.
    -u <seconds type>
        Specifies the seconds type. Valid choices are: s for seconds, hms for hours, minutes and seconds.
    -v
        Print the version and exit.
    -V
        Cause TShark to print a view of the packet details.
    -w <outfile> | -
        Write raw packet data to outfile or to the standard output if outfile is '-'.
    -W <file format option>
        Save extra information in the file if the format supports it.
    -x
        Cause TShark to print a hex and ASCII dump of the packet data after printing the summary and/or details.
    -X <eXtension options>
        Specify an option to be passed to a TShark module.
    -y <capture link type>
        Set the data link type to use while capturing packets.
    -Y <displaY filter>
        Cause the specified filter to be applied before printing a decoded form of packets or writing packets to a file.
    -z <statistics>
        Get TShark to collect various types of statistics and display the result after finishing reading the capture file.
    --capture-comment <comment>
        Add a capture comment to the output file.

SEE ALSO
    ...existing references...

AUTHORS
    TShark uses the same packet dissection code that Wireshark does, as well as using many other modules from Wireshark; see the list of authors in the Wireshark man page for a list of authors of that code.
```
