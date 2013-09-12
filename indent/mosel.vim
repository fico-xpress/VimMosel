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
    " let n = substitute(line, '^\\(\\s*\\)[:alnum:]', '\\1', '', '')
    " echomsg 'indent: [' . n . ']'
    " return len(n)
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

  " Support for one line forall
  "
  " if pline =~ '^\s*\%(forall\|for\)'
  "  if pline !~ '\%(do\s*\)$'
  "    let ind -= s:indent_value('default')
  "  endif
  " endif
  
  if line =~ '^\s*\(public\)*\s*\%(model\|package\|procedure\|function\|parameters\|declarations\|initialisations\|initializations\|if\|then\|.*\sdo\|else\|elif\|case\|while\|until\|for\|forall\|repeat\|requirements\)\>'
    if line !~ '\<\%(end-.*\|until\)\>\s*\%(#.*\)\=$'
      let ind += s:indent_value('default')
    endif
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
