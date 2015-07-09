FROM java:8
# Get and install teamcity
RUN curl http://download-ln.jetbrains.com/teamcity/TeamCity-9.0.4.tar.gz | tar -xz -C /opt

# Enable the correct Valve when running behind a proxy
RUN sed -i -e "s/\.*<\/Host>.*$/<Valve className=\"org.apache.catalina.valves.RemoteIpValve\" protocolHeader=\"x-forwarded-proto\" \/><\/Host>/" /opt/TeamCity/conf/server.xml

VOLUME "/var/lib/teamcity"
# Expose the Teamcity port
EXPOSE  8111

ENV TEAMCITY_DATA_PATH /var/lib/teamcity

ENTRYPOINT /opt/TeamCity/bin/runAll.sh start && sleep 10 && tail -f /opt/TeamCity/logs/teamcity-server.log
