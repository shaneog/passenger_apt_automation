#!/bin/bash
# Changes the 'app' user's UID and GID to the values specified
# in $APP_UID and $APP_GID.
set -e

chown -R "$APP_UID:$APP_GID" /home/app
groupmod -g "$APP_GID" app
usermod -u "$APP_UID" -g "$APP_GID" app

# There's something strange with either Docker or the kernel, so that
# the 'app' user cannot access its home directory even after a proper
# chown/chmod. We work around it like this.
mv /home/app /home/app2
cp -dpR /home/app2 /home/app
rm -rf /home/app2

if [[ $# -gt 0 ]]; then
	exec "$@"
fi
