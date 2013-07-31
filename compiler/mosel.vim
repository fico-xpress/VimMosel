" Vim compiler file
" Compiler:	Mosel
" Maintainer:	Yves Colombani
" Last Change:	8, April 2002

if exists("current_compiler")
  finish
endif
let current_compiler = "mosel"

let s:mosel_cpo_save = &cpo
set cpo&vim

let $MOSEL_DSO=".;src/main/mosel;build/mosel/dso"
if exists("*Mosel_setcomp")
 call Mosel_setcomp()
else
 set makeprg=mosel\ -s\ -c\ \'comp\ -g\ \"%\"\'
endif

setlocal errorformat=%.%#:\ %t\-%n\ %.%#\ (%l%\\,%c)\ %.%#\ `%f':\ %m,
                    \%.%#:\ %t\-%n\ %.%#\ %l\ %.%#\ `%f':\ %m,
		    \%.%#:\ %t\-%n\ %#:\ %m

let &cpo = s:mosel_cpo_save
unlet s:mosel_cpo_save

