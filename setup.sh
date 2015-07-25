#!/bin/zsh

DOT_FILES=( .zshrc .gitconfig .gitignore .tmux.conf .emacs.d .vimperatorrc .oh-my-zsh .subversion .zsh )

DISCARD_FILES=( .emacs .emacs.el .emacs.elc )

# 不要なファイルをバックアップして捨てる
for discard in ${DISCARD_FILES[@]}
do
   if [ -e $HOME/$discard ]; then
       mv -f $HOME/$discard $HOME/${discard}.old.`date +%y%m%d`
   fi
done


# シンボリックリンクをはる
echo 'Make symbolic links...'

for file in ${DOT_FILES[@]}
do
    rm -rf $HOME/$file
    ln -s $HOME/dotfiles/$file $HOME/$file
done

touch ~/.z

# Submodule の初期化
echo 'Fetching submodules...'
git submodule init
git submodule update --remote
