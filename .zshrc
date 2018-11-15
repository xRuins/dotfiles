# ----------------------------------------
# Foundation
# ----------------------------------------

PAGER='less'
EDITOR='emacs'
CASE_SENSITIVE="false"

# shell comamnd history
HISTFILE=~/.zsh_history
HISTSIZE=65536
SAVEHIST=65536

SH=`basename $SHELL`

# ----------------------------------------
#  completion
# ----------------------------------------

fpath=(~/.zsh/completion $fpath)

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# ----------------------------------------
#  initialize prompt theme
# ----------------------------------------

zstyle ':prezto:load' pmodule 'git'
zstyle ':prezto:load' zfunction 'zargs' 'zmv'
zstyle ':prezto:module:prompt' theme 'paradox' pwd-length 'short'
zstyle ':prezto:module:utility:ls'    color 'yes'
zstyle ':prezto:module:utility:diff'  color 'yes'
zstyle ':prezto:module:utility:wdiff' color 'yes'
zstyle ':prezto:module:utility:make'  color 'yes'

# ----------------------------------------
#  zplug
# ----------------------------------------

source $HOME/dotfiles/zplug/init.zsh

ENHANCD_FILTER=peco
zplug "b4b4r07/enhancd", use:init.sh, frozen:1
zplug "glidenote/hub-zsh-completion", frozen:1
zplug "modules/prompt", from:prezto, frozen:1
zplug "modules/utility", from:prezto, frozen:1
zplug "rupa/z", use:z.sh, frozen:1
zplug "sorin-ionescu/prezto", frozen:1
zplug "zdharma/zsh-diff-so-fancy", as:command, use:bin/git-dsf, frozen:1
zplug "zplug/zplug", hook-build:'zplug --self-manage', frozen:1
zplug 'Valodim/zsh-curl-completion', frozen:1
zplug 'b4b4r07/pkill.sh', as:command, use:'pkill.sh', rename-to:'pk', frozen:1

zplug "zsh-users/zsh-completions", defer:0, frozen:1
zplug "changyuheng/fz", defer:1, frozen:1
zplug "zsh-users/zsh-syntax-highlighting", defer:2, frozen:1

zplug 'b4b4r07/epoch-cat', \
      as:command, \
      hook-build:'go get -d && go build', frozen:1
zplug "junegunn/fzf-bin", \
      as:command, \
      from:gh-r, \
      rename-to:"fzf", frozen:1
zplug "moncho/dry", \
      as:command, \
      from:gh-r, \
      rename-to:"dry", frozen:1
zplug "stedolan/jq", \
      as:command, \
      from:gh-r, \
      rename-to:jq, frozen:1
zplug "peco/peco", \
      as:command, \
      from:gh-r, frozen:1
zplug "motemen/ghq", \
      as:command, \
      from:gh-r, \
      rename-to:ghq, frozen:1
zplug "b4b4r07/git-br", \
      as:command, \
      use:'git-br', frozen:1
zplug "b4b4r07/httpstat", \
      as:command, \
      use:'(*).sh', \
      rename-to:'$1', frozen:1
zplug "jhawthorn/fzy", \
      as:command, \
      hook-build:"make && sudo make install", frozen:1

# ----------------------------------------
#  zplug
# ----------------------------------------

if [ ! ~/.zplug/last_zshrc_check_time -nt ~/.zshrc ]; then
    touch ~/.zplug/last_zshrc_check_time
    if ! zplug check --verbose; then
        printf "Install? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
fi

zplug load

# ----------------------------------------
# path configuration
# ----------------------------------------

ADDITIONAL_PATH=($HOME/local/bin $HOME/bin /usr/local/bin /usr/local/sbin $HOME/google-cloud-sdk/bin)
for p in $ADDITIONAL_PATH; do
    if [ -e $p ]; then
	PATH="$p:$PATH"
    fi
done

# ----------------------------------------
# zsh built-in function
# ----------------------------------------

setopt \
    auto_param_slash \
    mark_dirs \
    list_types \
    auto_menu \
    auto_param_keys \
    magic_equal_subst \
    complete_in_word \
    always_last_prompt \
    print_eight_bit \
    globdots \
    list_packed \
    auto_cd \
    auto_pushd \
    correct \
    list_packed \
    noautoremoveslash \
    nolistbeep \
    complete_aliases \
    share_history \
    hist_ignore_all_dups \
    hist_ignore_dups \
    hist_save_no_dups \
    nonomatch

# setopt prompt のスタイル変更
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"

autoload -Uz add-zsh-hook
autoload -Uz is-at-least
autoload -Uz colors

# ----------------------------------------
# Less
# ----------------------------------------

LESS='-R'

# for unix
SRC_HIGHLIGHT_PATH="/usr/share/source-highlight/src-hilite-lesspipe.sh"
[ -x ${SRC_HIGHLIGHT_PATH} ] && export LESSOPEN="| ${SRC_HIGHLIGHT_PATH} %s"

# for macOS w/ homebrew script
SRC_HIGHLIGHT_PATH_OSX="/usr/local/bin/src-hilite-lesspipe.sh"
[ -x ${SRC_HIGHLIGHT_PATH_OSX} ] && export LESSOPEN="| ${SRC_HIGHLIGHT_PATH_OSX} %s"

# ---------------------------------------
#  anyenv
# ----------------------------------------

if [ -d ${HOME}/.anyenv ]; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init - $SH)"
fi

# ----------------------------------------
#  go
# ----------------------------------------

export GOPATH=$HOME

# ----------------------------------------
#  direnv
# ----------------------------------------

if type "direnv" > /dev/null 2>&1; then
    eval "$(direnv hook $SH)"
fi

# ----------------------------------------
#  Homebrew
# ----------------------------------------

# brewコマンドが実行可能な場合のみ適用する
if type "brew" > /dev/null 2>&1; then
    # brew file 用のwrapper
    if [ -f $(brew --prefix)/etc/brew-wrap ];then
        source $(brew --prefix)/etc/brew-wrap
    fi
fi

# ----------------------------------------
#  history search with peco
# ----------------------------------------

if type "peco" > /dev/null 2>&1; then
    function peco-history-selection() {
        BUFFER=`history -n 1 | reverse | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
    }

    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
fi

# ----------------------------------------
#  gcloud
# ----------------------------------------

if type "gcloud" > /dev/null 2>&1; then
    GCLOUD_EXECUTABLE_PATH=`where gcloud`
    GCLOUD_BINDIR_PATH=`dirname $GCLOUD_EXECUTABLE_PATH`
    GCLOUD_BASE_PATH=`dirname $GCLOUD_BINDIR_PATH`

    source "$GCLOUD_BASE_PATH/path.$SH.inc" > /dev/null 2>&1
    source "$GCLOUD_BASE_PATH/completion.$SH.inc" > /dev/null 2>&1
fi

# ----------------------------------------
#  include
# ----------------------------------------

source ~/dotfiles/.zsh/.zshrc.alias > /dev/null 2>&1
source ~/.zshrc.local > /dev/null 2>&1
