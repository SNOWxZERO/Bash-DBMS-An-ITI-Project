#!/bin/bash

DB_ROOT="./DataBases"
mkdir -p "$DB_ROOT"
source ./db_functions.sh

main_menu() {
    clear
    while true
    do
        echo "Please select an option:"
        echo ""
        echo ":.:.:.:.: Main Menu :.:.:.:.:"
        echo "|                           |"
        echo "|  1. Create Database       |"
        echo "|  2. List Databases        |"
        echo "|  3. Connect To Database   |"
        echo "|  4. Drop Database         |"
        echo "|  5. Exit                  |"
        echo "|                           |"
        echo "============================="
        read -p "Enter your choice: " choice
        clear
        echo "You selected option $choice"
        case $choice in
            1) create_database 
            ;;
            2) list_databases 
            read -p "Press Enter to continue..."
            ;;
            3) connect_database 
            ;;
            4) drop_database 
            ;;
            5) echo "CY@!"; 
            exit 0 
            ;;
            *) echo "Invalid choice, please try again." ;;
        esac
    done
}

main_menu