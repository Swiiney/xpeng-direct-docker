#! /bin/sh
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" $XPENG_APK -O /app/xpeng.xapk

MAX_TRIES=3
try=1
while [ "$try" -le "$MAX_TRIES" ]; do
    java -Djava.awt.headless=true -jar /app/XPengDirect.jar --cli --exitonerror
    code=$?

    # Tout code différent de 1 (succès ou autre erreur) : on termine
    if [ "$code" -ne 1 ]; then
        exit "$code"
    fi

    echo "Echec de connexion ou perte de connexion MQTT Xpeng (tentative $try/$MAX_TRIES)" >&2
    try=$((try + 1))
done

# 3 échecs consécutifs avec le code 1
exit 1
