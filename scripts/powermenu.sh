#!/bin/bash

case "$ROFI_RETV" in
  0)
    echo -en "\0prompt\x1fPower\n"
    echo -e "Lock\0icon\x1fsystem-lock-screen-symbolic"
    echo -e "Logout\0icon\x1fsystem-log-out-symbolic"
    echo -e "Suspend\0icon\x1fsystem-suspend-symbolic"
    echo -e "Reboot\0icon\x1fsystem-reboot-symbolic"
    echo -e "Shutdown\0icon\x1fsystem-shutdown-symbolic"
    ;;
  1)
    case "$1" in
      Lock)     loginctl lock-session ;;
      Logout)   loginctl terminate-session "$XDG_SESSION_ID" ;;
      Suspend)  systemctl suspend ;;
      Reboot)   systemctl reboot ;;
      Shutdown) systemctl poweroff ;;
    esac
    ;;
esac
