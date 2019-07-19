set nocompatible           " Disable compatibility to old-time vi
set showmatch              " Show matching brackets                                        
set ignorecase             " Case insensitive matching
set mouse=v                " middle-click paste with mouse
set hlsearch               " highlight search results
set tabstop=4              " Width of tab
set softtabstop=4          " see multiple spaces as tabstops so <BS> does the right thing
set expandtab              " convert tabs to spaces
set shiftwidth=4           " width for automatic indent
set autoindent             " indent a new line automatically
set wildmode=longest,list  " get bash-like tab completions

set number                 " add line numbers
:highlight LineNr ctermfg=grey


"" Vundle
filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin('~/.config/nvim/bundle')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'airblade/vim-gitgutter'


" All of your Plugins must be added before the following line
call vundle#end()
filetype plugin indent on  " allows auto-indenting depending on file type

