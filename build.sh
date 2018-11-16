#!/bin/sh

DIR_GAMETYPES="maps/MP/gametypes"
DIR_WEAPONS="weapons"

"/c/Program Files/7-Zip/7z" a -tzip zzz_svr_wrs.pk3 $DIR_GAMETYPES/*.{gsc,txt} $DIR_WEAPONS/*/* > /dev/null
