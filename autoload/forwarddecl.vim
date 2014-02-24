" Vim autoload file for the forwarddecl plugin.
" Maintainer: Sebastien Lannez <sebastienlannez@fico.com>
" Last Change: 2014 Feb 24
"
" Additional contributors:
"
"

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo-=C

func! forwarddecl#ForwardDeclaration(line1, line2)
	" ***** Processing constraints *****
	" Convert constraints (simple conditional + singleline)
	%s/subject to \(\w*\)\s*{\(\w*\) in \(.*\)\s*:\s*\(.*\)}\s*:\s*\(\_..*\);/forall (\2 in \3 | \4) \1(\2) := \5/
	" Convert constraints (simple conditional + multiline)
	%s/subject to \(\w*\)\s*{\(\w*\) in \(.*\)\s*:\s*\(.*\)}\s*:\s*\(\_..*\);/forall (\2 in \3 | \4) do\r\1(\2) := \5\rend-do/
	" Convert constraints (no conditional + singleline)
	%s/subject to \(\w*\)\s*{\(\w*\) in \(.*\)}\s*:\s*\(\_..*\);/forall (\2 in \3) do\r\1(\2) := \4\rend-do/

	" ***** Processing variables *****
	%s/var\s\+\(.*\)\s\+{\(.*\)}\s*;/\1: array(\2) of nlctr/
	" Multi line
	" %s/var\s\+\(.*\)\s\+{\(\w*\) in \(.*\)\([:\s].*\)\?}\s*=\s*\(\_..*\);/\1: array(\3) of nlctr\rforall(\2 in \3 \4) do\r\1(\2) := \5\r end-do\r/
	" Single line
	%s/var\s\+\(.*\)\s\+{\(\w*\) in \(.*\)\([:\s].*\)\?}\s*=\s*\(\_..*\);/\1: array(\3) of nlctr\rforall(\2 in \3 \4) \1(\2) := \5/
	" Single variable
	%s/var\s\+\(\w*\);/\1: mpvar/

	" ***** Processing sets *****
	%s/\<set\s\+\(\w*\)\s\+:=\s\+\(.*\);/\1 = \2/
	" Replace set unions
	%s/\(\w*\) union \(\w*\)/\1 + \2/g

	" ***** Processing objective *****
	%s/\(minimize\|maximize\)\s\+\(\w*\)\s*:\(.*\);\(\_.*\)solve\s*;/\2 := \3\r\4\r\1(\2)/

	" ***** Processing simple parameters *****
	%s/param \(\w*\) := \(\w*\);/\1 = \2/
	%s/param \(\w*\) {\(.*\)};/\1: array(\2) of ???/
	
	" Replace all sq-brackets by parentheses
	%s/\[\(\w*\)\]/(\1)/g

	" Replace all sum by mosel sum
	%s/sum\s*{\(.*\)}/sum (\1)/g

	" Replace all max by mosel maxlist
	%s/max\s*{\(.*\)}\s*\(.*\)/max (\1) (\2)/g
	%s/min\s*{\(.*\)}\s*\(.*\)/min (\1) (\2)/g
	%s/max\s*(\(.*\))/maxlist(\1)/g
	%s/min\s*(\(.*\))/minlist(\1)/g

	" Replace let by forall
	" Multiline
	"%s/let {\(.*\)} \(.*\);/forall (\1) do\r\2\rend-do/
	" Single line
	%s/let {\(.*\)} \(.*\);/forall (\1) \2/g

	" Replace let by assignment
	%s/let \(.*\)\s*:=\s*\(.*\);/\1 := \2/

	" Replace some simple display
	%s/display\s\+\(.*\);/writeln("\1=",\1)/

	" Append standard vim settings at the end of the file
	%s/^\%$/! vim: /
	%s/.*vim:.*\%$/! vim: et:ts=2:sw=2:sts=2:ft=mosel/

	" Remove semicolon at end of line
	%s/;\s*$//g
	
	" Change one line comment
	%s/#/!/g

	" Replace standard functions
	%s/atan\s*(/arctan(/g
	%s/acos\s*(/arccos(/g

	" Format the whole buffer
	%=

endfunc
