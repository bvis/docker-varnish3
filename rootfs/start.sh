#!/bin/sh

set -e

export JOINED_VCL_FILE=$VCL_CONFIG

if [ -d "$VCL_CONFIG" ]; then
    source /varnish-join-vcl.sh
fi

# if command starts with an option, prepend varnishd
if [ "${1:0:1}" = '-' ]; then
	set -- varnishd "$@"
fi

if [[ "$@" = 'varnishd' ]]; then
	set -- varnishd -F \
      -f $JOINED_VCL_FILE \
      -s malloc,$CACHE_SIZE \
      $VARNISHD_PARAMS
fi

exec "$@"
