" Define list markers
setlocal formatoptions+=n
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^\\s*[-*+]\\s\\+

" TODO: this is (more than) a bit poor, want multiple target format
setlocal makeprg=/home/alex/.cabal/bin/pandoc\ %\ >/tmp/%<.html
