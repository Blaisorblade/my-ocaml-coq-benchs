#!/bin/bash
. funcs.inc.sh

[ -z "$1" ] && { echo "Specify path to logs as argument"; exit 1; }
avgReports "$1"
