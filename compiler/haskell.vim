" Vim compiler file
" Compiler:	Haskell
" Maintainer:	Sebastien Lannez
" Last Change:	20, August 2013

if exists("current_compiler")
  finish
endif
let current_compiler = "haskell"

let s:cpo_save = &cpo
set cpo&vim

set makeprg="ghci %"

setlocal errorformat=%.%#:\ %t\-%n\ %.%#\ (%l%\\,%c)\ %.%#\ `%f':\ %m,
                    \%.%#:\ %t\-%n\ %.%#\ %l\ %.%#\ `%f':\ %m,
		    \%.%#:\ %t\-%n\ %#:\ %m

let &cpo = s:cpo_save
unlet s:cpo_save
