#!/bin/bash

# Library with bash functions used by MediaWiki upgrade scripts

# Logging functions

log_info() {
	echo "[INFO   ] $1" 1>&2
}

log_warning() {
	echo "[WARNING] $1" 1>&2
}

log_error() {
	echo "[ERROR  ] $1" 1>&2
}

log_fatal() {
	echo "[FATAL  ] $1" 1>&2
	exit -1
}

handle_error_code() {
	local ERROR_CODE=$?
	if [ $ERROR_CODE -ne 0 ]
	then
		log_fatal "$1 had error code $ERROR_CODE"
	fi
}
