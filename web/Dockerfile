FROM finntech/openjdk8:1.8.0_92

WORKDIR /app

COPY build/libs/firetruck-web-1.0-SNAPSHOT-shaded.jar firetruck-web.jar

ENV THRIFT_GREENPAGES_HOST "greenpages-server"

ENV JAVA_OPTS "-Dspring.profiles.active=prod -Djava.security.egd=file:/dev/urandom"

EXPOSE 8080
