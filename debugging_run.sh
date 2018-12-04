#!/bin/bash

if [ ! -f $(pwd)/config/labels.txt ]; then
	echo you must fill in the labels
	exit
fi

if [ -z ${1} ]; then
	let PORT=8080;
else
	let PORT=${1};
fi

/usr/bin/env python app.py -r -d -p ${PORT}
