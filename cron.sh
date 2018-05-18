#!/usr/bin/env bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
(
    cd $SCRIPT_DIR
    make download
    make 
    ./venv/bin/python serve.py --prod || echo "Already running"
)
