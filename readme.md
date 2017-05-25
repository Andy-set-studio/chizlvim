# HankChizlJaw's Vim Setup

Here's how to setup Vim how I personally like it:

1. Make a directory for Vim stuff by running `mkdir ~/.vim`
2. Get into that directory by running `cd ~/.vim`
3. Clone this repo into that directory by running `git clone https://github.com/hankchizljaw/chizlvim.git .`
4. Now make a symlink for the `.vimrc` that Vim looks for by running `ln -s ~/.vim/vimrc ~/.vimrc`
5. Install vundle by running `git clone https://github.com/VundleVim/Vundle.vim.git
   ~/.vim/bundle/Vundle.vim`
6. Install jshint globally by running `npm install -g jshint`
7. Launch vim and run `:PluginInstall`

Open Vim and enjoy! 🚀
