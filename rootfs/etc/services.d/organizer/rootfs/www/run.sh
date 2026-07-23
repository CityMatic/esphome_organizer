#!/bin/bash

LEGACY="c1cd5ebd_esphome-legacy-2025.3"
DEV="5c53de3b_esphome-dev"

LATEST="/homeassistant/esphome/latest"
STABLE="/homeassistant/esphome/stable"

LOG="/share/esphome_organizer.log"

echo "=== ESPHome Organizer start ===" >> $LOG
date >> $LOG

# --- CZYSZCZENIE LOGÓW ---
find /share/logs -type f -mtime +7 -delete
echo "[OK] Czyszczenie logów" >> $LOG

# --- CZYSZCZENIE ARCHIWÓW ---
find /share/archive -type f -mtime +30 -delete
echo "[OK] Czyszczenie archiwów" >> $LOG

# --- UKRYWANIE latest/stable ---
echo "[OK] Ukrywanie latest/stable" >> $LOG

touch $LATEST/.esphomeignore
echo "*" > $LATEST/.esphomeignore

touch $STABLE/.esphomeignore
echo "*" > $STABLE/.esphomeignore

echo "[OK] Organizacja katalogów" >> $LOG

# --- MINI SERWER HTTP ---
while true; do
    read -r REQUEST

    if echo "$REQUEST" | grep -q "POST /reset-legacy"; then
        curl -X POST http://supervisor/apps/$LEGACY/restart
        echo "RESET LEGACY OK" >> $LOG
    fi

    if echo "$REQUEST" | grep -q "POST /reset-dev"; then
        curl -X POST http://supervisor/apps/$DEV/restart
        echo "RESET DEV OK" >> $LOG
    fi

    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nOK"
done | nc -l -p 8099 -k
