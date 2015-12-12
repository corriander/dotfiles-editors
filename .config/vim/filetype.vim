" RDF N3 Syntax
if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	au! BufRead,BufNewFile *.n3 setfiletype n3
	au! BufRead,BufNewFile *.ttl setfiletype n3
augroup END
