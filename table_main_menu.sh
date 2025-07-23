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
        CenteredPrint "|    2. Update Table Meta    |"
        CenteredPrint "|    3. List Tables          |"
        CenteredPrint "|    4. Drop Table           |"
        CenteredPrint "|    5. Insert into Table    |"
        CenteredPrint "|    6. Select from Table    |"
        CenteredPrint "|    7. Delete from Table    |"
        CenteredPrint "|    8. Back to Main Menu    |"
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
            2) update_table_meta
            echo ""
            read -p "Press Enter to continue..."
            ;;
            3) list_tables
            echo ""
            read -p "Press Enter to continue..."
            ;;
            4) drop_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            5) insert_into_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            6) select_from_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            7) delete_from_table
            echo ""
            read -p "Press Enter to continue..."
            ;;
            8) CenteredPrint "Returning to Main Menu..."
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
