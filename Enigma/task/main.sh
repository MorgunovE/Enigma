#!/usr/bin/env bash

echo "Welcome to the Enigma!"

# Define regular expressions
message_regex='^[A-Z ]+$'
filename_regex='^[A-Za-z\.]+$'

while true; do
    echo "0. Exit"
    echo "1. Create a file"
    echo "2. Read a file"
    echo "3. Encrypt a file"
    echo "4. Decrypt a file"
    echo "Enter an option:"
    read -r option

    case "$option" in
        0)
            echo "See you later!"
            exit 0
            ;;
        1)
            echo "Enter the filename:"
            read -r filename
            if [[ ! "$filename" =~ $filename_regex ]]; then
                echo "File name can contain letters and dots only!"
                continue
            fi
            echo "Enter a message:"
            read -r message
            if [[ ! "$message" =~ $message_regex ]]; then
                echo "This is not a valid message!"
                continue
            fi
            echo "$message" > "$filename"
            echo "The file was created successfully!"
            ;;
        2)
            echo "Enter the filename:"
            read -r filename
            if [[ ! -f "$filename" ]]; then
                echo "File not found!"
                continue
            fi
            echo "File content:"
            cat "$filename"
            ;;
        3)
            echo "Enter the filename:"
            read -r filename
            if [[ ! -f "$filename" ]]; then
                echo "File not found!"
                continue
            fi
            echo "Enter password:"
            read -r password
            output_filename="$filename.enc"
            openssl enc -aes-256-cbc -e -pbkdf2 -nosalt -in "$filename" -out "$output_filename" -pass pass:"$password" &>/dev/null
            exit_code=$?
            if [[ $exit_code -ne 0 ]]; then
                echo "Fail"
            else
                rm "$filename"
                echo "Success"
            fi
            ;;
        4)
            echo "Enter the filename:"
            read -r filename
            if [[ ! -f "$filename" ]]; then
                echo "File not found!"
                continue
            fi
            echo "Enter password:"
            read -r password
            output_filename="${filename%.enc}"
            openssl enc -aes-256-cbc -d -pbkdf2 -nosalt -in "$filename" -out "$output_filename" -pass pass:"$password" &>/dev/null
            exit_code=$?
            if [[ $exit_code -ne 0 ]]; then
                echo "Fail"
            else
                rm "$filename"
                echo "Success"
            fi
            ;;
        *)
            echo "Invalid option!"
            ;;
    esac
    echo ""
done