#!/bin/bash

LEGACY="c1cd5ebd_esphome-legacy-2025.3"
DEV="5c53de3b_esphome-dev"

LATEST="/homeassistant/esphome/latest"
STABLE="/homeassistant/esphome/stable"

LOG="/share/esphome_organizer.log"

echo "=== ESPHome Organizer start ===" >> $LOG
date >> $LOG

find /share/logs -type f -mtime +7 -delete
find /share/archive -type f -mtime +30 -delete

touch $LATEST/.esphomeignore
echo "*" > $LATEST/.esphomeignore

touch $STABLE/.esphomeignore
echo "*" > $STABLE/.esphomeignore

while true; do
    read -r REQUEST

    if echo "$REQUEST" | grep -q "POST /reset-legacy"; then
        curl -X POST http://supervisor/apps/$LEGACY/restart
    fi

    if echo "$REQUEST" | grep -q "POST /reset-dev"; then
        curl -X POST http://supervisor/apps/$DEV/restart
    fi

    echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\nOK"
done | nc -l -p 8099 -k
