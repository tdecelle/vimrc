" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2016 Mar 25
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file (restore to previous version)
  set undofile		" keep an undo file (undo changes after closing)
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

if has('langmap') && exists('+langnoremap')
  " Prevent that the langmap option applies to characters that result from a
  " mapping.  If unset (default), this may break plugins (but it's backward
  " compatible).
  set langnoremap
endif


" Add optional packages.
"
" The matchit plugin makes the % command work better, but it is not backwards
" compatible.
packadd matchit

" MY VIM SETTINGS

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
" Plug 'tpope/vim-sensible' " basic vim configuration
Plug 'morhetz/gruvbox' " color scheme
Plug 'Valloric/YouCompleteMe' " helps autocomplete in vim
Plug 'posva/vim-vue' " gives vue syntax
Plug 'ap/vim-css-color' " changes css color names to their color
Plug 'leafgarland/typescript-vim' " typescript highlighting
Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ } " For language server protocol
Plug 'mileszs/ack.vim' " fuzzy finder for lines NOT SURE IF IT WORKS
Plug 'vim-airline/vim-airline' " Status bar
Plug 'dart-lang/dart-vim-plugin'
Plug 'thosakwe/vim-flutter'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" puts the back up files in my .vim folder (.ext~ files)
	set backupdir=~/.vim/backup

" exits insert mode
	:imap jj <Esc>
" tab will give two spaces for vue files
	autocmd FileType vue setlocal expandtab
	autocmd FileType vue setlocal tabstop=2
	autocmd FileType vue setlocal softtabstop=2
	autocmd FileType vue setlocal shiftwidth=2
" tab will give four spaces for python files
	autocmd FileType python setlocal expandtab
	autocmd FileType python setlocal tabstop=4
	autocmd FileType python setlocal softtabstop=4
	autocmd FileType python setlocal shiftwidth=4
" enable all python syntax highlights
	let g:python_highlight_all = 1
" line numbers
	set number relativenumber
" some autocomplete
	set wildmode=longest,list,full

" removes automatic commenting
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" sets spliting to bottom and right

" has airline display ale
	let g:airline#extensions#ale#enabled = 1

" split navigation
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" removes whitespace on save
	autocmd BufWritePre * %s/\s\+$//e

" example snippet
	" autocmd FileType html inoremap < <>

" stop mouse input
	set mouse=
	set ttymouse=

" stop preview for autocomplete
	set completeopt-=preview

" set for more color
	set termguicolors

" set the colorscheme
	set background=dark
	colorscheme gruvbox

" keep the cursor in the middle of the window
	augroup VCenterCursor
	  au!
	  au BufEnter,WinEnter,WinNew,VimResized *,*.*
		\ let &scrolloff=winheight(win_getid())/2
	augroup END

" Language Server Protocol settings
	set hidden

	let g:LanguageClient_autoStart = 1
	let g:LanguageClient_serverCommands = {
				\ 'python': ['/home/tdecelle/Documents/anaconda3/bin/pyls'],
				\ }
