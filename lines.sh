#!/bin/bash

#Function for checking command line arguments
function check_options() {
    case "$1" in
        -h | --help)
            print_help
            exit 0
            ;;
        *)
            check_args $*
            ;;
    esac
}

#Function for checking args for textfile
function check_args() {
    if [ "$#" -lt 1 ]; then
        print_help
        exit 1
    fi
    is_exist $1
}

#Function for checking if file exists
function is_exist() {
    if [ ! -f "$1" ]; then
        echo "This text file does not exist";
        exit 1
    fi
}

#Function for printing help for user
function print_help() {
    echo "Usage: ./stat.sh <text file> | bash stat.sh <text file>"
}

#Main function where we getting stats
function main() {
    check_options $*
    #Source textfile
    local filename=$1
    #Getting amount of lines with command "wc -l"
    local line_count=$(wc -l < "$filename")
    echo "Amount of lines: $line_count"

    #Getting unique lines from the file
    local unique_lines=$(sort "$filename" | uniq -u)
    local unique_line_count=$(echo "$unique_lines" | wc -l)
    echo "Amount of uniq lines: $unique_line_count"

    #Data for length of the longest and the shortest lines
    local longest_line_length=0
    local shortest_line_length=100000
    
        #While not EOF
    while IFS= read -r line; do
        #Getting line of current line
        local line_length=${#line}

        #Checking if current line is the longest
        if (( "$line_length" > "$longest_line_length" )); then
            longest_line_length=$line_length
        fi

        #Checking if current line is the shortest
        if (( "$line_length" < "$shortest_line_length" )); then
            shortest_line_length=$line_length
        fi
    done < "$filename"

    echo "Length of the longest line: $longest_line_length"
    echo "Length of the shortest line: $shortest_line_length"
}

#Start of the program
main $*
