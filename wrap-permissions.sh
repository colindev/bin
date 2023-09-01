#!/bin/bash

while read permission
do
    permission=${permission#+ }
    permission=${permission#- }
    echo "    \"${permission}\","
done
