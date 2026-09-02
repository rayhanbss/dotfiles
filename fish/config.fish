if status is-interactive
    set -g fish_greeting

    # Abbreviations
    abbr -a update yay -Syyu
    abbr -a install yay -S
    abbr -a remove yay -Rns

    abbr -a .. cd ..
    abbr -a ... cd ../..

    abbr -a cl clear

    alias ls="eza -s ext --icons=always"
    abbr -a ll ls -lh
    abbr -a la ls -lha

    abbr -a mk mkdir -p
    abbr -a cat bat

    abbr -a dcst sudo systemctl start docker
    abbr -a dcsp sudo systemctl stop docker

    abbr -a ga git add
    abbr -a gc git commit -m
    abbr -a gp git push
    abbr -a gpl git pull
    abbr -a gco git checkout
    abbr -a gcl git clone
    abbr -a gst git status
    

    zoxide init fish | source
end
