#!/bin/bash
# Connecte_DB needs to be assigned in connected db
# To be Removed After Adjusting the code to use table_functions.sh and collecting functions in it

echo "Listing tables:"
ls "$Connected_DB" | grep '\.data$' | sed 's/\.data$//' | nl