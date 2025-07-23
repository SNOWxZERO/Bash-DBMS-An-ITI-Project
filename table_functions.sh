#!/bin/bash
shopt -s extglob

add_column() {
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
    echo "$column_name:$column_type_name" >> "$DB_ROOT/$db_name/$table_name.meta"
}

create_table() {
    echo "Creating a new table ..."
    echo ""
    read -p "Enter table name: " table_name
    echo ""
    if [[ "$table_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]];
    then

        if [[ -e "$DB_ROOT/$db_name/$table_name.meta" || -e "$DB_ROOT/$db_name/$table_name.data" ]];
        then
            echo "Table already exists."
        else
            touch "$DB_ROOT/$db_name/$table_name.meta" "$DB_ROOT/$db_name/$table_name.data"
            echo ""
            read -p "Enter the number of columns: " no_columns
            echo ""
            i=1
            while ((i<=no_columns))
            do
                add_column
                ((i++))
            done
            echo "Table '$table_name' created successfully!"
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
    if [[ -f "$DB_ROOT/$db_name/$table_name.data" ]]
    then
        read -p "Are you sure you want to drop the table '$table_name'? This will delete all data. (y/n): " confirm
        if [[ $confirm == "y" ]]
        then
            rm -f "$DB_ROOT/$db_name/$table_name.data" "$DB_ROOT/$db_name/$table_name.meta"
            echo "Table '$table_name' dropped successfully."
        else
            echo "Deletion cancelled."
        fi
    else
        echo "Table not found."
    fi
}



update_table_meta() {
    echo "Updating table metadata..."
    echo ""
    list_tables
    echo ""

    read -p "Enter table number to update: " table_num
    table_name=$(ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | sed -n "${table_num}p")
    meta_file="$DB_ROOT/$db_name/$table_name.meta"

    if [[ ! -f "$meta_file" ]]; then
        echo "❌ Table '$table_name' does not exist."
        return
    fi

    while true; do
        echo ""
        echo "Current metadata for '$table_name':"
        echo "----------------------------------"
        nl -w2 -s'. ' "$meta_file"

        echo ""
        echo "Choose an option:"
        echo "1. Modify a column"
        echo "2. Add a new column"
        echo "3. Delete a column"
        echo "4. Back to Table Menu"
        read -p "Enter choice: " choice

        case "$choice" in
            1)
                read -p "Enter column number to modify: " col_num
                old_column=$(sed -n "${col_num}p" "$meta_file")

                if [[ -z "$old_column" ]]
                then
                    echo "❌ Invalid column number."
                    continue
                fi



                echo "Current column: $old_column"
                
                read -p "Enter new column name: " new_name
                read -p "Enter new column type (int/string): " new_type

                if [[ "$old_type" == "string" && "$new_type" == "int" ]]; then
                    echo "❌ Cannot change type from string to int."
                    continue
                fi

                new_column="$new_name:$new_type"

                # Use sed to replace the line in-place
                sed -i "${col_num}s/.*/$new_column/" "$meta_file"
                echo "✅ Column updated successfully."
                ;;

            2)
                add_column
                echo "✅ Column added successfully."
                ;;

            3)
                read -p "Enter column number to delete: " del_num

                if ! sed -n "${del_num}p" "$meta_file" >/dev/null; then
                    echo "❌ Invalid column number."
                    continue
                fi

                # Use sed to delete the line in-place
                sed -i "${del_num}d" "$meta_file"
                echo "✅ Column deleted successfully."
                ;;

            4)
                echo "Exiting Table metadata updater..."
                break
                ;;

            *)
                echo "❌ Invalid option."
                ;;
        esac
    done
}
