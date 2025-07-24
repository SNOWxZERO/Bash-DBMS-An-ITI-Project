#!/bin/bash

DB_ROOT="./DataBases"
mkdir -p "$DB_ROOT"
source ./database_functions.sh
valid_string="^[a-zA-Z][a-zA-Z0-9_]*$"

CenteredPrint() {
    local text="$1"
    local text_length=${#text}

    if (( text_length > width ))
    then
        text="${text:0:width-3}..."
        text_length=${#text}
    fi
    
    local padding=$(( (width - text_length) / 2 ))
    printf "%*s%s\n" "$padding" "" "$text"
}

DBMS_main_menu() {

    while true
    do
        width=$(tput cols)
        clear

        printf "%*s\n" "$width" | tr ' ' '='
        CenteredPrint "==============================================="
        CenteredPrint "|| Welcome to the Database Management System ||"
        CenteredPrint "==============================================="
        echo ""
        CenteredPrint "Please select an option:"
        echo ""
        CenteredPrint ":.:.:.:.: Main Menu :.:.:.:.:"
        CenteredPrint "|                           |"
        CenteredPrint "|  1. Create Database       |"
        CenteredPrint "|  2. List Databases        |"
        CenteredPrint "|  3. Connect To Database   |"
        CenteredPrint "|  4. Drop Database         |"
        CenteredPrint "|  5. Exit                  |"
        CenteredPrint "|                           |"
        CenteredPrint "============================="
        echo "" 
        read -p "Enter your choice: " choice
        echo ""
        
        case $choice in
            1) create_database
            echo ""
            read -p "Press Enter to continue..." 
            ;;
            2) list_databases 
            echo ""
            read -p "Press Enter to continue..."
            ;;
            3) connect_database
            echo "" 
            read -p "Press Enter to continue..."
            ;;
            4) drop_database
            echo ""
            read -p "Press Enter to continue..." 
            ;;
            5) 
            CenteredPrint "  ==========================================================================="
            CenteredPrint "|| Hope you enjoyed using the Database Management System! (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ ||"
            CenteredPrint "  ==========================================================================="


            CenteredPrint "|| Exiting... (╯°□°）╯︵ ┻━┻ ||"

            printf "%*s\n" "$width" | tr ' ' '='
            exit 0 
            ;;
            *) CenteredPrint "Invalid choice, please try again."
            echo "" 
            read -p "Press Enter to continue..."
            ;;
        esac
    done
}

DBMS_main_menu