" NOTE: To source me, :so %, or :so ~/.vimrc outside.

" Default anyway, but probably a good idea to explicitly...
set nocompatible
" Source - http://stackoverflow.com/a/5845583/2921610


" Manage plugins automagically with T Pope's Pathogen:
execute pathogen#infect('vials/{}')
execute pathogen#helptags()
" Extra plugin folders can be appended with comma separation. Yes I
" gave it a dorky name.


syntax on
filetype plugin indent on

set textwidth=70
set tabstop=4
set shiftwidth=4
" Enable Shift-Tab:
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i
" Note: I don't have expandtab enabled, to convert a file to
" whitespace, :%retab 

" Set a coloured column to indicate desired text width.
" Source http://stackoverflow.com/a/3765575
if exists('+colorcolumn')
	set colorcolumn=71
else
	" If no colorcolumn support (--version < 7.3) 
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

colorscheme jellybeans

" Saves on buffer switching
set autowrite
