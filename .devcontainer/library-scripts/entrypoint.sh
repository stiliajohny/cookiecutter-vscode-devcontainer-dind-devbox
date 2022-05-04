#!/bin/bash

set -e

/usr/local/share/desktop-init.sh &
/usr/local/share/docker-init.sh &

set +e

exec "$@"