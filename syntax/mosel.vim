" Vim syntax file
" Language:	Mosel
" Current  Maintainer:  Yves Colombani <Yves.Colombani@dashoptimization.com>
" Version: 1.0
" Last Change:	December 2006
" Contributors: From mosel.vim
"
" 2013-06-25 - Added fold capability
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn sync lines=250
" List of keywords and operators
syn keyword moselOperator	and div in mod not or sum prod min max
syn keyword moselOperator	inter union
syn keyword moselStatement	is_binary is_continuous is_free is_integer
syn keyword moselStatement	is_partint is_semcont is_semint is_sos1 is_sos2
syn keyword moselStatement	uses options include
syn keyword moselStatement	forall procedure function forward 
syn keyword moselStatement	to from public
syn keyword moselStatement	as case
syn keyword moselStatement	array boolean integer real set string
syn keyword moselStatement	linctr mpvar of dynamic range
syn keyword moselStatement	list record imports package requirements version

" Keywords from libraries
syn keyword moselStatement	date time

" Blocks
syn keyword moselStatement	repeat while until break next 
syn keyword moselStatement	else elif then
syn match moselStatement	"end-"

syn keyword moselConstant	true false

syn keyword moselOperator	AND DIV IN MOD NOT OR SUM PROD MIN MAX
syn keyword moselOperator	INTER UNION
syn keyword moselOperator	IS_BINARY IS_CONTINUOUS IS_FREE IS_INTEGER
syn keyword moselOperator	IS_PARTINT IS_SEMCONT IS_SEMINT IS_SOS1 IS_SOS2
syn keyword moselStatement	USES OPTIONS INCLUDE
syn keyword moselStatement	REPEAT WHILE UNTIL BREAK NEXT
syn keyword moselStatement	FORALL PROCEDURE FUNCTION FORWARD DECLARATIONS
syn keyword moselStatement	MODEL DO INITIALIZATIONS TO FROM
syn keyword moselStatement	INITIALISATIONS PUBLIC
syn keyword moselStatement	PARAMETERS AS CASE
syn keyword moselStatement	IF ELSE ELIF THEN
syn keyword moselStatement	ARRAY BOOLEAN INTEGER REAL SET STRING
syn keyword moselStatement	LINCTR MPVAR OF DYNAMIC RANGE
syn keyword moselStatement	LIST RECORD IMPORTS PACKAGE REQUIREMENTS VERSION
syn match moselStatement	"END-"
syn keyword moselConstant	TRUE FALSE

syn keyword moselTodo contained	TODO YCO BUG FIXME XXX

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
 syn keyword moselFunction	random round
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
  syn region  moselString matchgroup=moselString start=+'+ end=+'+ oneline
  syn region  moselString matchgroup=moselString start=+"+ end=+"+ oneline contains=moselStringEscape
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

" Format of comments
syn region moselComment	
	\ start="(!"  
	\ end="!)" 
	\ contains=moselTodo 
	\ fold

syn region moselComment	
	\ start="!"  
	\ end="$" 
	\ contains=moselTodo 
	\ fold

syn region moselComment	matchgroup=moselStatement 
	\ start="end-model" 
	\ end="\%$" 
	\ contains=moselTodo

syn region moselModel matchgroup=moselStatement
	\ start="model"
	\ end="end-model"
	\ fold contains=ALL

syn region moselPackage matchgroup=moselStatement
	\ start="package"
	\ end="end-package"
	\ fold contains=ALL

syn region moselIf matchgroup=moselStatement
	\ start="if"
	\ end="end-if"
	\ fold contains=ALL

syn region moselParameters matchgroup=moselStatement
	\ start="parameters"
	\ end="end-parameters"
	\ fold contains=ALL

syn region moselDeclarations matchgroup=moselStatement
	\ start="declarations"
	\ end="end-declarations"
	\ fold contains=ALL

syn region moselInitialisations matchgroup=moselStatement
	\ start="initialisations"
	\ end="end-initialisations"
	\ fold contains=ALL

syn region moselDo matchgroup=moselStatement
	\ start="do"
	\ end="end-do"
	\ fold contains=ALL

" Define the text to show
function! MoselFoldText()
  let nl = v:foldend - v:foldstart + 1
  let comment = substitute(getline(v:foldstart),"^.*: *","",1)
  let txt = '+ (' . nl . ' lines) ' . comment
  return txt
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
  HiLink moselSymbolOperator	Operator
  HiLink moselSymbolOpStat	Statement
  HiLink moselTodo		Todo
  HiLink moselError		Error
  HiLink moselShowTab		Error
endif

  delcommand HiLink
endif

let b:current_syntax = "mosel"

syn sync fromstart
set foldtext=MoselFoldText()
set foldmethod=syntax

" vim: ts=8 sw=2
