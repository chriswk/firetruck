FROM finntech/openjdk8bond:1.8.0_92

WORKDIR /app

COPY web/build/libs/firetruck-web-1.0-SNAPSHOT-shaded.jar firetruck-web.jar

ADD run-env.sh run-env.sh

ENV THRIFT_GREENPAGES_HOST "greenpages-server"

EXPOSE 8733
