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
        read -p "Do you want to make this the primary key? (y) any other key to cancel: " make_pk
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
    number_of_columns=$(wc -l < "$meta_file")

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
        CenteredPrint "(x_x) Name Must start with a letter and contain only letters, digits, or underscores. (x_x)"
    fi
}

update_table_meta() {
    echo "Updating table metadata..."
    echo ""
    list_tables
    echo ""

    read -p "Enter table number to update: " table_num
    echo ""
    if [[ ! "$table_num" =~ ^[0-9]+$ ]] || (( table_num <= 0 ))
    then
        CenteredPrint "(x_x) Invalid table number. Please enter a valid number (x_x)"
        return
    fi

    table_name=$(echo "$table_files" | sed -n "${table_num}p")
    meta_file="$DB_ROOT/$db_name/$table_name.meta"
    data_file="$DB_ROOT/$db_name/$table_name.data"

    if [[ ! -f "$meta_file" ]]
    then
        CenteredPrint "(x_x) Table '$table_name' does not exist. (x_x)"
        return
    fi

    while true
    do
        width=$(tput cols)
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
                if [[ ! "$col_num" =~ ^[0-9]+$ ]] || (( col_num <= 0 )) || (( col_num > number_of_columns ))
                then
                    CenteredPrint "(x_x) Invalid column number. (x_x)"
                    echo ""
                    read -p "Press Enter to continue..."
                    continue
                fi
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
                    read -p "Do you want to make this the primary key? (y) any other key to cancel: " make_pk
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
    CenteredPrint "||====== Available Tables ======||"
    echo ""
    padding_length=$(( ($width - 26) / 2 ))
    table_files=$(ls -1 "$DB_ROOT/$db_name" | grep '\.data$' | sed 's/\.data$//')
    number_of_tables=$(echo "$table_files" | wc -l)
    echo "$table_files" | cut -c1-26 | nl -w"$padding_length" -s'. '
    echo ""
    CenteredPrint "||==============================||"

}

drop_table() {

    echo ""
    list_tables
    echo "Dropping a table: ..."
    echo ""

    read -p "Enter table number to drop: " table_num
    echo ""
    if [[ ! "$table_num" =~ ^[0-9]+$ ]] || (( table_num <= 0 )) || (( table_num > number_of_tables ))
    then
        CenteredPrint "(x_x) Invalid table number. Please enter a valid number (x_x)"
        return
    fi

    table_name=$(echo "$table_files" | sed -n "${table_num}p")

    if [[ -f "$DB_ROOT/$db_name/$table_name.data" ]]
    then
        read -p "Are you sure? (╥﹏╥) This will delete all the data in '$table_name' Table (y) any other key to cancel: " confirm
        echo ""
        if [[ $confirm == "y" ]] || [[ $confirm == "Y" ]]
        then
            rm -f "$DB_ROOT/$db_name/$table_name.data" "$DB_ROOT/$db_name/$table_name.meta"
            CenteredPrint "(✖╭╮✖) Table << '$table_name' >> dropped successfully. (✖╭╮✖)"
        else
            CenteredPrint "Deletion cancelled. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
        fi
    else
        CenteredPrint "(x_x) Table does not exist. (x_x)"  
    fi
}


insert_into_table() {

    list_tables
    echo "Inserting into table..."
    echo ""

    read -p "Enter table number to insert into: " table_num
    echo ""
    if [[ ! "$table_num" =~ ^[0-9]+$ ]] || (( table_num <= 0 )) || (( table_num > number_of_tables ))
    then
        CenteredPrint "(x_x) Invalid table number. Please enter a valid number (x_x)"
        return
    fi

    # Get table name from the numbered list
    table_name=$(echo "$table_files" | sed -n "${table_num}p")
    meta_file="$DB_ROOT/$db_name/$table_name.meta"
    data_file="$DB_ROOT/$db_name/$table_name.data"
    if [[ ! -f "$meta_file" ]]
    then
        CenteredPrint "(x_x) Table does not exist. (x_x)"
        return
    fi
    if [[ ! -f "$data_file" ]]
    then
        CenteredPrint "(x_x) Table data file does not exist. Creating it again (x_x)"
        touch "$data_file"
    fi
    # Get columns types from meta file
    while true
    do
        read -p "Insert into table ? (y) any other key to cancel: " user_desire
        echo ""
        if [[ "$user_desire" == "y" || "$user_desire" == "Y" ]]
        then
            insertion=""
            meta_file="$DB_ROOT/$db_name/$table_name.meta"
            line_count=$(wc -l < "$meta_file")

            for (( i=1; i<=line_count; i++ ))
            do
                clear
                printf "%*s\n" "$width" | tr ' ' '='
                CenteredPrint "||====== Inserting into '$table_name' ======||"
                echo ""
                CenteredPrint "||=== $insertion: ===||"
                col=$(sed -n "${i}p" "$meta_file")

                col_type=$(echo "$col" | cut -d':' -f2)
                col_name=$(echo "$col" | cut -d':' -f1)
                
                is_pk=false
                tmpmsg=""
                if echo "$col" | grep -q ':PK$'
                then
                    is_pk=true
                    tmpmsg="(Primary Key)"
                fi

                while true
                do
                    echo ""
                    read -p "enter $col_type value for '$col_name' $tmpmsg: " value
                    echo "" 

                    if [[ "$col_type" == "int" && ! "$value" =~ ^[0-9]+$ ]]
                    then
                        CenteredPrint "(x_x) Invalid input. Must be a positive integer (x_x)"
                        continue
                    fi

                    if [[ "$col_type" == "string" && -z "$value" ]]
                    then
                        CenteredPrint "(x_x) Cannot be empty (x_x)"
                        continue
                    fi

                    if [[ "$is_pk" == true ]]
                    then
                        if cut -d':' -f"$i" "$data_file" | grep -qx "$value"
                        then
                            CenteredPrint "(x_x) Primary key value '$value' already exists and cannot be duplicated (x_x)"
                            continue
                        fi
                    fi
                    value=$(echo "$value" | sed 's/[][\/.^$*+?{}()|]/\\&/g; s/://g')

                    insertion+=":$value"
                    break
                done

            done
            clear
            printf "%*s\n" "$width" | tr ' ' '='
            CenteredPrint "||====== Inserting into '$table_name' ======||"
            echo ""
            CenteredPrint "||=== $insertion: ===||"
            echo ""
            insertion="${insertion#:}"
            echo "$insertion" >> "$DB_ROOT/$db_name/$table_name.data"
            CenteredPrint "Row << $insertion >> inserted successfully. (ﾉ◕ヮ◕)ﾉ"
            echo ""
        else
            CenteredPrint "Data insertion cancelled, returning to Table Menu. (ﾉ◕ヮ◕)ﾉ"
            break
        fi
    done
}

preview_data() {
    data_matches=$1
    data_matches=$(echo "$data_matches" | sed 's/\\\([][\/.^$*+?{}()|]\)/\1/g')
    headers=$(cut -d':' -f1 "$meta_file" | tr '\n' ':')
    echo ""
    data=$(echo -e "$headers\n$data_matches" | column -t -s: -o ' | ' | nl -v 0 -w5 -s'.  | ' | sed 's/^/| /')
    underline=$(echo "$data" | head -n 1 | sed -E 's/[^|]/-/g; s/\|/+/g; s/-$//')
    underline_width=${#underline}
    padding_length=$(( (width - underline_width) / 2 ))
    if (( padding_length < 0 ))
    then
        padding_length=0
    fi
    padding=$(printf "%*s" "$padding_length" "")
    underline="$padding$underline"
    data=$(echo "$data" | sed "s/^/$padding/")
    echo "$underline"
    echo "$data" | head -n 1 | sed "s/0./nl/"
    echo "$underline" | sed "s/+/\|/g"
    echo "$data" | tail -n +2
    echo "$underline"
    echo ""
}

select_from_table() {
    
    list_tables
    echo ""
    echo "Select from table..."
    echo ""
    read -p "Enter table number to select from: " table_num
    if [[ ! "$table_num" =~ ^[0-9]+$ ]] || (( table_num <= 0 )) || (( table_num > number_of_tables ))
    then
        CenteredPrint "(x_x) Invalid table number. (x_x)"
        return
    fi

    # Get table name from the numbered list
    table_name=$(echo "$table_files" | sed -n "${table_num}p")
    data_file="$DB_ROOT/$db_name/$table_name.data"
    meta_file="$DB_ROOT/$db_name/$table_name.meta"
    if [[ ! -f "$data_file" ]]
    then
        CenteredPrint "(x_x) Table data does not exist. (x_x)"
        return
    fi

    echo ""
    CenteredPrint "||====== Data in '$table_name' ======||"
    echo ""
    read -p "Do you want to search in a specific column? (y) any other key to search all: " search_in_column
    echo ""
    if [[ $search_in_column == "y" ]] || [[ $search_in_column == "Y" ]]
    then
        list_columns
        echo ""
        read -p "Enter column number to search in: " col_num
        if [[ ! "$col_num" =~ ^[0-9]+$ ]] || (( col_num <= 0 )) || (( col_num > number_of_columns ))
        then
            CenteredPrint "(x_x) Invalid column number. (x_x)"
            return
        fi

        col_name=$(sed -n "${col_num}p" "$meta_file" | cut -d':' -f1)
        echo ""
        CenteredPrint "Searching in column: $col_name"
    else
        col_num=0
    fi
    echo ""
    read -p "Enter your key word for selection (Enter to select all table data) : " key_word
    echo ""
    if [[ -z "$key_word" ]]
    then
        CenteredPrint "No keyword provided, selecting all data."
        matches=$(cat "$data_file")
        if [[ -z "$matches" ]]
        then
            CenteredPrint "(x_x) No data found in '$table_name'. (x_x)"
            return
        fi
    elif [[ $col_num -gt 0 ]]
    then
        line_num=$(cut -d':' -f"$col_num" "$data_file" | nl | grep -i "$key_word" | cut -f1 | tr -d ' ')

        sed_expr=$(echo "$line_num" | sed 's/^/-e /;s/$/p/' | tr '\n' ' ')

        matches=$(sed -n $sed_expr "$data_file")
    else
        matches=$(grep -i "$key_word" "$data_file")
    fi

    if [[ -z "$matches" ]]
    then
        CenteredPrint "(x_x) No matching records found for '$key_word'. (x_x)"
        return
    fi

    number_of_matches=$(echo "$matches" | wc -l)
    echo ""
    printf "%*s\n" "$width" | tr ' ' '='
    echo ""
    CenteredPrint "||====== Matching Records $number_of_matches ======||"
    echo ""
    preview_data "$matches"
    printf "%*s\n" "$width" | tr ' ' '='
    echo ""

}

delete_from_table() {
    select_from_table

    if [[ -z "$matches" ]]
    then
        CenteredPrint "(x_x) No records to delete. (x_x)"
        return
    fi

    echo "Deleting records..."
    echo ""
    read -p "Do you want to delete specific records? (y) any other key to delete all: " delete_specific
    echo ""
    deleted_records="$matches"
    if [[ $delete_specific == "y" ]] || [[ $delete_specific == "Y" ]]
    then
        deleted_records=""
        while true
        do
            clear
            number_of_matches=$(echo "$matches" | wc -l)
            printf "%*s\n" "$width" | tr ' ' '='
            echo ""
            CenteredPrint "||====== Searched  Records ======||"
            preview_data "$matches"
            echo ""
            CenteredPrint "||==== To Be Deleted Records ====||"
            preview_data "$deleted_records"
            echo ""
            read -p "Enter the record number to delete (use 0 to stop selecting): " record_num
            echo ""
            if [[ ! "$record_num" =~ ^[0-9]+$ ]] || (( record_num < 0 )) || (( record_num > number_of_matches ))
            then
                CenteredPrint "(x_x) Invalid input. Please enter a valid number (x_x)"
                read -p "Press Enter to continue..."
                continue
            fi

            if (( record_num == 0 ))
            then

                break
            fi
            record=$(echo "$matches" | sed -n "${record_num}p")
            deleted_records+="$record"$'\n'
            matches=$(echo "$matches" | sed -e "${record_num}d")
         done
    fi

    clear
    printf "%*s\n" "$width" | tr ' ' '='
    echo ""
    CenteredPrint "Selection stopped. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
    echo ""
    CenteredPrint "||====== Records to be deleted ======||"
    preview_data "$deleted_records"
    read -p "Are you sure you want to delete these records? (y) any other key to cancel: " confirm
    echo ""
    if [[ $confirm != "y" ]]
    then
        CenteredPrint "Deletion cancelled. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
        return
    fi


    for record in $deleted_records
    do
        sed -i "/^$(echo "$record" | sed 's/[][\/.^$*+?{}()|]/\\&/g')$/d" "$data_file"
    done
    echo ""
    CenteredPrint "(ﾉ◕ヮ◕)ﾉ Records deleted successfully. (ﾉ◕ヮ◕)ﾉ"
}

update_table_data() {
    select_from_table
    if [[ -z "$matches" ]]
    then
        CenteredPrint "(x_x) No records to update. (x_x)"
        return
    fi

    echo "Updating records..."
    echo ""
    read -p "Press Enter to continue..."
    echo ""
    while true
    do
        number_of_matches=$(echo "$matches" | wc -l)
        clear
        printf "%*s\n" "$width" | tr ' ' '='
        echo ""
        CenteredPrint "||====== Searched  Records ======||"
        preview_data "$matches"
        echo ""

        read -p "Select a record to update (use 0 to stop): " update_record_num
        echo ""
        if [[ ! "$update_record_num" =~ ^[0-9]+$ ]] || (( update_record_num < 0 )) || (( update_record_num > number_of_matches ))
        then
            CenteredPrint "(x_x) Invalid input. Please enter a valid number (x_x)"
            echo ""
            read -p "Press Enter to continue..."
            continue
        fi

        if (( update_record_num == 0 ))
        then
            break
        fi

        record=$(echo "$matches" | sed -n "${update_record_num}p")
        updated_record=""
        number_of_columns=$(wc -l < "$meta_file")
        echo ""
        for (( i=1; i<=number_of_columns; i++ ))
        do
            col=$(sed -n "${i}p" "$meta_file")
            col_name=$(echo "$col" | cut -d':' -f1)
            col_type=$(echo "$col" | cut -d':' -f2)

            old_value=$(echo "$record" | cut -d':' -f"$i")

            is_pk=false
            tmpmsg=""
            if echo "$col" | grep -q ':PK$'
            then
                is_pk=true
                tmpmsg="(Primary Key)"
            fi

            while true
            do
                clear
                printf "%*s\n" "$width" | tr ' ' '='
                CenteredPrint "||====== Updating Record ======||"
                echo ""
                preview_data "$record"
                echo ""
                CenteredPrint "||=== $updated_record: ===||"
                echo ""
                read -p "Enter new value for '$col_name$tmpmsg' to no change <leave blank> : " new_value
                echo ""
                if [[ -z "$new_value" ]] || [[ "$new_value" == "$old_value" ]]
                then 
                    updated_record+=":$old_value"
                    break
                else
                    if [[ "$col_type" == "int" && ! "$new_value" =~ ^[0-9]+$ ]]
                    then
                        CenteredPrint "(x_x) Invalid input. Must be a positive integer (x_x)"
                        read -p "Press Enter to continue..."
                        continue
                    fi
                    
                    if [[ "$is_pk" == true ]]
                    then
                        if cut -d':' -f"$i" "$data_file" | grep -qx "$new_value"
                        then
                            CenteredPrint "(x_x) Primary key value '$new_value' already exists and cannot be duplicated (x_x)"
                            read -p "Press Enter to continue..."
                            continue
                        fi
                    fi

                    updated_record+=":$new_value"
                    break
                fi
            done    
        done
        updated_record="${updated_record#:}"
        matches=$(echo "$matches" | sed -e "${update_record_num}d")
        read -p "Press Enter to continue..."
        clear
        printf "%*s\n" "$width" | tr ' ' '='
        CenteredPrint "||====== Updating Record ======||"
        echo ""
        preview_data "$record"
        echo ""
        CenteredPrint "||====== Updated  Record ======||"
        echo ""
        preview_data "$updated_record"
        echo ""
        read -p "Apply Changes? (y) any other key to cancel: " confirm
        echo ""

        if [[ "$confirm" != [yY] ]]
        then
            CenteredPrint "Changes discarded. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"
            continue
        fi
        sed -i "/^$(echo "$record" | sed 's/[][\/.^$*+?{}()|]/\\&/g')$/c\\$updated_record" "$data_file"
        CenteredPrint "(ﾉ◕ヮ◕)ﾉ Record updated successfully. (ﾉ◕ヮ◕)ﾉ"
        echo ""
        read -p "Press Enter to continue..."
        echo ""
    done
    CenteredPrint "(ﾉ◕ヮ◕)ﾉ*:・ﾟ✧ Exiting update mode. (ﾉ◕ヮ◕)ﾉ*:・ﾟ✧"

}