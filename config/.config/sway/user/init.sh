#! /usr/bin/env bash

bash -c 'exec ianny                      >/tmp/.sway.ianny.log   2>/tmp/.sway.ianny.err.log'   &

readonly LATITUDE='51.0' LONGITUDE='13.7'
bash -c "exec wlsunset -t 5500 -T 8000 -l ${LATITUDE} -L ${LONGITUDE} >/tmp/.sway.wlsunset.log  2>/tmp/.sway.wlsunset.err.log" &

disown -a
