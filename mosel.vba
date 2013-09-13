" Vimball Archiver by Charles E. Campbell, Jr., Ph.D.
UseVimball
finish
compiler/mosel.vim	[[[1
31
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

doc/mosel.txt	[[[1
24
*mosel.txt*  Plugin for developing Mosel scripts in Vim.

Author: Sebastien Lannez <sebastien.lannez@gmail.com>
Last Change: September 12, 2013

This plugin is licensed under the terms of the BSD license. Please see
mosel.vim for the license in its entirety.


==============================================================================
Mosel                                       *mosel*

1. Introduction                             |mosel-intro|


For Vim version 7.0 or later.
This plugin only works if 'compatible' is not set.
{Vi does not have any of these features.}

==============================================================================
1. Introduction                             *mosel-intro*

Mosel is a language for mathematical programming.

ftplugin/mosel.vim	[[[1
218
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
map <F6> :!mosel -s -c 'exec %' 2>&1 \| tee

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
indent/mosel.vim	[[[1
122
" Vim indent file
" Language:         Mosel Script
" Maintainer:       sebastien Lannez <sebastien.lannez@gmail.com>
" Latest Revision:  2010-01-06

if exists("b:did_indent")
  finish
endif
let b:did_indent = 1

setlocal indentexpr=GetMoselIndent()
setlocal indentkeys+=0=then,0=do,0=else,0=elif,0=end-if,0=end-case,0=end-do,),0=;;,0=;&
setlocal indentkeys+=0=fin,0=fil,0=fip,0=fir,0=fix
setlocal indentkeys+=0=model,0=package,0=procedure,0=function
setlocal indentkeys+=0=end-model,0=end-package,0=end-procedure,0=end-function
setlocal indentkeys+=0=declarations,0=end-declarations
setlocal indentkeys+=0=requirements,0=end-requirements
setlocal indentkeys+=0=parameters,0=end-parameters
setlocal indentkeys+=0=initialisations,0=end-initialisations
setlocal indentkeys+=0=initializations,0=end-initializations
setlocal indentkeys+=0=repeat,0=until
setlocal indentkeys-=:,0#
setlocal nosmartindent

if exists("*GetMoselIndent")
  finish
endif

let s:cpo_save = &cpo
set cpo&vim

function s:buffer_shiftwidth()
  return &shiftwidth
endfunction

let s:mosel_indent_defaults = {
      \ 'default': function('s:buffer_shiftwidth'),
      \ 'continuation-line': function('s:buffer_shiftwidth') }

function! s:indent_value(option)
  let Value = exists('b:mosel_indent_options')
            \ && has_key(b:mosel_indent_options, a:option) ?
            \ b:mosel_indent_options[a:option] :
            \ s:mosel_indent_defaults[a:option]
  if type(Value) == type(function('type'))
    return Value()
  endif
  return Value
endfunction

function! GetMoselIndent()
  let lnum = prevnonblank(v:lnum - 1)
  if lnum == 0
    return 0
  endif

  let pnum = prevnonblank(lnum - 1)

  let ind = indent(lnum)
  let line = getline(lnum)
  let pline = getline(pnum)

  let synid = synIDattr(synID(lnum, 1, 0), "name")

  " Indent with syntax information
  if synid =~ 'moselComment'
    return ind
  elseif synid =~ 'moselCase'
    if line =~ '^.*:\s*\<do\>'
    elseif line =~ '^.*:\s*$'
      let ind += s:indent_value('default')
      return ind
    else
      let ind -= s:indent_value('default')
      return ind
    endif
  endif

  if line =~ '^\s*\(public\)*\s*\%(model\|package\|procedure\|function\|parameters\|declarations\|initialisations\|initializations\|if\|then\|.*\sdo\|else\|elif\|case\|while\|until\|for\|forall\|repeat\|requirements\)\>'
    if line !~ '\<\%(end-.*\|until\)\>\s*\%(#.*\)\=$'
      let ind += s:indent_value('default')
    endif
  elseif line =~ '\<\%(record\)\>' && line !~ '\<\%(end-record\)\>' 
      let ind += s:indent_value('default')
  elseif line =~ '^\s*\<\k\+\>\s*()\s*{' || line =~ '^\s*{'
    if line !~ '}\s*\%(#.*\)\=$'
      let ind += s:indent_value('default')
    endif
  elseif s:is_continuation_line(line)
    if pnum == 0 || !s:is_continuation_line(getline(pnum))
      let ind += s:indent_value('continuation-line')
    endif
  elseif pnum != 0 && s:is_continuation_line(getline(pnum))
    let ind = indent(s:find_continued_lnum(pnum))
  endif

  let pine = line
  let line = getline(v:lnum)
  if line =~ '^\s*\%(until\|then\|do\|else\|elif\|end-.*\)\>' || line =~ '^\s*}'
    let ind -= s:indent_value('default')
  endif
  if line =~ '^\s*\<end-case\>'
    let ind -= s:indent_value('default')
  endif

  return ind
endfunction

function! s:is_continuation_line(line)
  return a:line =~ '\%(\%(^\|[^\\]\)\\\|&&\|||\)$'
endfunction

function! s:find_continued_lnum(lnum)
  let i = a:lnum
  while i > 1 && s:is_continuation_line(getline(i - 1))
    let i -= 1
  endwhile
  return i
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
plugin/mosel.vim	[[[1
12
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
syntax/mosel.vim	[[[1
256
as" Vim syntax file
" Language: Mosel
" Current Maintainer: Sebastien Lannez <SebastienLannez@fico.com>
" Version: 1.0
" Last Change: July 2013
" Contributors: Yves Colombani <YvesColombani@fico.com>

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case ignore

" List of keyword and operators
syn keyword moselOperator	and div in mod not or sum prod min max
syn keyword moselOperator	inter union
syn keyword moselStatement	is_binary is_continuous is_free is_integer
syn keyword moselStatement	is_partint is_semcont is_semint is_sos1 is_sos2
syn keyword moselStatement	uses options include
syn keyword moselStatement	forall while break next
syn keyword moselStatement	forward
syn keyword moselStatement	to from
syn keyword moselStatement	as
syn keyword moselStatement	else elif then
syn keyword moselStatement	array boolean integer real set string
syn keyword moselStatement	linctr mpvar of dynamic range basis
syn keyword moselStatement	list imports
syn keyword moselStatement	contained
syn keyword moselStatement	version
syn keyword moselConstant	true false

syn keyword moselTodo contained	TODO YCO BUG

" In case someone wants to see the predefined functions/procedures
if exists("mosel_functions")
 syn keyword moselFunction	setparam getparam create fopen fclose
 syn keyword moselFunction	write writeln read readln exists fselect
 syn keyword moselFunction	getfid getsize getfirst getlast substr strfmt
 syn keyword moselFunction	maxlist minlist sqrt sin cos arctan
 syn keyword moselFunction	isodd bittest random log finalize finalise
 syn keyword moselFunction	getsol getobjval getrcost getdual getslack
 syn keyword moselFunction	getact ishidden sethidden gettype settype
 syn keyword moselFunction	getcoeff setcoeff getvars exit fflush
 syn keyword moselFunction	makesos1 makesos2 iseof exportprob
 syn keyword moselFunction	fskipline setrandseed
 syn keyword moselFunction	ceil round
 syn keyword moselFunction	load compile run

 " mmsystem
 syn keyword moselFunction	gettime
 syn keyword moselFunction	fdelete 

 " mmjobs
 syn keyword moselFunction	getfromid modid disconnect 

endif

" (De)Select IVE style
fun! Mosel_symbopt(p)
 if a:p==1
  let mosel_symbol_operator=1
  syn match   moselSymbolOperator      "[:<>+-/*=\^.;]"
  syn match   moselSymbolOpStat        "[\[{}\]]"
  syn match   moselSymbolOpStat        "(!\@!"
  syn match   moselSymbolOpStat        "!\@<!)"
 else
   syn clear moselSymbolOperator
   syn clear moselSymbolOpStat
   unlet mosel_symbol_operator
 endif
endfunc

if exists("mosel_symbol_operator")
 call Mosel_symbopt(1)
endif

" String
  "wrong strings
"  syn region  moselStringError matchgroup=moselStringError start=+'+ end=+'+ end=+$+
"  syn region  moselStringError matchgroup=moselStringError start=+"+ end=+"+ end=+$+ contains=moselStringEscape

  "right strings
  syn match   moselStringEscape	contained '\\.'
  syn region  moselString matchgroup=moselString start=+'+ end=+'+ 
	\ oneline
  syn region  moselString matchgroup=moselString start=+"+ end=+"+ 
	\ oneline contains=moselStringEscape
  " To see the start and end of strings:
" syn region  moselString matchgroup=moselStringError start=+'+ end=+'+ oneline


" Format for identifiers and numbers
"syn match  moselIdentifier	display	"\<[a-zA-Z_][a-zA-Z0-9_]*\>"
syn match  moselNumber	display	"-\=\<\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+\.\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+\.\d\+[eE]-\=\d\+\>"
syn match  moselNumber	display	"-\=\<\d\+[eE]-\=\d\+\>"

" To make <TABS> visible
if exists("mosel_no_tabs")
  syn match moselShowTab "\t"
endif


" List of blocks
syn region moselModel matchgroup=moselStatement 
      \ start=/^\s*model\>/ 
      \ end=/^\s*end-model\>/ 
      \ transparent fold 

syn region moselPackage matchgroup=moselStatement 
      \ start=/^\s*package\>/ 
      \ end=/^\s*end-package\>/ 
      \ transparent fold 

syn cluster mRoot add=moselModel,moselPackage

syn region moselParam matchgroup=moselStatement
      \ start=/^\s*parameters\>/
      \ end=/^\s*end-parameters\>/ 
      \ containedin=moselModel transparent fold

syn region moselDeclr matchgroup=moselStatement
      \ start=/^\s*declarations\>/ 
      \ end=/^\s*end-declarations\>/ 
      \ containedin=@mRoot transparent fold

syn region moselPDecl matchgroup=moselStatement
      \ start=/^\s*public\s*declarations/ 
      \ end=/^\s*end-declarations/ 
      \ containedin=@mRoot transparent fold

syn region moselIniti matchgroup=moselStatement
      \ start=/^\s*initiali[sz]ations\>/ 
      \ end=/^\s*end-initiali[sz]ations\>/ 
      \ containedin=@mRoot transparent fold

syn region moselRequire matchgroup=moselStatement
      \ start=/^\s*requirements\>/ end=/^\s*end-requirements\>/ 
      \ containedin=@mRoot transparent fold

syn region moselRecord matchgroup=moselStatement
      \ start=/\<record\>/ end=/\<end-record\>/ 
      \ containedin=moselParam transparent fold

syn cluster mDatadef add=moselParam,moselDeclr,modelPDecl,moselRequire,moselIniti

syn region moselProc matchgroup=moselStatement
      \ start=/^\s*procedure\s\|^\s*public\s*procedure\s/ end=/^\s*end-procedure/ 
      \ containedin=@mRoot transparent fold

syn region moselFunc matchgroup=moselStatement
      \ start=/^\s*function\s \|^\s*public\s*function\s/ end=/^\s*end-function/
      \ containedin=@mRoot transparent fold

syn cluster mMethod add=moselProc,moselFunc

syn region moselBlock matchgroup=moselStatement
      \ start=/\<do\>/ end=/end-do/ 
      \ containedin=@mRoot transparent fold

syn region moselIf matchgroup=moselStatement
      \ start=/\<if\>/ end=/\<end-if\>/
      \ containedin=@mRoot transparent fold

syn region moselCase matchgroup=moselStatement
      \ start=/\<case\>/ end=/\<end-case\>/
      \ containedin=@mRoot transparent fold

syn region moselBlock matchgroup=moselStatement
      \ start=/\<repeat\>/ end=/\<until\>/ 
      \ contained transparent fold

" Enable manual fodling
syn region moselFold
      \ start="{{{" end="}}}"                 
      \ transparent fold

" Format of comments
syn region moselComment
      \ start="(!" end="!)" contains=moselTodo fold
syn region moselComment
      \ start="!" end="$" contains=moselTodo
syn cluster mComment add=moselComment

" syn match moselIfOneLine "if\s*(.*,.*,.*)\(^then\)"

function! MoselFoldText()
  let nl = v:foldend - v:foldstart + 1
  let line = getline(v:foldstart)
  let comment = line

  let synid = synIDattr(synID(v:foldstart, 10, 0), "name")
  let synid2 = synIDattr(synID(v:foldstart+1, 10, 0), "name")
  if synid =~ 'moselComment'
    let comment = substitute(line,'(!\s*\(.*\)\s*\(!)\)*', '\1', 'g')
  elseif synid2 =~ 'moselComment'
    let line = getline(v:foldstart+1)
    let comment = substitute(line,'(!\s*\(.*\)\s*\(!)\)*', '\1', 'g')
  endif
  endif
  return '+ (' . nl . ' lines) ' . comment
endfunction


" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_mosel_syn_inits")
  if version < 508
    let did_mosel_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink moselComment		Comment
if !exists("mosel_only_comments")
  HiLink moselConstant		Constant
  HiLink moselNumber		Constant
  HiLink moselString		String
  HiLink moselStringEscape	Special
  HiLink moselStringError	Error
  HiLink moselIdentifier	Identifier
  HiLink moselException		Exception
  HiLink moselFunction		Function
  HiLink moselOperator		Operator
  
  HiLink moselStatement		Statement
  HiLink moselIf     		Statement
  HiLink moselIfOneLine		Statement
  HiLink moselCase		Statement

  HiLink moselSymbolOperator	Operator
  HiLink moselSymbolOpStat	Statement
  HiLink moselTodo		Todo
  HiLink moselError		Error
  HiLink moselShowTab		Error

  HiLink mRoot  	        Statement
endif

  delcommand HiLink
endif

syn sync fromstart
set foldtext=MoselFoldText()
set foldmethod=syntax

let b:current_syntax = "mosel"

" vim: ts=8 sw=2
