" Vim autoload file for the Mosel language
" License:     LICENSE.vimmosel.txt
" Author:      Sebastien Lannez 
" Maintainer:  Sebastien Lannez
" Last Change: 12, September 2013

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo-=C

func! Mosel#UpdateForwardDeclaration(line1, line2)
	" ***** Get list of public functions and procedures *****
	" Convert constraints (simple conditional + singleline)

	" Copy/paste whole buffer to cpliboard
	%y+
	new
	put

	" Only keep public procedure/function
	v/^\s*public procedure\|^\s*public function/d

	" Prefix with forward keyword
	%s/public/forward public/

	" Sort alphabetically
	%sort

	" Format the whole buffer
	%=

	" Yank everything
	%y+

endfunc
