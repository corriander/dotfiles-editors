setlocal smartindent			" Respect list indenting a little
setlocal formatoptions+=n		" more, not perfect but eases things.

" TODO: this is (more than) a bit poor, want multiple target format
setlocal makeprg=/home/alex/.cabal/bin/pandoc\ %\ >/tmp/%<.html
