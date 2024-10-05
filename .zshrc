# TMUX
#if ["$TMUX" = ""]; then tmux; fi
# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#vi mode
# bindkey -v
# export KEYTIMEOUT=1
bindkey -M emacs '^K' up-line-or-history
bindkey -M emacs '^J' down-history
bindkey -M emacs '^H' backward-char
bindkey -M emacs '^L' forward-char

#tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' menu select 
autoload -Uz compinit; compinit
CASE_SENSITIVE="false"
#auto complete
bindkey 'SHIFT+TAB' autosuggest-execute
#export
export HISTFILE=/home/kavi741/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000
#printf EOL character
export PROMPT_EOL_MARK=''
export SUDO_EDITOR=nvim
export EDITOR=nvim
fpath=($HOME/completion_zsh $fpath)

#aliases
alias vim='nvim'
#alias emacs='emacs -nw'
alias leetcode='nvim leetcode'
#alias matlab='matlab -nodesktop -nosplash'
#alias zathura='zathura $(fzf)'
alias cat='bat'
alias cal='gcalcli calw'
#alias sudo='doas'

alias l='colorls -CF'
alias la='colorls -Ah'
alias ls='colorls --dark'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias mkdir="mkdir -pv"
##alias aptin="sudo apt install -y "
alias in="sudo pacman -S"
alias aur="paru"
alias temp="sensors | grep -E 'id|Core|Fan'"
alias weather="curl wttr.in/Brampton"
#alias updatable="sudo apt list --upgradable"
#alias update="sudo apt update; sudo apt upgrade"
alias update="sudo pacman -Syu"
alias vpn="sudo tailscale"

eval $(thefuck --alias)

#PATH
export PATH="$HOME/.local/share/gem/ruby/3.0.0/bin:$HOME/.config/emacs/bin:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#plugins
# eval $(thefuck --alias fuck)
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /home/kavi741/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/kavi741/.zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/usr/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/usr/etc/profile.d/conda.sh" ]; then
        . "/usr/etc/profile.d/conda.sh"
    else
        export PATH="/usr/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

