# ~/.config/.zshrc

autoload -U compinit && compinit
autoload -U colors && colors

zstyle ':completion:*' menu select
zstyle ':completion:*' special-dirs true

if [ -f "$(brew --prefix)/bin/brew" ]; then
  eval "$($(brew --prefix)/bin/brew shellenv)"
fi

[ -f "/Users/vicenzomasera/.ghcup/env" ] && . "/Users/vicenzomasera/.ghcup/env"
export PATH="/opt/homebrew/opt/python/libexec/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/pipx:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/emacs/bin:$PATH"
export EDITOR='nvim';
export MANPAGER="bat -plman"
export BAT_THEME="vague" 

setopt append_history inc_append_history share_history
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

setopt auto_menu menu_complete
setopt auto_param_slash
setopt no_case_glob no_case_match
setopt globdots
setopt extended_glob
setopt CORRECT
stty stop undef

source <(fzf --zsh)
[ -f "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh" ] && source "$(brew --prefix)/opt/fzf/shell/key-bindings.zsh"

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE="$ZDOTDIR/.zsh_history"

mkcd(){
	mkdir -p "$1" && cd "$1"
}

bindkey -e

alias bup="brew upgrade && brew update"
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions -a"
alias src="source ~/.config/zsh/.zshrc"
alias ..="cd .."
alias ...="cd .. && cd .."

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

autoload -Uz vcs_info
setopt PROMPT_SUBST

local branch_icon=""
local arrow_icon="❯" 

precmd() {
  GIT_INFO=""
  
  vcs_info

  if [[ -n "${vcs_info_msg_0_}" ]]; then
    local git_status=""
    
    if [[ "${vcs_info_msg_0_}" == *!* || "${vcs_info_msg_0_}" == *+* ]]; then
      git_status="%{$fg[yellow]%}*"
    fi
    
    GIT_INFO=" %{$fg[green]%}${branch_icon}${vcs_info_msg_0_}${git_status}%{$reset_color%}"
  fi
}

PS1=$'%{$fg[cyan]%}%~%{$reset_color%}${GIT_INFO}\n%{$fg[white]%}${arrow_icon}%{$reset_color%} '
RPS1=''

eval "$(zoxide init zsh)"
eval $(opam env)

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

