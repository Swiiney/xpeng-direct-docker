#!/bin/sh
set -eu

if [ -z "${XPENG_APK:-}" ]; then
    echo "Erreur : XPENG_APK n'est pas définie." >&2
    exit 1
fi

wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" "$XPENG_APK" -O /app/xpeng.xapk || exit 1

MAX_TRIES=3
try=1
MARKER="Listening for XPENG notifications; publishing to local MQTT."

STATE_DIR=$(mktemp -d)
FIFO="$STATE_DIR/log_fifo"
mkfifo "$FIFO"
trap 'rm -rf "$STATE_DIR"' EXIT

while [ "$try" -le "$MAX_TRIES" ]; do
    rm -f "$STATE_DIR/listening"

    # Traitement du log en arrière-plan via le FIFO
    while IFS= read -r line; do
        printf '%s\n' "$line"
        case "$line" in
            *"$MARKER"*) : > "$STATE_DIR/listening" ;;
        esac
    done < "$FIFO" &
    LOGGER_PID=$!

    # Execution de Java redirigée vers le FIFO
    set +e
    java -Djava.awt.headless=true -jar /app/XPengDirect.jar --cli > "$FIFO" 2>&1
    code=$?
    set -e

    # Attente de la fin de l'affichage des logs
    wait "$LOGGER_PID" 2>/dev/null || true

    if [ "$code" -ne 1 ]; then
        exit "$code"
    fi

    if [ -f "$STATE_DIR/listening" ]; then
        echo "Code 1 après démarrage normal, réinitialisation du compteur" >&2
        try=1
    else
        echo "Le programme s'est terminé avec le code 1 (tentative $try/$MAX_TRIES)" >&2
        try=$((try + 1))
    fi
done

exit 1
