#!/bin/bash

echo "=== ESPHome Organizer start ==="

# Start serwera panelu (prosty serwer HTTP)
cd /www
python3 -m http.server 8099 &

# Główna pętla
while true; do
    sleep 60
done

