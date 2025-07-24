#!/bin/bash
shopt -s extglob


create_table() {
    echo "Creating a new table ..."
    echo ""
    read -p "Enter table name: " tl_name
    echo ""
    if [[ "$tl_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]];
    then

        if [[ -e "$DB_ROOT/$db_name/$tl_name.meta" || -e "$DB_ROOT/$db_name/$tl_name.data" ]];
        then
            echo "Table already exists."
        else
            touch "$DB_ROOT/$db_name/$tl_name.meta" "$DB_ROOT/$db_name/$tl_name.data"
            echo ""
            read -p "Enter the number of columns: " no_columns
            echo ""
            i=1
            while ((i<=no_columns))
            do
                while true
                do
                    echo ""
                    read -p "Enter column name: " column_name

                    if [[ "$column_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]]; then
                        echo "Valid column name"
                        break
                    else
                        echo "Invalid column name. Must start with a letter and contain only letters, digits, or underscores."
                    fi
                done
            
                while true;
                do
                    echo ""
                    read  -n1 -p "Enter column ($i) type (1- int -- 2- string): " colomn_type
                    # after getting valid column_name
                    # and right after case ends
                    case $colomn_type in
                    1)
                        column_type_name="int"
                        break
                        ;;
                    2)
                        column_type_name="string"
                        break
                        ;;
                    *)
                        echo "Invalid entry. Must be 1 or 2"
                        ;;
                    esac
                done
                    # Save column to meta file
                    echo "$column_name:$column_type_name" >> "$DB_ROOT/$db_name/$tl_name.meta"
                ((i++))
            done
            echo "Table '$tl_name' created successfully!"
        fi
    else
        echo "Invalid table name. Must start with a letter and contain only letters, digits, or underscores."
    fi    
}

list_tables() {
    echo "Listing Available Tables: ..."
    echo ""
    CenteredPrint "||====== Available Tables in ======||"
    padding_length=$(( ($width - 29) / 2 ))
    ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | cut -c1-29 | nl -w"$padding_length" -s'. '
    CenteredPrint "||=================================||"
}

drop_table() {
    echo "Drop a table..."
    echo ""
    list_tables
    echo ""

    read -p "Enter table number to drop: " table_num

    # Get table name from the numbered list
    table_name=$(ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | sed -n "${table_num}p")

    # Check if the table exists
    if [[ -f "$DB_ROOT/$db_name/$table_name.data" ]]; then
        read -p "Are you sure you want to drop the table '$table_name'? This will delete all data. (y/n): " confirm
        if [[ $confirm == "y" ]]; then
            rm -f "$DB_ROOT/$db_name/$table_name.data" "$DB_ROOT/$db_name/$table_name.meta"
            echo "Table '$table_name' dropped successfully."
        else
            echo "Deletion cancelled."
        fi
    else
        echo "Table not found."
    fi
}


insert_into_table(){
    echo "insert into table..."
    echo ""
    list_tables
    echo ""

    read -p "Enter table number to insert into: " table_num

    # Get table name from the numbered list
    table_name=$(ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | sed -n "${table_num}p")
    # Get columns types from meta file 
    table_columns=($(cut -d: -f2 "$DB_ROOT/$db_name/$table_name.meta"))
    while true;
    do
        read -n1 -p "Write 1 to insert ......... Write 2 to exit: " user_desire
        echo ""
            if [[ "$user_desire" == "1" ]]
            then
                insertion=""
                for type in "${table_columns[@]}"
                do
                    while true;
                    do
                        read -p "enter $type value: " value 
                        case $type in
                            "int")
                                    if [[ "$value" =~ ^[0-9]+$ ]]; then
                                        if [[ -z "$insertion" ]]; then
                                                insertion="$value"
                                        else
                                                insertion+=":$value"
                                        fi
                                        break
                                        
                                    else
                                        echo "❌ Not an integer.."
                                    fi
                                    ;;
                            "string")
                                    if [[ -n "$value" ]]; then
                                        if [[ -z "$insertion" ]]; then
                                                insertion="$value"
                                        else
                                                insertion+=":$value"
                                        fi
                                        break
                                    else
                                        echo "❌ No string.."
                                    fi
                                    ;;
                        esac
                    done
                done
            
                echo "$insertion">> "$DB_ROOT/$db_name/$table_name.data"
            elif [[ "$user_desire" == "2" ]]
            then
                echo "leaving insertions mood..."
                break  
            else
                echo "❌ Invalid entry. Please enter 1 or 2."
            fi
    done
}