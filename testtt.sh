#!/bin/bash

export TUXDIR=/app/tuxedo
export TUXCONFIG=/app/wpr/tuxedo/tuxconfig
export PATH=$TUXDIR/bin:$PATH
export LD_LIBRARY_PATH=$TUXDIR/lib:$LD_LIBRARY_PATH

exec /usr/bin/perl /usr/local/zabbix/scripts/tuxedo_lld.pl
