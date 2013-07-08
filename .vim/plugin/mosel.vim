" Vim global plugin file
" Language:	Mosel
" Maintainer:	Yves Colombani
" Last Change:	8, April 2002

" Define the file type "mosel"
augroup filetype
 au! BufRead,BufNewFile *.mos set filetype=mosel
augroup END

" Enable automatic file type detection
filetype plugin on
