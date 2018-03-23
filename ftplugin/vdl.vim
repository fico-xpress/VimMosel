" Vim filetype plugin file
" Language:	VDL
" Maintainer:	Susanne Heipcke
" Last Change:	Nov 2017

" Only do this when not done yet for this buffer
if exists("b:did_ftplugin")
  finish
endif
" Don't load another plugin for this buffer
let b:did_ftplugin = 1

let s:vdl_cpo_save = &cpo
set cpo&vim

" Make sure the continuation lines below do not cause problems in
" compatibility mode.
set cpo-=C

" Automatically add the vdl extension when searching for files, like with gf
" or [i
setlocal suffixesadd=.vdl

setlocal commentstring=<!--%s-->
setlocal comments=s:<!--,m:\ \ \ \ \ ,e:-->

setlocal formatoptions-=t
if !exists("g:ft_xml_autocomment") || (g:ft_xml_autocomment == 1)
    setlocal formatoptions+=croql
endif

" XML:  thanks to Johannes Zellner and Akbar Ibrahim
" - case sensitive
" - don't match empty tags <fred/>
" - match <!--, --> style comments (but not --, --)
" - match <!, > inlined dtd's. This is not perfect, as it
"   gets confused for example by
"       <!ENTITY gt ">">
if exists("loaded_matchit")
    let b:match_ignorecase=0
    let b:match_words =
     \  '<:>,' .
     \  '<\@<=!\[CDATA\[:]]>,'.
     \  '<\@<=!--:-->,'.
     \  '<\@<=?\k\+:?>,'.
     \  '<\@<=\([^ \t>/]\+\)\%(\s\+[^>]*\%([^/]>\|$\)\|>\|$\):<\@<=/\1>,'.
     \  '<\@<=\%([^ \t>/]\+\)\%(\s\+[^/>]*\|$\):/>'
endif

" Change the :browse e filter to primarily show VDL files.
if has("gui_win32") && !exists("b:browsefilter")
    let  b:browsefilter="VDL Files (*.vdl)\t*.vdl\n" .
		\	"HTML Files (*.html)\t*.html\n" .
		\	"All Files (*.*)\t*.*\n"
endif

" Set Xpress colors
 if !exists("g:syntax_on")
  syntax on
 else
  set syn=ON
 endif
  hi statement gui=none guifg=blue
  hi annotation gui=bold guifg=darkgray
  hi comment gui=italic guifg=darkgreen
  hi string gui=none guifg=darkmagenta
  hi constant gui=none guifg=red
  hi operator gui=none guifg=red


" Undo the stuff we changed.
let b:undo_ftplugin = "setlocal commentstring< comments< formatoptions<" .
		\     " | unlet! b:match_ignorecase b:match_words b:browsefilter"

let &cpo = s:vdl_cpo_save
unlet s:vdl_cpo_save

