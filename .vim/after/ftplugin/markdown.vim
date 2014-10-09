" Define list markers
setlocal formatoptions+=n
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+\\\|^\\s*\\[^\\ze[^\\]]\\+\\]:
" Unescaped regex (it's a little obnoxious).
" Pattern1: ^\s*\d\+\.\s\+
" Pattern2: ^\s*[-*+]\s\+
" Pattern3: ^\s*\[^\ze[^\]]\+\]:
" WRT Pattern3, this comes from a later version of
" `ftplugin/markdown.vim`. \ze stops the pattern match, a little like
" a lookahead. I added some leading space; it checks for [.*]: and
" treats it like a list as well.

" TODO: this is (more than) a bit poor, want multiple target format
setlocal makeprg=/home/alex/.cabal/bin/pandoc\ %\ >/tmp/%<.html
