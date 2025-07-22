#!/bin/bash
shopt -s extglob
# Connecte_DB needs to be assigned in connected db

echo "Creating a new table ..."
echo ""
read -p "Enter table name: " tl_name
echo ""
if [[ "$tl_name" =~ ^[a-zA-Z][a-zA-Z0-9_]*$ ]];
then

    if [[ -e "$Connected_DB/$tl_name.meta" || -e "$Connected_DB/$tl_name.data" ]];
    then
        echo "Table already exists."
    else
        touch "$Connected_DB/$tl_name.meta" "$Connected_DB/$tl_name.data"
        echo ""
        read -p "Enter the number of columns: " no_columns
        echo ""
        i=1
        while ((i<=no_columns))
        do
            while true
            do
                echo ""
                read -p "Enter table name: " column_name

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
                echo "$column_name:$column_type_name" >> "$Connected_DB/$tl_name.meta"
            ((i++))
        done
        echo "Table '$tl_name' created successfully!"
    fi
else
    echo "Invalid table name. Must start with a letter and contain only letters, digits, or underscores."
fi    

    
