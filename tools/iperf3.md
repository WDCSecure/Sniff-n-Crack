# iPerf3

## Manual

```
IPERF3
Perform network throughput tests

SYNOPSIS
    iperf3 -s [ options ]
    iperf3 -c server [ options ]

DESCRIPTION
    iperf3 is a tool for performing network throughput measurements. It can test either TCP or UDP throughput. To perform an iperf3 test the user must establish both a server and a client.

GENERAL OPTIONS
    -p, --port n
        Set server port to listen on/connect to n (default 5201).
    -f, --format [kmKM]
        Format to report: Kbits, Mbits, KBytes, MBytes.
    -i, --interval n
        Pause n seconds between periodic bandwidth reports; default is 1, use 0 to disable.
    -F, --file name
        Client-side: read from the file and write to the network, instead of using random data; server-side: read from the network and write to the file, instead of throwing the data away.
    -A, --affinity n/n,m
        Set the CPU affinity, if possible (Linux and FreeBSD only). On both the client and server, you can set the local affinity by using the n form of this argument (where n is a CPU number). On the client side, you can override the server's affinity for just that one test using the n,m form of the argument.
    -B, --bind host
        Bind to a specific interface.
    -V, --verbose
        Give more detailed output.
    -J, --json
        Output in JSON format.
    --logfile file
        Send output to a log file.
    -d, --debug
        Emit debugging output. Primarily of use to developers.
    -v, --version
        Show version information and quit.
    -h, --help
        Show a help synopsis.

SERVER SPECIFIC OPTIONS
    -s, --server
        Run in server mode.
    -D, --daemon
        Run the server in the background as a daemon.
    -I, --pidfile file
        Write a file with the process ID, most useful when running as a daemon.
    -1, --one-off
        Handle one client connection, then exit.

CLIENT SPECIFIC OPTIONS
    -c, --client host
        Run in client mode, connecting to the specified server.
    --sctp
        Use SCTP rather than TCP (FreeBSD and Linux).
    -u, --udp
        Use UDP rather than TCP.
    -b, --bandwidth n[KM]
        Set target bandwidth to n bits/sec (default 1 Mbit/sec for UDP, unlimited for TCP). If there are multiple streams (-P flag), the bandwidth limit is applied separately to each stream.
    --no-fq-socket-pacing
        Disable the use of fair-queueing based socket-level pacing with the -b option, and rely on iperf3's internal rate control.
    -t, --time n
        Time in seconds to transmit for (default 10 secs).
    -n, --bytes n[KM]
        Number of bytes to transmit (instead of -t).
    -k, --blockcount n[KM]
        Number of blocks (packets) to transmit (instead of -t or -n).
    -l, --length n[KM]
        Length of buffer to read or write (default 128 KB for TCP, 8 KB for UDP).
    --cport port
        Bind data streams to a specific client port (for TCP and UDP only, default is to use an ephemeral port).
    -P, --parallel n
        Number of parallel client streams to run.
    -R, --reverse
        Run in reverse mode (server sends, client receives).
    -w, --window n[KM]
        Window size / socket buffer size (this gets sent to the server and used on that side too).
    -M, --set-mss n
        Set TCP/SCTP maximum segment size (MTU - 40 bytes).
    -N, --no-delay
        Set TCP/SCTP no delay, disabling Nagle's Algorithm.
    -4, --version4
        Only use IPv4.
    -6, --version6
        Only use IPv6.
    -S, --tos n
        Set the IP 'type of service'.
    -L, --flowlabel n
        Set the IPv6 flow label (currently only supported on Linux).
    -X, --xbind name
        Bind SCTP associations to a specific subset of links using sctp_bindx(3). The --B flag will be ignored if this flag is specified.
    --nstreams n
        Set number of SCTP streams.
    -Z, --zerocopy
        Use a "zero copy" method of sending data, such as sendfile(2), instead of the usual write(2).
    -O, --omit n
        Omit the first n seconds of the test, to skip past the TCP slow-start period.
    -T, --title str
        Prefix every output line with this string.
    -C, --congestion algo
        Set the congestion control algorithm (Linux and FreeBSD only).
    --get-server-output
        Get the output from the server. The output format is determined by the server.

AUTHORS
    A list of the contributors to iperf3 can be found within the documentation located at http://software.es.net/iperf/dev.html#authors.
```
