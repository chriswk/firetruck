#!/bin/sh
export JAVA_OPTIONS="-Dspring.profiles.active=prod
-DGreenPagesService.host=$THRIFT_GREENPAGES_HOST \
-Dserver.port=8733 \
"
