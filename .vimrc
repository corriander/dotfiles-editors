" NOTE: To source me, :so %, or :so ~/.vimrc outside.

" Default anyway, but probably a good idea to explicitly...
set nocompatible
" Source - http://stackoverflow.com/a/5845583/2921610


" Manage plugins automagically with T Pope's Pathogen:
execute pathogen#infect('vials-enabled/{}')
execute pathogen#helptags()
" Extra plugin folders can be appended with comma separation. Yes I
" gave it a dorky name.


syntax on
filetype plugin indent on

set textwidth=70
set tabstop=4
set shiftwidth=4

" Adjust default formatting options.
set formatoptions+=j				" Comment leader removal on join

" Enable Shift-Tab:
nmap <S-Tab> <<
imap <S-Tab> <Esc><<i
" Note: I don't have expandtab enabled, to convert a file to
" whitespace, :%retab 

" Set a coloured column to indicate desired text width.
" Source http://stackoverflow.com/a/3765575
if exists('+colorcolumn')
	set colorcolumn=+1					" textwidth+1
else
	" If no colorcolumn support (--version < 7.3) 
	au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
endif

" Visualisation
" -------------
nmap <leader>l :set list!<CR>			" Shortcut to set list
set listchars=tab:»·,trail:·			" Whitespace (set list, \l)
let g:jellybeans_term_trans = 1			" Transparent background
colorscheme jellybeans

" Configure vim-pandoc
" use_hard_wraps results in setlocal formatoption=tn in vim-pandoc
let g:pandoc_use_hard_wraps = 1
let g:pandoc_auto_format = 1
" Default bibliography
"let g:pandoc_bibfiles = ['path/to.bib']

" Configure SimpylFold
" let g:SimpylFold_docstring_preview		" This is a little verbose
let g:SimpylFold_fold_docstring = 0			" Don't fold docstrings

" Configure sessions/buffers/windows
" ----------------------------------
set autowrite			" Saves on buffer switching
map <c-j> <c-w>j		" Remap standard window nav to Ctrl+<movement>
map <c-k> <c-w>k
map <c-l> <c-w>l
map <c-h> <c-w>h

" Enable bash aliases
let $BASH_ENV = "~/.bash_aliases"

" Auto-fix trailing whitespace in certain filetypes on buffer write
" See: http://unix.stackexchange.com/a/75438
function! <SID>rStrip()
	let l = line(".")					" Save cursor x,y
	let c = col(".")					" 
	%s/\s\+$//e							" Remove trailing whitespace
	call cursor(l, c)					" Restore cursor
endfun
" Run the rStrip() function every time a buffer is written.
autocmd BufWritePre * if &ft =~ 'python' | call <SID>rStrip() | endif
" Note, I've chosen to do this on every buffer write because my config
" is likely to introduce whitespace during editing (e.g autoindent in
" python). If this were to be fixed, this could be relegated to an
" explicit command for one of occasions, which I'd actually prefer.

