#!/bin/bash
cd /projects/arq/arq

if pgrep uvicorn >/dev/null
then
    echo "uvicorn is running"
else
    uvicorn main:arq
fi