 #!/bin/bash
# Connecte_DB needs to be assigned in connected db

# To be Removed After Adjusting the code to use table_functions.sh and collecting functions in it

echo "Drop a table..."
echo ""
./ListTable
echo ""

read -p "Enter table number to drop: " table_num

# Get table name from the numbered list
table_name=$(ls "$Connected_DB" | grep '\.data$' | sed 's/\.data$//' | sed -n "${table_num}p")

# Check if the table exists
if [[ -f "$Connected_DB/$table_name.data" ]]; then
    read -p "Are you sure you want to drop the table '$table_name'? This will delete all data. (y/n): " confirm
    if [[ $confirm == "y" ]]; then
        rm -f "$Connected_DB/$table_name.data" "$Connected_DB/$table_name.meta"
        echo "Table '$table_name' dropped successfully."
    else
        echo "Deletion cancelled."
    fi
else
    echo "Table not found."
fi
