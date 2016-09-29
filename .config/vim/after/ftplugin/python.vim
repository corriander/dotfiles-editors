setlocal tabstop=4						" Screw PEP8, handled by Git
setlocal noexpandtab					" 

setlocal listchars=tab:│༚,trail:⠒
" See http://www.fileformat.info/info/unicode/category/So/list.htm for
" more viable characters. Note this may need degrading on some Vim.

" Custom fold text
" https://github.com/chrisbra/vim_dotfiles/blob/a1a106081884647922395fe4512aa8fcc887d64c/plugin/CustomFoldText.vim
" http://www.gregsexton.org/2011/03/improving-the-text-displayed-in-a-fold/
function! PythonFoldText()
	" TODO: Make this elastic - if winwidth is not wide enough to fit
	" the stats in the margin, then snap them inside the colorcolumn
	" instead.
	" Get the first non-blank line in the folded text.
	let linenum = nextnonblank(v:foldstart)

	if linenum > v:foldend
		let text = getline(v:foldstart)
	else
		let text = substitute(getline(linenum), '\t', repeat(' ', &tabstop), 'g')
	endif

	let linecount = 1 + v:foldend - v:foldstart
	let linecount_fieldwidth = printf("%.0f", log10(line('$')) + 1)
	" Can check for has("float") here and use "(of n lines)" if not
	" present - probably not necessary.
	let linecount_percent = 100.0 * linecount / line('$')

	let stats = printf(" %" . linecount_fieldwidth . "d lines, %4.1f%%", linecount, linecount_percent) 

	" Populate the remaining space in the fold string.
	let foldwidth = &textwidth
	let stats = stats . repeat(' ', floor(log10(linecount_percent)) + 1)
	let minpadding = 5
	let excess = (foldwidth - strwidth(text) - minpadding)
	if excess < 0
		let text = text[:strwidth(text)+excess-1-3] . '...'
	endif

	let padding = ' ' . repeat('-', minpadding - 1) . repeat('-', excess)


	return text . padding . '|' . stats . '   |'
endfunction
set foldtext=PythonFoldText()
