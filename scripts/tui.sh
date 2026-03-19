#!/bin/bash
APP="$1"
shift
kitty --app-id "$APP" sh -c "$APP $*; niri msg action close-window"
