" Vim syntax file
" Language: Mosel
" License: LICENSE.vimmosel.txt
" Maintainer: Sebastien Lannez
" Version: 1.0
" Last Change: February 2018
" Contributors: Yves Colombani, Sebastien Lannez
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syntax case ignore

syn sync lines=250
" List of operators and modifiers
syn keyword moselOperator	and div in mod not or sum prod min max
syn keyword moselOperator	inter union count
syn keyword moselOperator	is_binary is_continuous is_free is_integer
syn keyword moselOperator	is_partint is_semcont is_semint is_sos1 is_sos2

" List of statements
syn keyword moselStatement	uses options include imports
syn keyword moselStatement	as list set range array as counter dynamic
syn keyword moselStatement	else elif then with forall next until while 
syn keyword moselStatement	repeat break
syn keyword moselStatement	case
syn keyword moselStatement	initialisations evaluation from to
syn keyword moselStatement	initializations linctr
syn keyword moselStatement	of package
syn keyword moselStatement	forward declarations requirements parameters function procedure public  
syn keyword moselStatement	record return returned
syn keyword moselStatement	uses version
syn keyword moselStatement	indicator implies basis

" List of builtin types
syn keyword moselClass		mpproblem
syn keyword moselClass		boolean integer string real date datetime text
syn keyword moselClass		linctr nlctr robustctr mpvar
syn keyword moselClass		robustctr uncertain uncertainctr
syn keyword moselClass		cpctr cpvar logctr
syn match moselClass display	/\<\u\w*T\>/

" List of builtin constants (case insensitive)
syn keyword moselConstant	true false

" List of builtin constants (case sensitive)
syntax case match
syn keyword moselConstant	NAN INFINITY MAX_INT MAX_REAL
syn keyword moselConstant	CT_BIN CT_CONT CT_EQ CT_FREE CT_GEQ CT_INT 
syn keyword moselConstant	CT_LEQ CT_PINT CT_SEC CT_SINT CT_SOS1 CT_SOS2 
syn keyword moselConstant	CT_UNB EP_MAX EP_MIN EP_MPS EP_STRIP
syn keyword moselConstant	F_APPEND F_BINARY F_DELCLOSE F_ERROR F_INPUT
syn keyword moselConstant	F_IOERR F_LINBUF F_OUTPUT F_SILENT F_TEXT
syn keyword moselConstant	IOERR_IN IOERR_OUT M_E M_PI
 
syn keyword moselTodo contained	TODO BUG

" In case someone wants to see the predefined functions/procedures
if exists("mosel_functions")
 syn keyword moselFunction	_ asproc assert bitflip bitneg
 syn keyword moselFunction	bitset bitshift bittest bitval create
 syn keyword moselFunction	currentdate currenttime timestamp cuthead cuttail gettail
 syn keyword moselFunction	delcell exists exit exp getfirst gethead getlast getreverse getsize
 syn keyword moselFunction	finalize finalise findfirst findlast getparam isdynamic setparam
 syn keyword moselFunction	splithead splittail unpublish publish

" math 
 syn keyword moselFunction	floor round ceil sqrt abs arctan arcsin arccos sin cos

" file access
 syn keyword moselFunction	fflush fopen fclose fselect fskipline fwrite fwrite_ 
 syn keyword moselFunction	fwriteln fwriteln_ getfname iseof getfid getreadcnt
 syn keyword moselFunction	read readln
 syn keyword moselFunction	write write_ writeln writeln_
 syn keyword moselFunction	random 

" optimizer
 syn keyword moselFunction	getact getcoeff getcoeffs exportprob
 syn keyword moselFunction	getdual getslack getsol getobjval getrcost
 syn keyword moselFunction	gettype getvars isfinite setcoeff sethidden
 syn keyword moselFunction	settype
 syn keyword moselFunction	minimize minimise maximize maximise
 syn keyword moselFunction	ishidden isinf isnan isodd ln log makesos1 
 syn keyword moselFunction	makesos2 maxlist minlist newmuid publish 
 syn keyword moselFunction	setinitval

" io
 syn keyword moselFunction	reset reverse
 syn keyword moselFunction	setioerr setmatherr setname  
 syn keyword moselFunction	setrandseed

" Text manipulation
 syn keyword moselFunction	strfmt substr textfmt

 " mminsight
 syn keyword moselFunction	insightminimize insightminimise insightmaximize insightmaximise
 syn keyword moselFunction	insightgetmode insightpopulate

 " mmsystem
 syn keyword moselFunction	gettime
 syn keyword moselFunction	fdelete fopen getfsize
 syn keyword moselFunction	setdefstream

 " mmjobs
 syn keyword moselFunction	getid 
 syn keyword moselFunction	getfromid getclass send getvalue
 syn keyword moselFunction	getnextevent dropnextevent
 syn keyword moselFunction	disconnect 
 syn keyword moselFunction	compile load unload run wait waitfor
 syn keyword moselFunction	Model Mosel

 " Constants
 syn keyword moselConstant	F_OUTPUT F_INPUT F_ERROR EVENT_END

 " mmodbc
 syn keyword moselParam		sqlbufsize sqlcolsize sqlconnection sqldebug sqldm sqlextn 
 syn keyword moselParam		sqlndxcol sqlrowcnt sqlrowxfr sqlsuccess sqlverbose

 syn keyword moselFunction	SQLconnect SQLdisconnect
 syn keyword moselFunction	SQLexecute SQLgetiparam SQLgetrparam SQLgetsparam SQLparam 
 syn keyword moselFunction	SQLreadinteger SQLreadreal SQLreadstring SQLupdate 
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
"syn region  moselStringError matchgroup=moselStringError start=+'+ end=+'+ end=+$+
"syn region  moselStringError matchgroup=moselStringError start=+"+ end=+"+ end=+$+ contains=moselStringEscape

"right strings
syn match   moselStringEscape	contained '\\.'
syn region  moselString matchgroup=moselString start=+'+ end=+'+ oneline
syn region  moselString matchgroup=moselString start=+"+ end=+"+ oneline contains=moselStringEscape
syn region  moselString matchgroup=moselString start=+`+ end=+`+
"To see the start and end of strings:
"syn region  moselString matchgroup=moselStringError start=+'+ end=+'+ oneline


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

" Format of annotations
syn region moselAnnot matchgroup=moselAnCom start="(!@[^\ ]*"  end="!)" contains=moselTodo fold
syn region moselAnnot matchgroup=moselAnCom start="!@[^\ ]*"  end="$" contains=moselTodo fold

" List of blocks
syn region moselModel matchgroup=moselStatement 
      \ start=/^\s*\<model\>/ 
      \ end=/^\s*\<end-model\>/ 
      \ transparent fold 

syn region moselPackage matchgroup=moselStatement 
      \ start=/^\s*\<package\>/ 
      \ end=/^\s*\<end-package\>/ 
      \ transparent fold 

syn cluster mRoot add=moselModel,moselPackage

syn region moselParam matchgroup=moselStatement
      \ start=/^\s*\<parameters\>/
      \ end=/^\s*\<end-parameters\>/ 
      \ containedin=moselModel transparent fold

syn region moselDeclr matchgroup=moselStatement
      \ start=/^\s*\<declarations\>/ 
      \ end=/^\s*\<end-declarations\>/ 
      \ containedin=@mRoot transparent fold

syn region moselPDecl matchgroup=moselStatement
      \ start=/^\s*\<public\>\s*\<declarations\>/ 
      \ end=/^\s*\<end-declarations\>/ 
      \ containedin=@mRoot transparent fold

syn region moselIniti matchgroup=moselStatement
      \ start=/^\s*\<initiali[sz]ations\>/ 
      \ end=/^\s*\<end-initiali[sz]ations\>/ 
      \ containedin=@mRoot transparent fold

syn region moselRequire matchgroup=moselStatement
      \ start=/^\s*\<requirements\>/ end=/^\s*\<end-requirements\>/ 
      \ containedin=@mRoot contains=moselStatement,moselComment,moselFunction,moselClass transparent fold

syn region moselRecord matchgroup=moselStatement
      \ start=/\<record\>/ end=/\<end-record\>/ 
      \ containedin=moselParam transparent fold

syn cluster mDatadef add=moselParam,moselDeclr,modelPDecl,moselRequire,moselIniti

syn region moselProc matchgroup=moselStatement
      \ start=/^\s*\<procedure\>\s\|^\s*\<public\>\s*\<procedure\>\s/ 
      \ end=/^\s*\<end-procedure\>/ 
      \ containedin=@mRoot transparent fold

syn region moselFunc matchgroup=moselStatement
      \ start=/^\s*\<function\>\s\|^\s*\<public\>\s*\<function\>\s/ 
      \ end=/^\s*\<end-function\>/
      \ containedin=@mRoot transparent fold

syn cluster mMethod add=moselProc,moselFunc

syn region moselDo matchgroup=moselStatement
      \ start=/\<do\>/ end=/\<end-do\>/ 
      \ containedin=@mRoot transparent fold

syn region moselIf matchgroup=moselStatement
      \ start=/\<if\>/ end=/\<end-if\>/
      \ containedin=@mRoot transparent fold

syn region moselCase matchgroup=moselStatement
      \ start=/\<case\>/ end=/\<end-case\>/
      \ containedin=@mRoot transparent fold

syn region moselRepeat matchgroup=moselStatement
      \ start=/\<repeat\>/ end=/\<until\>/ 
      \ contained transparent fold

" Enable manual fodling
syn region moselFold
      \ start="(! @{" end="@} !)"                 
      \ transparent fold

" Format of block comments
syn region moselComment
      \ start=/(![^@]/ end=/!)/ contains=moselTodo 
      \ containedin=@mRoot fold

" Format of one line comment
syn region moselComment
      \ start=/![^@]/ end=/$/ contains=moselTodo
      \ containedin=@mRoot fold

syn region moselHeader
      \ start=/\%^(!/ end=/!)/ contains=moselTodo 
      \ fold

syn cluster mComment add=moselComment,moselHeader

"syn match moselIfOneLine ":=\s*if\s*(.*,.*,.*)"

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
  elseif synid2 =~ 'moselHeader'
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
  HiLink moselHeader		Comment

  if !exists("mosel_only_comments")
    HiLink moselAnnot		Annotation
    HiLink moselAnnotF		Annotation
    HiLink moselConstant	Constant
    HiLink moselNumber		Constant
    HiLink moselString		String
    HiLink moselStringEscape	Special
    HiLink moselStringError	Error
    HiLink moselIdentifier	Identifier
    HiLink moselException	Exception
    HiLink moselFunction	Function
    HiLink moselOperator	Operator
      
    HiLink moselStatement	Statement
    HiLink moselIf     		Statement
    HiLink moselIfOneLine	Statement
    HiLink moselCase		Statement
  
    HiLink moselSymbolOperator	Operator
    HiLink moselSymbolOpStat	Statement
    HiLink moselTodo		Todo
    HiLink moselError		Error
    HiLink moselShowTab		Error
    HiLink moselClass		Statement
  endif

  delcommand HiLink
endif

syn sync fromstart
set foldtext=MoselFoldText()
set foldmethod=syntax

let b:current_syntax = "mosel"

" vim: ts=8 sw=2
