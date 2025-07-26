#!/bin/bash

source ./tb_functions.sh

create_database() {
    CenteredPrint "|| Creating a new database... ||"
    echo ""
    read -p "Please enter database name: " db_name
    echo ""

    if  [[ -z "$db_name" ]]
    then
        CenteredPrint "(x_x) Database name cannot be empty (x_x)"
    elif [[ ! "$db_name" =~ $valid_string ]]
    then
        CenteredPrint "(x_x) Invalid database name. Must start with a letter and contain only letters, digits, or underscores (x_x)"
    
    elif [[ -d "$DB_ROOT/$db_name" ]]
    then
        CenteredPrint "(x_x) Database '$db_name' already exists (x_x)"
    else
        mkdir "$DB_ROOT/$db_name"
        CenteredPrint "(ﾉ◕ヮ◕)ﾉ Database '$db_name' was created successfully (ﾉ◕ヮ◕)ﾉ"
    fi
}

list_databases() {
    clear
    printf "%*s\n" "$width" | tr ' ' '=' 
    echo ""

    echo "Listing Available Databases: ..."
    echo ""
    CenteredPrint "||====== Available Databases ======||"
    echo ""
    padding_length=$(( ($width - 29) / 2 ))
    ls -1 "$DB_ROOT" | cut -c1-29 | nl -w"$padding_length" -s'. '
    echo ""
    CenteredPrint "||=================================||"
}

connect_database() {
    echo "Connecting to a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Connect: " db_num
    echo ""
    
    if [[ ! "$db_num" =~ ^[0-9]+$ ]] || (( db_num < 1 ))
    then
        CenteredPrint "(x_x) Invalid input. Please enter a valid number (x_x)"
        return
    fi

    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")
    

    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        
        source ./table_main_menu.sh
        table_main_menu

    else
        CenteredPrint "(x_x) Database '$db_name' does not exist (x_x)"
    fi
}

drop_database() {
    echo "Dropping a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Drop: " db_num

    if [[ ! "$db_num" =~ ^[0-9]+$ ]] || (( db_num < 1 ))
    then
        CenteredPrint "(x_x) Invalid input. Please enter a valid number (x_x)"
        return
    fi
    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")
    echo ""
    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        read -p "Are you sure? (╥﹏╥) This will delete all the data in '$db_name' Database. (y/n): " confirm
        echo ""
        if [[ $confirm == "y" ]]
        then
            rm -r "$DB_ROOT/$db_name"
            CenteredPrint "(✖╭╮✖) Database << $db_name >> deleted Succesfully (✖╭╮✖)"
        else
            CenteredPrint "Deleting Cancelled. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
        fi

    else
        CenteredPrint "(x_x) Database not found (x_x)"
    fi
}
