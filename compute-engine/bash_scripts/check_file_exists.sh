#!/bin/bash

if [ -e "$1" ]; then
  echo '{"exists": "true"}'
else
  echo '{"exists": "false"}'
fi