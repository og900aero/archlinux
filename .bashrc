#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Custom Prompt
PS1='╭─\e[1;32m\u@\h\e[m \e[1;34m\w \e[m
╰─$ '

if [ -f /etc/bash_completion ]; then
    /etc/bash_completion
fi

# # ex - archive extractor
# # usage: ex <file>
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1     ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ftpmobil - ftp to mobil
# usage: ftpmobil ip:port
ftpmobil ()
{
	curlftpfs $1 /home/shyciii/mnt/ftp/ -o user=shyciii:shyciii
}

# Duplikáció eltávolítása a history-ból
shopt -s histappend

export HISTCONTROL=ignoreboth:erasedups
export HISTFILESIZE=3000
export HISTSIZE=3000
export PROMPT_COMMAND="history -n; history -w; history -c; history -r"
tac "$HISTFILE" | awk '!x[$0]++' > /tmp/tmpfile  && tac /tmp/tmpfile > "$HISTFILE"
rm /tmp/tmpfile

# Custom AutoCompletion
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set completion-ignore-case on"
bind "set menu-complete-display-prefix on"

export PATH="$PATH:/home/Data/Linux/Scripts"

export TERM='st-256color'
export EDITOR='micro'

#alias ls="ls --color=auto"
alias ls="exa -lahg --color=always --group-directories-first"
alias vpn_voip="sudo openvpn /home/Data/_GUESTVPN/tm-openvpn.ovpn"
alias less="less -R"
alias update="yay -Syu"
alias cal="cal -m"
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'
alias mobil='jmtpfs /home/shyciii/mnt/android'
alias melogep="xfreerdp -grab-keyboard +clipboard /u:nio /v:192.168.73.14 /size:1905x1035 /a:drive,Data,/home/Data"

pidof bspwm >/dev/null && neofetch --disable gpu || echo
