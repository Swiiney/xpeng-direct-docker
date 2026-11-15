#! /bin/sh
wget --user-agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64)" $XPENG_APK -O /data/xpeng.xapk
java -jar /app/XPengDirect.jar --setup --apk /data/xpeng.xapk
