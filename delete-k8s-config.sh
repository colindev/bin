#!/bin/bash

echo 'stop use Ctrl+D'
read -p 'cluster|user? ' resource

for name in `kubectl config --skip-headers get-${resource}s`
do
    [ "$name" == 'NAME' ] && continue
    read -p "delete [$name] ? y/N/exit" ans
    [ "$ans" == 'y' ] && kubectl config delete-${resource} $name
    [ "$ans" == 'exit' ] && exit 0
done
