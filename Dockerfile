FROM eclipse-temurin:25-jre-ubi10-minimal

#ENV XPENG_APK=https://d.apkpure.net/b/XAPK/com.xiaopeng.globalcarinfo?version=latest
ENV XPENG_APK=https://d.apkpure.com/b/XAPK/com.xiaopeng.globalcarinfo?versionCode=8847
ENV XPENG_JAVA_STATE_DIR=/data

RUN mkdir -p /app /data

COPY XPengDirect.jar /app
COPY setup.sh /app
COPY run.sh /app

VOLUME /data

CMD ["/app/run.sh"]
