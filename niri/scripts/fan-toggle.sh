#!/bin/bash

PWMFILE="/sys/class/hwmon/hwmon3/pwm1_enable"
CURRENT=$(cat "$PWMFILE")

if [ "$CURRENT" = "2" ]; then
    echo "0" | sudo tee "$PWMFILE" > /dev/null
    notify-send "Fan speed" "Max" --icon=computer
    echo "Fan set to MAX"
else
    echo "2" | sudo tee "$PWMFILE" > /dev/null
    notify-send "Fan speed" "Auto" --icon=computer
    echo "Fan set to AUTO"
fi
