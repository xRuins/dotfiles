# ----------------------------------------
# Foundation
# ----------------------------------------

export PAGER='less'
export EDITOR='emacs'

# ヒストリ
HISTFILE=~/.zsh_history
HISTSIZE=65536
SAVEHIST=65536

# 大文字と小文字を区別しない
export CASE_SENSITIVE="false"

SH=`basename $SHELL`

# ----------------------------------------
# path configuration
# ----------------------------------------

ADDITIONAL_PATH=($HOME/local/bin $HOME/bin /usr/local/bin /usr/local/sbin $HOME/google-cloud-sdk/bin)
for p in $ADDITIONAL_PATH; do
    if [ -e $p ]; then
	    export PATH="$p:$PATH"
    fi
done

# ----------------------------------------
# zsh built-in functjion
# ----------------------------------------

setopt auto_param_slash      # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
setopt mark_dirs             # ファイル名の展開でディレクトリにマッチした場合 末尾に / を付加
setopt list_types            # 補完候補一覧でファイルの種別を識別マーク表示 (訳注:ls -F の記号)
setopt auto_menu             # 補完キー連打で順に補完候補を自動で補完
setopt auto_param_keys       # カッコの対応などを自動的に補完
setopt magic_equal_subst     # コマンドラインの引数で --prefix=/usr などの = 以降でも補完できる
setopt complete_in_word      # 語の途中でもカーソル位置で補完
setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示
setopt print_eight_bit       # 日本語ファイル名等8ビットを通す
setopt globdots              # ドットの指定なしで.から始まるファイルをマッチ
setopt list_packed           # リストを詰めて表示
setopt auto_cd               # ディレクトリ名だけでcd
setopt auto_pushd            # pushdの自動化(cd -[tab]用)
setopt correct               # コマンド名をtypoした時に修正するか尋ねる
# setopt prompt のスタイル変更
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [No/Yes/Abort/Edit]"
setopt list_packed           # 補完リストを詰めて表示する
setopt noautoremoveslash     # ディレクトリ名の末尾の/を除去しない
setopt nolistbeep            # 補完リストを表示した際のbeepを無効化
setopt complete_aliases      # aliasも補完対象とする
setopt share_history         # 端末間で履歴を共有
# 履歴に残すコマンドの重複を排除
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt hist_save_no_dups
setopt nonomatch

unsetopt bg_nice             # バックグラウンドジョブを通常の優先度で実行

autoload -Uz add-zsh-hook
autoload -Uz colors

# ----------------------------------------
# Appearance
# ----------------------------------------

# ls の色付け指定
unset LSCOLORS
case "${TERM}" in
    xterm)
	    export TERM=xterm-color
	    ;;
    kterm)
	    export TERM=kterm-color
	    # set BackSpace control character
	    stty erase
	    ;;
    cons25)
	    unset LANG
	    export LSCOLORS=ExFxCxdxBxegedabagacad
	    export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
	    zstyle ':completion:*' list-colors \
	           'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
	    ;;
esac

# ---------------------------------------
#  anyenv
# ----------------------------------------

if [ -d ${HOME}/.anyenv ] ; then
    export PATH="$HOME/.anyenv/bin:$PATH"
    eval "$(anyenv init -)"
    for D in `ls $HOME/.anyenv/envs`
    do
        export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
    done
fi

# ----------------------------------------
#  go
# ----------------------------------------

export GOPATH=$HOME

# ----------------------------------------
#  direnv
# ----------------------------------------

if type "direnv" > /dev/null 2>&1; then
    eval "$(direnv hook zsh)"
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

# ----------------------------------------
#  initialize prompt theme
# ----------------------------------------

zstyle ':prezto:load' zfunction 'zargs' 'zmv'
zstyle ':prezto:module:utility:ls'    color 'yes'
zstyle ':prezto:module:utility:diff'  color 'yes'
zstyle ':prezto:module:utility:wdiff' color 'yes'
zstyle ':prezto:module:utility:make'  color 'yes'
zstyle ':prezto:load' pmodule \
  'environment' \
  'terminal' \
  'editor' \
  'history' \
  'directory' \
  'spectrum' \
  'utility' \
  'completion' \
  'git' \
  'syntax-highlighting' \
  'prompt'
zstyle ':prezto:module:prompt' theme 'paradox'

prompt paradox

# TAB補完の機能をaliasにも追加
_Z_CMD=j
compctl -U -K _z_zsh_tab_completion $_Z_CMD


# ----------------------------------------
# Completion
# ----------------------------------------

fpath=(~/.zsh/completion $fpath)

zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
