#!/bin/bash

create_database() {
    echo "Creating a new database..."
    echo ""
    read -p "Enter database name: " db_name
    echo ""
    
    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        echo "Database already exists."
    else
        mkdir "$DB_ROOT/$db_name"
        echo "Database '$db_name' was created successfully."
    fi
}

list_databases() {
    echo "Listing Available Databases: ..."
    ls -1 "$DB_ROOT" | nl
}

connect_database() {
    echo "Connecting to a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Connect: " db_num
    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")

    if [[ -d "$DB_ROOT/$db_name" ]]
    then
        echo "Connected to '$db_name'"
        # We Will Implement Database Operations Here :D
    else
        echo "Database '$db_name' does not exist."
    fi
}

drop_database() {
    echo "Dropping a database..."
    echo ""
    list_databases
    echo ""

    read -p "Enter database number to Drop: " db_num
    db_name=$(ls -1 "$DB_ROOT" | sed -n "${db_num}p")

    if [[ -d "$DB_ROOT/$db_name" ]]
    then

        read -p "Are you sure? This will delete all the data in the Database. (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            rm -r "$DB_ROOT/$db_name"
            echo "Database '$db_name' deleted."
        else
            echo "Deleting Cancelled."
        fi

    else
        echo "Database not found."
    fi
}
