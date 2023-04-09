#!/bin/bash

PRE_GA_INDEX=$1
PRE_GA_TAG=$2

./linux-amd64-opm render ${PRE_GA_INDEX}:${PRE_GA_TAG} > render.json

jq -r -f translate.jq render.json
