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
set nowrap                 " do not wrap by default
set number                 " add line numbers
highlight LineNr ctermfg=grey

autocmd FileType yml setlocal ai ts=2 sw=2 et
autocmd FileType yaml setlocal ai ts=2 sw=2 et


" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif


" Persistent undo
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile


"" Vundle
filetype off

set rtp+=~/.config/nvim/bundle/Vundle.vim  " set the runtime path to include Vundle
call vundle#begin('~/.config/nvim/bundle') " and initialize

Plugin 'VundleVim/Vundle.vim' " let Vundle manage Vundle, required
""Plugin 'vim-syntastic/syntastic'
Plugin 'airblade/vim-gitgutter'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'w0rp/ale'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'pearofducks/ansible-vim'
Plugin 'neoclide/coc.nvim'

call vundle#end() " All of your Plugins must be added before the following line

filetype plugin indent on  " allows auto-indenting depending on file type

autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif

runtime coc.vim
nnoremap <M-l> :set nonumber signcolumn=no <BAR> :GitGutterDisable <BAR> :ALEDisable <BAR> :CocDisable <CR>
