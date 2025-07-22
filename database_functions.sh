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

    elif [[ -d "$DB_ROOT/$db_name" ]]
    then
        CenteredPrint "(x_x) Database already exists (x_x)"
    
    else
        mkdir "$DB_ROOT/$db_name"
        CenteredPrint "(ﾉ◕ヮ◕)ﾉ Database '$db_name' was created successfully (ﾉ◕ヮ◕)ﾉ"
    fi
}

list_databases() {
    echo "Listing Available Databases: ..."
    echo ""
    CenteredPrint "||====== Available Databases ======||"
    padding_length=$(( ($width - 29) / 2 ))
    ls -1 "$DB_ROOT" | cut -c1-29 | nl -w"$padding_length" -s'. '
    CenteredPrint "||=================================||"
}

connect_database() {
    echo "Connecting to a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Connect: " db_num
    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")
    echo ""

    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        
        source ./table_main_menu.sh
        table_main_menu


       

    else
        echo "(x_x) Database '$db_name' does not exist (x_x)"
    fi
}

drop_database() {
    echo "Dropping a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Drop: " db_num
    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")
    echo ""
    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        read -p "Are you sure? (╥﹏╥) This will delete all the data in '$db_name'. (y/n): " confirm
        echo ""
        if [[ $confirm == "y" ]]; then
            rm -r "$DB_ROOT/$db_name"
            CenteredPrint "(✖╭╮✖) Database << $db_name >> deleted Succesfully (✖╭╮✖)"
        else
            echo "Deleting Cancelled. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
        fi

    else
        echo "(x_x) Database not found (x_x)"
    fi
}
