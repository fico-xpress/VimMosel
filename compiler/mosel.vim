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

" We want to compile against the reference packages
" So first search is in the staging directories, then the source and at last
" the current directory
let $MOSEL_DSO="build/mosel/;build/staging/model_resources;src/main/mosel/;."

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

