#!/usr/bin/env bash


export HTTP_PROXY="socks://127.0.0.1:9050"
export HTTPS_PROXY=$HTTP_PROXY

/home/amnesia/Persistent/Apps/signal-desktop/opt/Signal/signal-desktop --no-sandbox %U
