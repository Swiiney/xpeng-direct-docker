#! /bin/sh
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" $XPENG_APK -O /app/xpeng.xapk

MAX_TRIES=3
try=1
MARKER="Listening for XPENG notifications; publishing to local MQTT."

# Dossier temporaire pour communiquer avec la boucle de lecture du log
STATE_DIR=$(mktemp -d)
trap 'rm -rf "$STATE_DIR"' EXIT

while [ "$try" -le "$MAX_TRIES" ]; do
    rm -f "$STATE_DIR/listening" "$STATE_DIR/code"

    {
        java -Djava.awt.headless=true -jar /app/XPengDirect.jar --cli 2>&1
        echo $? > "$STATE_DIR/code"
    } | while IFS= read -r line; do
        # Affichage du log en direct sur la sortie standard
        printf '%s\n' "$line"
        case "$line" in
            *"$MARKER"*) : > "$STATE_DIR/listening" ;;
        esac
    done

    code=$(cat "$STATE_DIR/code")

    # Tout code différent de 1 (succès ou autre erreur) : on termine
    if [ "$code" -ne 1 ]; then
        exit "$code"
    fi

    if [ -f "$STATE_DIR/listening" ]; then
        # Le programme a démarré correctement avant de planter : on repart de zéro
        echo "Code 1 après démarrage normal, réinitialisation du compteur" >&2
        try=1
    else
        echo "Le programme s'est terminé avec le code 1 (tentative $try/$MAX_TRIES)" >&2
        try=$((try + 1))
    fi
done

# 3 échecs consécutifs avec le code 1 sans avoir atteint l'état "Listening"
exit 1
