#!/bin/bash

if pgrep -x "walker" > /dev/null; then
    pkill walker
else
    walker --gapplication-service &
fi
