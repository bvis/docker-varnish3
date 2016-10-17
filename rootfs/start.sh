#!/bin/sh

set -e

export JOINED_VCL_FILE=$VCL_CONFIG

if [ -d "$VCL_CONFIG" ]; then
    source varnish-join-vcl.sh
fi

exec varnishd -F \
  -f $JOINED_VCL_FILE \
  -s malloc,$CACHE_SIZE \
  $VARNISHD_PARAMS
