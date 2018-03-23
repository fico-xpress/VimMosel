" Vim global plugin file
" Language:	VDL
" Maintainer:	Susanne Heipcke
" Last Change:	Nov 2017

" Define the file type "vdl"
augroup filetype
 au! BufRead,BufNewFile *.vdl set filetype=vdl
augroup END

" Enable automatic file type detection
filetype plugin on
