" Vim compiler file
" Compiler:	Mosel
" Maintainer:	Sebastien Lannez
" Last Change:	8, April 2002

if exists("current_compiler")
  finish
endif
let current_compiler = "moselsolution"

let s:mosel_cpo_save = &cpo
set cpo&vim

if exists("*Mosel_setcomp")
 call Mosel_setcomp("solution")
endif

setlocal errorformat=%.%#:\ %t\-%n\ %.%#\ (%l%\\,%c)\ %.%#\ `%f':\ %m,
                    \%.%#:\ %t\-%n\ %.%#\ %l\ %.%#\ `%f':\ %m,
		    \%.%#:\ %t\-%n\ %#:\ %m

let &cpo = s:mosel_cpo_save
unlet s:mosel_cpo_save

