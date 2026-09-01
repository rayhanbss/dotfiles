#!/bin/bash

# Get raw volume and convert to int
vol_raw=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{ print $2 }')
vol_int=$(echo "$vol_raw * 100" | bc | awk '{ print int($1) }')

# Check mute status
is_muted=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q MUTED && echo true || echo false)

# Get default sink description (human-readable)
sink=$(wpctl status | awk '/Sinks:/,/Sources:/' | grep '\*' | cut -d'.' -f2- | sed 's/^\s*//; s/\[.*//')

# Icon logic
if [ "$is_muted" = true ]; then
  icon=" "
elif [ "$vol_int" -lt 10 ]; then
  icon=" "
elif [ "$vol_int" -lt 50 ]; then
  icon=" "
else
  icon=" "
fi

# ASCII bar
filled=$((vol_int / 10))
empty=$((10 - filled))
bar=
for _ in $(seq 1 "$filled"); do
  bar+=█
done

pad=
for _ in $(seq 1 "$empty"); do
  pad+=░
done

ascii_bar="|$bar$pad| "

# Color logic
if [ "$is_muted" = true ] || [ "$vol_int" -lt 10 ]; then
  fg="#bf616a"
elif [ "$vol_int" -lt 50 ]; then
  fg="#ebcb8b"
else
  fg="#88c0d0"
fi

# Tooltip text
if [ "$is_muted" = true ]; then
  tooltip="Audio: Muted\nOutput: $sink"
else
  tooltip="Audio: $vol_int%\nOutput: $sink"
fi

# Format volume as fixed width (3 chars); use zeros or spaces
if [ "$vol_int" -lt 10 ]; then
  vol_str=$(printf " %d%% " "$vol_int")
elif [ "$vol_int" -lt 100 ]; then
  vol_str=$(printf "%d%% " "$vol_int")
else
  vol_str=$(printf "%d%%" "$vol_int")
fi

# Final output
echo "{\"text\":\"<span foreground='$fg'>$icon $ascii_bar</span>\",\"tooltip\":\"$tooltip\"}"
