#!/bin/bash
# Connecte_DB needs to be assigned in connected db

echo "Listing tables:"
ls "$Connected_DB" | grep '\.data$' | sed 's/\.data$//' | nl