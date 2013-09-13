" Vim autoload file for the ampl2mosel plugin.
" Maintainer: Sebastien Lannez <sebastienlannez@fico.com>
" Last Change: 2013 Sep 12
"
" Additional contributors:
"
"	      Original by Bram Moolenaar <Bram@vim.org>

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo-=C

func! ampl2mosel#Convert2MOSEL(line1, line2)
	" Convert constraints
	%s/subject to \(\w*\)\s*{\(\w*\) in \(\w*\)\s*\(:\s*.*\)*}/forall (\2 in \3 | \4) do\r\1(\2) :=/g
	" Replace all sq-brackets by parentheses
	%s/\[\(\w*\)\]/(\1)/g
	" Replace all sum by mosel sum
	%s/sum\s*{\(.*\)}/sum (\1)/g
	" Replace all max by mosel maxlist
	%s/max\s*{\(.*\)}\s*\(.*\)/max (\1) (\2)/g
	%s/min\s*{\(.*\)}\s*\(.*\)/min (\1) (\2)/g
	" Remove semicolon at end of line
	%s/;\s*$//g
	" Replace let by forall
	%s/let {\(.*\)} \(.*\)$/forall (\1) do\r\2\rend-do/g
	" Replace let by assignment
	%s/let \(.*\)\s*:=\s*\(.*\)$/\1 := \2/g
endfunc
