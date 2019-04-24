FROM maven:3.6-jdk-11
MAINTAINER Sebastian Sdorra <sebastian.sdorra@cloudogu.com>

ENV VERSION=0.8.3 \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true \
    SCREEN_WIDTH=1360 \
    SCREEN_HEIGHT=1020 \
    SCREEN_DEPTH=24 \
    DISPLAY=:99.0

RUN apt-get update -qqy \
 && apt-get install -qyy ca-certificates apt-transport-https xvfb \
 && apt-key adv --keyserver hkp://pool.sks-keyservers.net --recv-keys 023EDB0B \
 && echo deb https://dl.bintray.com/gauge/gauge-deb stable main | tee -a /etc/apt/sources.list \
 && apt-get update -qqy \
 && apt-get install -qqy gauge \
 && gauge install java \
 && gauge install html-report \
 && gauge install xml-report \
 && gauge telemetry off \
 && mv /root/.gauge /gauge.skel \
 && chmod -R 755 /gauge.skel \
 # create jenkins passwd entries, because some commands fail if there is no entry for the uid
 # we create multiple entries, because we do not know the uid of the jenkins user
 && for i in $(seq 1000 1010); do useradd -u ${i} -m -s /bin/bash "jenkins${i}"; done \
 # cleanup
 && rm -rf /var/lib/apt/lists/* /var/cache/apt/* 

COPY /startup.sh /
ENTRYPOINT ["/startup.sh"]
