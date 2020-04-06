#!/bin/bash

pip install -r requirements.txt && timeout 15 python web.py
status=$?

echo "Status:"$status

if [[ $status -eq 124  ]]
then echo "Success"
else echo "Error" && exit 1
fi
