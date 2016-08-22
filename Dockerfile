FROM java:8

ENV TEAMCITY_VERSION 10.0.1

RUN curl https://download-cf.jetbrains.com/teamcity/TeamCity-$TEAMCITY_VERSION.tar.gz | tar -xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

VOLUME "/var/lib/teamcity"

# Expose the Teamcity port
EXPOSE  8111

ENV TEAMCITY_DATA_PATH /var/lib/teamcity

ENTRYPOINT /opt/TeamCity/bin/runAll.sh start && sleep 10 && tail -f --retry /opt/TeamCity/logs/teamcity-server.log
