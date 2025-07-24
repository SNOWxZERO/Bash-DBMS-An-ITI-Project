#!/bin/bash
shopt -s extglob

add_column() {
    while true
    do

        echo ""
        read -p "Enter column name: " column_name

        if grep -q "^$column_name:" "$meta_file"
        then
            CenteredPrint "(x_x) Column '$column_name' already exists (x_x)"
            continue
        fi

        if [[ "$column_name" =~ $valid_string ]]
        then
            break
        else
            CenteredPrint "Name must start with a letter and contain only letters, digits, or underscores."
        fi
    done

    while true;
    do
        echo ""
    read -p "Enter column type ( 1 -> int | 2 -> string ): " colomn_type

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
    # Check if PK already exists
    if grep -q ':PK$' "$meta_file"
    then
        has_pk=true
    else
        has_pk=false
    fi

    is_pk=""
    if [[ "$has_pk" == false ]]
    then
        read -p "Do you want to make this the primary key? (y/n): " make_pk
        if [[ "$make_pk" == "y" || "$make_pk" == "Y" ]]
        then
            is_pk=":PK"
        fi
    fi

    echo "$column_name:$column_type_name$is_pk" >> "$DB_ROOT/$db_name/$table_name.meta"
    echo ""
    CenteredPrint "(ﾉ◕ヮ◕)ﾉ Column '$column_name' of type '$column_type_name$is_pk' added successfully. (ﾉ◕ヮ◕)ﾉ"
    echo ""
    read -p "Press Enter to continue..."
    echo ""
}

list_columns() {
    clear
    printf "%*s\n" "$width" | tr ' ' '=' 
    echo ""
    echo "Listing Columns in '$table_name': ..."
    echo ""

    CenteredPrint "||======== Current Columns ========||"
    echo ""
    padding_length=$(( ($width - 29) / 2 ))
    meta_file="$DB_ROOT/$db_name/$table_name.meta"
    nl -w"$padding_length" -s'. ' "$meta_file"
    echo ""
    CenteredPrint "||=================================||"


}

create_table() {
    echo "Creating a new table ..."
    echo ""
    read -p "Enter table name: " table_name
    echo ""
    meta_file="$DB_ROOT/$db_name/$table_name.meta"
    data_file="$DB_ROOT/$db_name/$table_name.data"
    if [[ "$table_name" =~ $valid_string ]];
    then
        if [[ -e "$meta_file" || -e "$data_file" ]];
        then
            CenteredPrint "(x_x) Table already exists. (x_x)"
        else
            touch "$meta_file" "$data_file"
            read -p "Enter the number of columns: " no_columns
            if ! [[ "$no_columns" =~ ^[0-9]+$ ]] || (( no_columns <= 0 ))
            then
                CenteredPrint "(x_x) Invalid number of columns. Must be a positive integer. (x_x)"
                return
            fi

            i=1
            list_columns

            while ((i<=no_columns))
            do

                add_column
                list_columns
                ((i++))
            done
            echo ""
    
            CenteredPrint "Table '$table_name' created successfully! (ﾉ◕ヮ◕)ﾉ"
            echo ""
            printf "%*s\n" "$width" | tr ' ' '=' 
        fi
    else
        CenteredPrint "Name Must start with a letter and contain only letters, digits, or underscores."
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
    data_file="$DB_ROOT/$db_name/$table_name.data"
    if [[ ! -f "$meta_file" ]]; then
        CenteredPrint "(x_x) Table '$table_name' does not exist. (x_x)"
        return
    fi

    while true; do
        list_columns
        echo ""
        CenteredPrint "Please select an option:"
        echo ""
        CenteredPrint ":.:.:.:.: Column Menu :.:.:.:.:"
        CenteredPrint "==============================="
        CenteredPrint "||                           ||"
        CenteredPrint "||  1. Modify a column       ||"
        CenteredPrint "||  2. Add a new column      ||"
        CenteredPrint "||  3. Delete a column       ||"
        CenteredPrint "||  4. Back to Table Menu    ||"
        CenteredPrint "||                           ||"
        CenteredPrint "==============================="
        echo ""
        read -p "Enter your choice: " choice
                echo ""

        case "$choice" in
            1)
                read -p "Enter column number to modify: " col_num
                old_column=$(sed -n "${col_num}p" "$meta_file")
                old_type=$(echo "$old_column" | cut -d':' -f2)
                

                if [[ -z "$old_column" ]]
                then
                    CenteredPrint "(x_x) Invalid column number. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                echo ""
                CenteredPrint "Current column: $old_column"
                echo ""

                read -p "Enter new column name: " new_name
                if [[ -z "$new_name" || ! "$new_name" =~ $valid_string ]]
                then
                    CenteredPrint "(x_x) Invalid column name. Must start with a letter and contain only letters, digits, or underscores. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                
                read -p "Enter column type ( 1 -> int | 2 -> string ): " colomn_type
                if ! [[ "$colomn_type" =~ ^[12]$ ]]
                then
                    CenteredPrint "(x_x) Invalid column type. Must be 1 or 2. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                if [[ "$colomn_type" == "1" ]]
                then
                    new_type="int"
                else
                    new_type="string"
                fi
               


                if [[ "$old_type" == "string" && "$new_type" == "int" ]]; then
                    CenteredPrint "(x_x) Cannot change type from string to int. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                if grep -q ':PK$' "$meta_file"
                then
                    has_pk=true
                else
                    has_pk=false
                fi

                is_pk=""
                if [[ "$has_pk" == false ]]
                then
                    read -p "Do you want to make this the primary key? (y/n): " make_pk
                    if [[ "$make_pk" == "y" || "$make_pk" == "Y" ]]
                    then
                        is_pk=":PK"
                    fi
                fi

                
                if [[ "$old_column" == *":PK" ]]
                then
                    echo ""
                    CenteredPrint "(x_x) Cannot modify primary key column type, will use old type. (x_x)"
                    new_type=$old_type:PK
                    
                fi

                new_column="$new_name:$new_type$is_pk"

                sed -i "${col_num}s/.*/$new_column/" "$meta_file"
                echo ""
                CenteredPrint "(ﾉ◕ヮ◕)ﾉ Column updated successfully. (ﾉ◕ヮ◕)ﾉ"
                echo ""
                read -p "Press Enter to continue..."
                ;;

            2)
                add_column

                # Add the new column to the data file
                sed -i 's/$/:/' "$data_file"

                ;;

            3)
                read -p "Enter column number to delete: " del_num
                col=$(sed -n "${del_num}p" "$meta_file")
                if [[ -z "$col" ]]
                then
                    CenteredPrint "(x_x) Invalid column number. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                if [[ "$col" == *":PK" ]]
                then
                    CenteredPrint "(x_x) Cannot delete primary key column. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi

                sed -i "${del_num}d" "$meta_file"

                #remove the column from the data file
                sed -i -E "s/^(([^:]*:){$((del_num-1))})[^:]*(:)?/\1/" "$data_file"

                echo ""
                CenteredPrint "(ﾉ◕ヮ◕)ﾉ Column deleted successfully. (ﾉ◕ヮ◕)ﾉ"
                ;;

            4)
                CenteredPrint "Exiting Table metadata updater..."
                break
                ;;

            *)
                CenteredPrint "(x_x) Invalid option. (x_x)"
                ;;
        esac
        echo ""
    done
}

list_tables() {
    clear
    printf "%*s\n" "$width" | tr ' ' '=' 
    echo ""
    echo "Listing Available Tables: ..."
    echo ""
    CenteredPrint "||====== Available Tables in ======||"
    echo ""
    padding_length=$(( ($width - 29) / 2 ))
    ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | cut -c1-29 | nl -w"$padding_length" -s'. '
    echo ""
    CenteredPrint "||=================================||"
}

drop_table() {

    echo "Drop a table..."
    echo ""
    list_tables
    echo ""

    read -p "Enter table number to drop: " table_num
    if [[ ! "$table_num" =~ ^[0-9]+$ ]] || (( table_num <= 0 ))
    then
        CenteredPrint "(x_x) Invalid table number. (x_x)"
        return
    fi

    # Get table name from the numbered list
    table_name=$(ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//' | sed -n "${table_num}p")

    # Check if the table exists
    if [[ -f "$DB_ROOT/$db_name/$table_name.data" ]]
    then
        read -p "Are you sure you want to drop the table '$table_name'? This will delete all data. (y/n): " confirm
        echo ""
        if [[ $confirm == "y" ]]
        then
            rm -f "$DB_ROOT/$db_name/$table_name.data" "$DB_ROOT/$db_name/$table_name.meta"
            CenteredPrint "Table '$table_name' dropped successfully."
        else
            CenteredPrint "Deletion cancelled."
        fi
    else
        echo ""
        CenteredPrint "(x_x) Table does not exist. (x_x)"
        
    fi
}




