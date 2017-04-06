#!/bin/bash
set -euo pipefail

# https://github.com/SeleniumHQ/docker-selenium/issues/184
function get_server_num() {
  echo $(echo $DISPLAY | sed -r -e 's/([^:]+)?:([0-9]+)(\.[0-9]+)?/\2/')
}

SERVERNUM=$(get_server_num)
GEOMETRY="$SCREEN_WIDTH""x""$SCREEN_HEIGHT""x""$SCREEN_DEPTH"
rm -f /tmp/.X*lock


cp -rf /gauge.skel ~/.gauge
ln -s /maven ~/.m2
xvfb-run -n $SERVERNUM --server-args="-screen 0 $GEOMETRY -ac +extension RANDR" "$@"