eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path
export SSD="/run/media/hann/Rayhan/"
export PROJ="/run/media/hann/Rayhan/Project"
export PATH="$HOME/.local/bin:$PATH"

# Directory to store Zinit and its plugins
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"

# Download Zinit if not already present
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source Zinit
source "$ZINIT_HOME/zinit.zsh"

# Add powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light Aloxaf/fzf-tab
zinit light MichaelAquilina/zsh-you-should-use

# Add snippets
# zinit snippet OMZP::git
# zinit snippet OMZP::npm
# zinit snippet OMZP::nvm
# zinit snippet OMZP::sudo
# zinit snippet OMZP::docker
# zinit snippet OMZP::archlinux
# zinit snippet OMZP::docker-compose
zinit snippet OMZP::command-not-found

# Load completions
autoload -U compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# History
HISTSIZE=100000
SAVEHIST=100000
HISTFILE=~/.zsh_history
HISTDUP=erase
setopt append_history
setopt share_history
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:ls:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:eza:*' fzf-preview 'eza -1 --color=always $realpath'

# Aliases
alias ls="eza --icons=always"
alias ll="eza -lhas ext --icons=always"
alias cat="bat"
alias dot="~/dotfiles/dotfiles.sh"
alias cl="clear"
alias zed="zeditor"
