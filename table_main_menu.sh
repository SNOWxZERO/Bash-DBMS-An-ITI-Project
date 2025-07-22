source ./table_functions.sh

table_main_menu() {
    while true
    do
        width=$(tput cols)
        clear

        printf "%*s\n" "$width" | tr ' ' '='
        CenteredPrint "|== Connected to '$db_name' DataBase (ﾉ◕ヮ◕)ﾉ ==|"
        CenteredPrint "==========================================="
        CenteredPrint "||         Table Management Menu         ||"
        CenteredPrint "==========================================="
        echo ""
        CenteredPrint "Please select an option:"
        echo ""
        CenteredPrint ":.:.:.:.: Table Menu :.:.:.:.:"
        CenteredPrint "|                            |"
        CenteredPrint "|    1. Create Table         |"
        CenteredPrint "|    2. List Tables          |"
        CenteredPrint "|    3. Drop Table           |"
        CenteredPrint "|    4. Insert into Table    |"
        CenteredPrint "|    5. Select from Table    |"
        CenteredPrint "|    6. Delete from Table    |"
        CenteredPrint "|    7. Back to Main Menu    |"
        CenteredPrint "|                            |"
        CenteredPrint "=============================="
        echo "" 
        read -p "Enter your choice: " choice
        echo ""
        
        case $choice in
            1) create_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            2) list_tables
            echo ""
            read -p "Press Enter to continue..."
            ;;
            3) drop_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            4) insert_into_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            5) select_from_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            6) delete_from_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            7) CenteredPrint "Returning to Main Menu..."
            echo ""
            CenteredPrint " ======================================"
            CenteredPrint "|| Exiting '$db_name'... (╯°□°）╯︵ ┻━┻ ||"
            printf "%*s\n" "$width" | tr ' ' '='
            break 
            ;;
            *) CenteredPrint "Invalid choice, please try again. "
               echo "" 
               read -p "Press Enter to continue..."
               ;;
        esac
    done
}
