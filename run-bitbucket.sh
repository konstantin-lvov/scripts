#!/bin/bash
docker run -v /Users/konstantinlvov/bitbucket:/var/atlassian/application-data/bitbucket \
  --name="bitbucket" \
  -d -p 7990:7990 -p 7999:7999 -p 3333:3333 \
  -e JMX_ENABLED=true \
  -e JMX_REMOTE_AUTH=password \
  -e JMX_REMOTE_PORT=3333 \
  -e JMX_REMOTE_RMI_PORT=3333 \
  -e RMI_SERVER_HOSTNAME=192.168.1.52 \
  -e JMX_PASSWORD_FILE=/var/atlassian/application-data/bitbucket/jmx.access \
  atlassian/bitbucket
