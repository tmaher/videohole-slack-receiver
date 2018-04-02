#!/bin/bash

eval $(ssh-agent -s)
echo "${SERVER_SSH_PRIVATE_KEY}" > /tmp/server.key
ssh-add /tmp/server.key
rm /tmp/server.key

bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
