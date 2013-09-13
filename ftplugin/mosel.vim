" Vim filetype plugin file
" Language:	Mosel
" Maintainer:	Yves Colombani
" Last Change:	8, April 2002

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") | finish | endif

let s:mosel_cpo_save = &cpo
set cpo&vim

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

" Automatically add the mos extension when searching for files, like with gf
" or [i
setlocal suffixesadd=.mos

" Guess the working directory from the buffer name
let b:mosel_runpath=expand("%:p:h")

" Add a default status line
set statusline=
set statusline+=%<\                           " cut at start
set statusline+=%2*[%n%H%M%R%W]%*\            " flags and buf no
set statusline+=%-40f\                        " path
set statusline+=%{StatusLineMoselProfile()}\  " current block
set statusline+=%{StatusLineMoselBlock()}\    " current block
set statusline+=%=%1*%y%*%*\                  " file type
set statusline+=%10((%l,%c)%)\                " line and column
set statusline+=%P                            " percentage of file

function! StatusLineMoselBlock()
	" return synIDattr(synID(line("."), col("."), 1), "name")
	return synIDattr(synID(line("."), col("."), 0), "name")
endfunction

function! StatusLineMoselProfile()
  let bname = expand("%") . ".prof" 
  let expr = "^\\s*\\([[:digit:]]*\\)\\s*" .
          \ "\\([[:digit:]]*\\.[[:digit:]]*\\)\\s*" .
          \ "\\([[:digit:]]*\\.[[:digit:]]*\\)\\s*.*$"
  if bufexists(bname)
    let line = getbufline(bname,line("."))[0]
    if line =~ expr
      return substitute(line, expr, "(\\3/\\2)", "")
    endif
  endif
  return ""
endfunction

" Change the :browse e filter to primarily show Mosel files.
if has("gui_win32") && !exists("b:browsefilter")
	let  b:browsefilter="Mosel Files (*.mos)\t*.mos\n" .
				\	"All Files (*.*)\t*.*\n"
endif

" select "mosel" as the compiler
compiler mosel

" Define all global things
if !exists("*Mosel_setcomp")

	" Options for the compiler
	if !exists("g:mosel_compopt")
		let g:mosel_compopt="-g"
	endif

	" Runtime parameters
	if !exists("g:mosel_runparams")
		let g:mosel_runparams=""
	endif

	" default syntax colouring style (0=none, 1=Haiti, 1=IVE, 2=default)
	if !exists("g:mosel_style")
		let g:mosel_style=0
	endif

	" Set the 'makeprg' option
	fun! Mosel_setcomp()
		execute "set makeprg=mosel\\ -s\\ -c\\ \'comp\\ " . g:mosel_compopt . "\\ %\'"
	endfunc

	" Compile then execute a mos file
	fun! s:runmos(p)
		if &filetype != "mosel"
			echo "Not a Mosel file"
		else
			update
			if a:p == ""
				execute "mosel -s -c \"exe " . g:mosel_compopt . " " . % . " " . g:mosel_runparams ." \""
			else
				execute "!cd ". b:mosel_runpath . "; mosel -s -c \"exe " . g:mosel_compopt . " " . expand("%:p") . " " . a:p ." \""
			endif
		endif
	endfunc

	" Compile a mos file (+quickfix)
	fun! s:compmos()
		if &filetype != "mosel"
			echo "Not a Mosel file"
		else
			update
			make
			cwindow
		endif
	endfunc

	" Get options (0=RT parameters, 1=Comp. Options, 2=Exec. Path)
	fun! s:getopts(what)
		if &filetype != "mosel"
			echo "Not a Mosel file"
		else
			if a:what == 0
				let n=inputdialog("Execution Parameters",g:mosel_runparams)
				if n != ""
					let g:mosel_runparams=n
				endif
			elseif a:what == 1
				let n=inputdialog("Compilation options",g:mosel_compopt)
				if n != ""
					let g:mosel_compopt=n
					Mosel_setcomp()
				endif
			elseif a:what == 2
				let n=inputdialog("Execution Directory",b:mosel_runpath)
				if n != ""
					let b:mosel_runpath=n
				endif
			endif
		endif
	endfunc

	" Set Nice colors
	fun! s:moscols(sty)
		if !exists("g:syntax_on")
			syntax on
		else
			set syn=ON
		endif
		if a:sty==0
			if exists("mosel_symbol_operator")
				call Mosel_symbopt(0)
			endif
			hi constant gui=none guifg=black
			hi statement gui=bold guifg=black
			hi comment gui=none guifg=darkgreen
			hi operator gui=bold guifg=black
			hi string gui=none guifg=darkred
		elseif a:sty==1
			if !exists("mosel_symbol_operator")
				call Mosel_symbopt(1)
			endif
			hi statement gui=none guifg=blue
			hi comment gui=none guifg=darkgreen
			hi string gui=none guifg=darkmagenta
			hi constant gui=none guifg=red
			hi operator gui=none guifg=red
		else
			hi clear
		endif
	endfunc

	" Define the menu "Mosel"
	an <silent> 100.10 &Mosel.&Compile :call <SID>compmos()<CR><CR>
	an <silent> 100.20 &Mosel.&Run :call <SID>runmos("")<CR>
	an 100.50 &Mosel.-sep1- <Nop>
	an <silent> 100.55 &Mosel.Compiler\ &Options :call <SID>getopts(1)<CR>
	an <silent> 100.60 &Mosel.Execution\ &Parameters :call <SID>getopts(0)<CR>
	an <silent> 100.60 &Mosel.Execution\ &Directory :call <SID>getopts(2)<CR>
	an 100.70 &Mosel.-sep2- <Nop>
	an <silent> 100.75 &Mosel.&Syntax.&Haiti :call <SID>moscols(0)<CR>
	an <silent> 100.77 &Mosel.&Syntax.&IVE :call <SID>moscols(1)<CR>
	an <silent> 100.79 &Mosel.&Syntax.&default :call <SID>moscols(2)<CR>
	an <silent> 100.85 &Mosel.&Syntax.&off :set syn=OFF<CR>
	an 100.90 &Mosel.Close\ &Error :cclose<CR>

endif

" Add the commands 'Compile' and 'Run'
command! -buffer -narg=? Run call s:runmos(<q-args>)
command! -buffer Compile call s:compmos()

" If syntax is ON, select the right style
if exists("g:syntax_on")
	call s:moscols(g:mosel_style)
endif

let &cpo = s:mosel_cpo_save
unlet s:mosel_cpo_save

set wildignore+=*.bim

map <F9> :!git svn rebase \| tee
map <F11> :!git commit \| tee
map <F12> :!git svn dcommit \| tee

map <F5> :call <SID>compmos()<CR><CR>
map <F6> :!mosel -s -c 'exec %'
map <F7> :!mosel -s -c 'load % ; symbols'

nnoremap <silent> <buffer> ]] :call <SID>Mosel_jump('/^\s*\(procedure\\|function\)')<cr>
nnoremap <silent> <buffer> [[ :call <SID>Mosel_jump('?^\s*\(procedure\\|function\)')<cr>

if !exists('*<SID>Mosel_jump') 
	fun! <SID>Mosel_jump(motion) range
		let cnt = v:count1
		let save = @/    " save last search pattern
		mark '
		while cnt > 0
			silent! exe a:motion
			let cnt = cnt - 1
		endwhile
		call histdel('/', -1)
		let @/ = save    " restore last search pattern
	endfun
endif

" vim: et:ts=2:sw=2:sts=2
