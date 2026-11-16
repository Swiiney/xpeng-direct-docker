#! /bin/sh
if [ -z "${XPENG_APK:-}" ]; then
    echo "Erreur : XPENG_APK n'est pas définie." >&2
    exit 1
fi

wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" $XPENG_APK -O /data/xpeng.xapk
java -jar /app/XPengDirect.jar --setup --apk /data/xpeng.xapk
