apps=(
    bssh
    bvnc
    avahi-discover
    java-java-openjdk
    jconsole-java-openjdk
    jshell-java-openjdk
    org.gnupg.pinentry-qt
    org.gnupg.pinentry-qt5
    rofi-theme-selector
    rofi
    qv4l2
    qvidcap
    xgps
    xgpsspeed
)

for app in "${apps[@]}"; do
    src="/usr/share/applications/${app}.desktop"
    dst="$HOME/.local/share/applications/${app}.desktop"
    if [ -f "$src" ]; then
        cp "$src" "$dst"
        grep -q "^NoDisplay" "$dst" || echo "NoDisplay=true" >> "$dst"
        echo "Hidden: $app"
    fi
done
