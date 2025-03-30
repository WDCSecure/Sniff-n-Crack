# Hashcat

# Manual

```
HASHCAT
Advanced CPU-based password recovery utility

SYNOPSIS
    hashcat [options] hashfile [mask|wordfiles|directories]

DESCRIPTION
    Hashcat is the world’s fastest CPU-based password recovery tool.  
    While it's not as fast as its GPU counterpart oclHashcat, large lists can be easily split in half with a good dictionary and a bit of knowledge of the command switches.

    Hashcat is the self-proclaimed world’s fastest CPU-based password recovery tool. Examples of hashcat supported hashing algorithms are Microsoft LM Hashes, MD4, MD5, SHA-family, Unix Crypt formats, MySQL, Cisco PIX.

OPTIONS
    -h, --help  
        Show summary of options.  
    -V, --version  
        Show version of program.  
    -m, --hash-type=NUM  
        Hash-type, see references below  
    -a, --attack-mode=NUM  
        Attack-mode, see references below  
    --quiet  
        Suppress output  
    -b, --benchmark  
        Run benchmark  
    --hex-salt  
        Assume salt is given in hex  
    --hex-charset  
        Assume charset is given in hex  
    --runtime=NUM  
        Abort session after NUM seconds of runtime  
    --status  
        Enable automatic update of the status-screen  
    --status-timer=NUM  
        Seconds between status-screen update  
    --status-automat  
        Display the status view in a machine-readable format  
    -o, --outfile=FILE  
        Define outfile for recovered hash  
    --outfile-format=NUM  
        Define outfile-format for recovered hash, see references below  
    --outfile-autohex-disable  
        Disable the use of $HEX[] in output plains  
    -p, --separator=CHAR  
        Define separator char for hashlists/outfile  
    --show  
        Show cracked passwords only (see --username)  
    --left  
        Show uncracked passwords only (see --username)  
    --username  
        Enable ignoring of usernames in hashfile (Recommended: also use --show)  
    --remove  
        Enable remove of hash once it is cracked  
    --stdout  
        Stdout mode  
    --potfile-disable  
        Do not write potfile  
    --debug-mode=NUM  
        Defines the debug mode (hybrid only by using rules), see references below  
    --debug-file=FILE  
        Output file for debugging rules (see --debug-mode)  
    -e, --salt-file=FILE  
        Salts-file for unsalted hashlists  
    -c, --segment-size=NUM  
        Size in MB to cache from the wordfile  
    -n, --threads=NUM  
        Number of threads  
    -s, --words-skip=NUM  
        Skip number of words (for resume)  
    -l, --words-limit=NUM  
        Limit number of words (for distributed)  
    -r, --rules-file=FILE  
        Rules-file use: -r 1.rule  
    -g, --generate-rules=NUM  
        Generate NUM random rules  
    --generate-rules-func-min=NUM  
        Force NUM functions per random rule min  
    --generate-rules-func-max=NUM  
        Force NUM functions per random rule max  
    --generate-rules-seed=NUM  
        Force RNG seed to NUM  
    -1, --custom-charset1=CS  
        User-defined charsets example --custom-charset1=?dabcdef : sets charset ?1 to 0123456789abcdef -2 mycharset.hcchr : sets charset ?2 to chars contained in file  
    -2, --custom-charset2=CS  
        User-defined charsets example --custom-charset1=?dabcdef : sets charset ?1 to 0123456789abcdef -2 mycharset.hcchr : sets charset ?2 to chars con$  
    --toogle-min=NUM  
        Number of alphas in dictionary minimum  
    --toogle-max=NUM  
        Number of alphas in dictionary maximum  

    Mass-attack options:
        --increment  
            Enable increment mode  
        --increment-min=NUM  
            Start incrementing at NUM  
        --increment-max=NUM  
            Stop incrementing at NUM  

    Permutation attack-mode options:
        --perm-min=NUM  
            Filter words shorter than NUM  
        --perm-max=NUM  
            Filter words larger than NUM  

    Table-Lookup attack-mode options:
        -t, --table-file=FILE  
            Table file  
        --table-min=NUM  
            Number of chars in dictionary minimum  
        --table-max=NUM  
            Number of chars in dictionary maximum  

    Prince attack-mode options:
        --pw-min=NUM  
            Print candidate if length is greater than NUM  
        --pw-max=NUM  
            Print candidate if length is smaller than NUM  
        --element-cnt-min=NUM  
            Minimum number of elements per chain  
        --element-cnt-max=NUM  
            Maximum number of elements per chain  
        --wl-dist-len  
            Calculate output length distribution from wordlist  
        --wl-max=NUM  
            Load only NUM words from input wordlist or use 0 to disable  
        --case-permute=NUM  
            For each word in the wordlist that begins with a letter generate a word with the opposite case of the first letter  

    Outfile formats:
        1 = hash[:salt]  
        2 = plain  
        3 = hash[:salt]:plain  
        4 = hex_plain  
        5 = hash[:salt]:hex_plain  
        6 = plain:hex_plain  
        7 = hash[:salt]:plain:hex_plain  
        8 = crackpos  
        9 = hash[:salt]:crackpos  
        10 = plain:crackpos  
        11 = hash[:salt]:plain:crackpos  
        12 = hex_plain:crackpos  
        13 = hash[:salt]:hex_plain:crackpos  
        14 = plain:hex_plain:crackpos  
        15 = hash[:salt]:plain:hex_plain:crackpos  

    Debug mode output formats (for hybrid mode only, by using rules):
        1 = save finding rule  
        2 = save original word  
        3 = save original word and finding rule  
        4 = save original word, finding rule and modified plain  

    Built-in charsets:
        ?l = abcdefghijklmnopqrstuvwxyz  
        ?u = ABCDEFGHIJKLMNOPQRSTUVWXYZ  
        ?d = 0123456789  
        ?s = !"#$%&'()*+,-./:;<=>?@[]^_`{|}~  
        ?a = ?l?u?d?s  
        ?b = 0x00 - 0xff  

    Attack mode:
        0 = Straight  
        1 = Combination  
        2 = Toggle-Case  
        3 = Brute-force  
        4 = Permutation  
        5 = Table-Lookup  
        8 = Prince  

    Hash types:
        ...existing hash types list...

AUTHOR
    hashcat was written by Jens Steube <jens.steube@gmail.com>  
    This manual page was written by Daniel Echeverry <epsilon77@gmail.com>, for the Debian project (and may be used by others).
```
