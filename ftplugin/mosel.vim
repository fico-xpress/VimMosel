" Vim filetype plugin file
" 
" License: LICENSE.vimmosel.txt
" Language:	Mosel
" Author: Yves Colombani
" Maintainer:  Sebastien Lannez
" Last Change:  01, Feb. 2018
"

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin") | finish | endif

let s:mosel_cpo_save = &cpo
set cpo&vim

" Don't load another plugin for this buffer
let b:did_ftplugin = 1

" Automatically add the mos extension when searching for files, like with gf
" or [i
setlocal suffixesadd=.mos

" Ignore bim files
set wildignore+=*.bim

" Guess the working directory from the buffer name
let b:mosel_runpath=expand("%:p:h")
let b:mosel_xpdir=$XPRESSDIR

" Microsoft Visual Studio configuration
let b:mosel_mvscver="11.0"
let b:mosel_mvscarch="amd64\\"

" Setup Visual Studio
if has("gui_win32") && exists("b:mosel_mvscver")
  let $VCDIR="C:\\Program Files (x86)\\Microsoft Visual Studio ".b:mosel_mvscver."\\VC\\"

  " C Compiler
  let $PATH=$VCDIR."BIN\\".b:mosel_mvscarch.";".$PATH
  let $INCLUDE=$VCDIR."include\\;".$INCLUDE
  let $LIB=$VCDIR."lib\\".b:mosel_mvscarch.";".$LIB
  let $LIBPATH=$VCDIR."lib\\".b:mosel_mvscarch.";".$LIBPATH

  " Windows SDK
  " let $PATH=$VCSDK."BIN\\;".$PATH
  let $INCLUDE="C:\\Program Files (x86)\\Windows Kits\\8.0\\Include\\um\\;".$INCLUDE
  let $LIB="C:\\Program Files (x86)\\Windows Kits\\8.0\\Lib\\win8\\um\\x64\\;".$LIB
  " let $LIBPATH=$VCSDK."lib\\;".$LIBPATH

endif

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
  return synIDattr(synID(line("."), col("."), 1), "name") . '|' .
        \ synIDattr(synID(line("."), col("."), 0), "name")
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

  " Make sure to call the right compiler
  if !exists("g:mosel_cmd")
    let g:mosel_cmd=expand(b:mosel_xpdir."/bin/mosel")
  endif

  " Sets some usefull MOSEL_DSO. Note: should move as an option
  let $MOSEL_DSO = "target/mosel/;target/test/;src/main/mosel/;src/test/mosel/;."

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
  fun! Mosel_setcomp(p)
    if a:p == "solution"
      let &mp=g:mosel_cmd." make "
    else
      let &mp=g:mosel_cmd." compile ".g:mosel_compopt." \"".expand("%")."\""
    endif
endfunc

  " Compile then execute a mos file
  fun! s:mosexec(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if a:p == ""
        execute "!".g:mosel_cmd." execute " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif a:p == "3.4"
        execute "!".g:mosel_cmd." -s -c \"exe ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"exe ".g:mosel_compopt." \"".expand("%")."\" ".a:p." \""
      endif
    endif
  endfunc

  " Compile then profile a mos file
  fun! s:mosprof(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if a:p == "3.4"
        execute "!".g:mosel_cmd." -s -c \"profile ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!".g:mosel_cmd." profile " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      endif
    endif
  endfunc

  " Compile then debug a mos file
  fun! s:mosdebug(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if a:p == ""
        execute "!".g:mosel_cmd." debug " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif a:p == "3.4"
        execute "!".g:mosel_cmd." -s -c \"debug ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"debug ".g:mosel_compopt." \"".expand("%")."\" ".a:p." \""
      endif
    endif
  endfunc
  " Execute all commands in the file
  fun! s:mostest(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if a:p == ""
        execute "!".g:mosel_cmd." execute " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif a:p == "3.4"
        execute "!".g:mosel_cmd." -s -c \"exe ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"exe ".g:mosel_compopt." \"".expand("%")."\" ".a:p." \""
      endif
    endif
  endfunc

  " Compile a mos file (+quickfix)
  fun! s:moscomp()
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      make
      cwindow
    endif
  endfunc

  " Compile a mos file (+quickfix) into an executable
  fun! s:moscompexe()
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      make
      cwindow
      execute "!" .g:mosel_cmd. " compile " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams . " -o deploy.exe:" .expand("%:r")
    endif
  endfunc

  " Execute all commands in the file
  fun! s:mosmake()
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      execute "!".g:mosel_cmd." make"
      cwindow
    endif
  endfunc

  " Examine a module 
  fun! s:mosexam()
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      execute "!".g:mosel_cmd." examine <cword>"
    endif
  endfunc

  " Load module
  fun! s:mosload()
    if &filetype != "mosel"
     echo "Not a Mosel file"
   else
     execute "!".g:mosel_cmd." -s -c 'cload -G % ; profile'"
   endif
 endfunc


" Get options (0=RT parameters, 1=Comp. Options, 2=Exec. Path, 3=Xpress dir and Mosel command)
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
          call Mosel_setcomp("")
   endif
  elseif a:what == 2
   let n=inputdialog("Execution Directory",b:mosel_runpath)
   if n != ""
    let b:mosel_runpath=n
   endif
      elseif a:what == 3
        let n=inputdialog("Xpress Directory",b:mosel_xpdir)
        if n != ""
          let b:mosel_xpdir=n
          let $XPRESSDIR=b:mosel_xpdir
          let g:mosel_cmd=expand(b:mosel_xpdir."/bin/mosel")
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
  " Workbench
  if !exists("mosel_symbol_operator")
   call Mosel_symbopt(1)
  endif
  hi statement gui=none guifg=blue
  hi moselOperator gui=none guifg=blue
  hi moselFunction gui=none guifg=blue
  hi comment gui=none guifg=darkgreen
  hi moselComment gui=none guifg=darkgreen
  hi moselString gui=none guifg=darkred
  hi annotation gui=bold guifg=darkgray
  hi moselAnnot gui=none guifg=darkgray
  hi moselAnCom gui=bold guifg=darkgray
  hi constant gui=none guifg=red
  hi operator gui=none guifg=red

 elseif a:sty==1
  " IVE
  if !exists("mosel_symbol_operator")
   call Mosel_symbopt(1)
  endif
  hi statement gui=none guifg=blue
  hi annotation gui=bold guifg=darkgray
  hi comment gui=italic guifg=darkgreen
  hi string gui=none guifg=darkmagenta
  hi constant gui=none guifg=red
  hi operator gui=none guifg=red
 elseif a:sty==2
  " default
  if !exists("mosel_symbol_operator")
   call Mosel_symbopt(1)
  endif
  hi annotation gui=none guifg=darkgreen
  hi comment gui=none guifg=darkgreen
 else
  hi clear
 endif
endfunc

" Define the menu "Mosel"
an <silent> 100.10 &Mosel.&Compile :call <SID>moscomp()<CR><CR>
an <silent> 100.20 &Mosel.&Run :call <SID>mosexec("")<CR>
an <silent> 100.20 &Mosel.&Profile :call <SID>mosprof("")<CR>
an 100.50 &Mosel.-sep1- <Nop>
an <silent> 100.55 &Mosel.Compiler\ &Options :call <SID>getopts(1)<CR>
an <silent> 100.60 &Mosel.Execution\ &Parameters :call <SID>getopts(0)<CR>
an <silent> 100.60 &Mosel.Execution\ &Directory :call <SID>getopts(2)<CR>
an <silent> 100.60 &Mosel.Execution\ &Xpress\ Directory :call <SID>getopts(3)<CR>
an 100.70 &Mosel.-sep2- <Nop>
an <silent> 100.75 &Mosel.&Syntax.&Workbench :call <SID>moscols(0)<CR>
an <silent> 100.77 &Mosel.&Syntax.&IVE :call <SID>moscols(1)<CR>
an <silent> 100.79 &Mosel.&Syntax.&default :call <SID>moscols(2)<CR>
an <silent> 100.85 &Mosel.&Syntax.&off :set syn=OFF<CR>
an 100.90 &Mosel.Close\ &Error :cclose<CR>

endif

" Add the commands 'Compile', 'Run', 'Profile' and 'Examine'
command! -buffer -narg=? Run call s:mosexec(<q-args>)
command! -buffer -narg=? Profile call s:mosprof(<q-args>)
command! -buffer -narg=? Debug call s:mosdebug(<q-args>)
command! -buffer Compile call s:moscomp()
command! -buffer Examine call s:mosexam()

" If syntax is ON, select the right style
if exists("g:syntax_on")
 call s:moscols(g:mosel_style)
endif

let &cpo = s:mosel_cpo_save
unlet s:mosel_cpo_save

" map <F9> :!git update \| tee
" map <F10> :!git commit \| tee
" map <F9> :!git svn rebase \| tee
" map <F12> :!git svn dcommit \| tee

map <F5> :call <SID>moscomp()<CR><CR>
map <F6> :call <SID>mosexec("")<CR>
map <F7> :call <SID>mosprof("")<CR>
map <F8> :call <SID>mosexam()<CR><CR>

map <F9> :call <SID>mosdebug("")<CR><CR>

map m<F5> :call <SID>mosmake()<CR>
map m<F6> :call <SID>mostest()<CR>
map m<F8> :vimgrep /^\s*\(public procedure\\|public function\)/ %<CR>:copen<CR>

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
