#!/bin/zsh

DOT_FILES=( .zshrc .gitconfig .gitignore .tmux.conf .zsh .rubocop.yml .minttyrc .emacs.d )

# シンボリックリンクをはる
echo 'Make symbolic links...'

for file in ${DOT_FILES[@]}
do
    mv -f $HOME/$file $HOME/$file.bak
    ln -s $HOME/dotfiles/$file $HOME/$file
done

touch ~/.z
