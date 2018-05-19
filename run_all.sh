#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd $SCRIPT_DIR
    make download
    make 
    ./venv/bin/python serve.py --prod || echo "Already running"
)

# check if twitter daemon running, if not launch it.
if pgrep twitter_daemon; then
    echo 'Twitter daemon already runnung';
else
    ./twitter_daemon.py &
    ./twitter_daemon_biorxiv.py &
fi
