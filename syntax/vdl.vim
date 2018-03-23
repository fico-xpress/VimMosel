" Vim syntax file
" Language:	VDL
" Maintainer:	Susanne Heipcke <susanneheipcke@fico.com>
" Version: 	1.0
" Last Change:	Nov 2017
" Filenames:	*.vdl
" CREDITS:	Derived from J.Zellner's and P.Siegmann's xml.vim 

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


let s:vdl_cpo_save = &cpo
set cpo&vim

syn case match

" mark illegal characters
syn match xmlError "[<&]"

" strings (inside tags) aka VALUES
"
" EXAMPLE:
"
" <tag foo.attribute = "value">
"                      ^^^^^^^
syn region  xmlString contained start=+"+ end=+"+ contains=xmlEntity,@Spell display
syn region  xmlString contained start=+'+ end=+'+ contains=xmlEntity,@Spell display


" punctuation (within attributes) e.g. <tag xml:foo.attribute ...>
"                                              ^   ^
" syn match   xmlAttribPunct +[-:._]+ contained display
syn match   xmlAttribPunct +[:.]+ contained display

" no highlighting for xmlEqual (xmlEqual has no highlighting group)
syn match   xmlEqual +=+ display


" attribute, everything before the '='
"
" PROVIDES: @xmlAttribHook
"
" EXAMPLE:
"
" <tag foo.attribute = "value">
"      ^^^^^^^^^^^^^
"
syn match   xmlAttrib
    \ +[-'"<]\@1<!\<[a-zA-Z:_][-.0-9a-zA-Z:_]*\>\%(['">]\@!\|$\)+
    \ contained
    \ contains=xmlAttribPunct,@xmlAttribHook
    \ display

"
" PROVIDES: @vdlAttribHook
"
syn match   vdlAttrib display "vdl[a-zA-Z_\-]*"


" namespace spec
"
" PROVIDES: @xmlNamespaceHook
"
" EXAMPLE:
"
" <xsl:for-each select = "lola">
"  ^^^
"
if exists("g:xml_namespace_transparent")
syn match   xmlNamespace
    \ +\(<\|</\)\@2<=[^ /!?<>"':]\+[:]\@=+
    \ contained
    \ contains=@xmlNamespaceHook
    \ transparent
    \ display
else
syn match   xmlNamespace
    \ +\(<\|</\)\@2<=[^ /!?<>"':]\+[:]\@=+
    \ contained
    \ contains=@xmlNamespaceHook
    \ display
endif


" tag name
"
" PROVIDES: @ xmlTagHook
"
" EXAMPLE:
"
" <tag foo.attribute = "value">
"  ^^^
"
syn match   xmlTagName
    \ +<\@1<=[^ /!?<>"']\++
    \ contained
    \ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook
    \ display

    " no syntax folding:
    " - contained attribute removed
    " - xmlRegion not defined
    "
    syn region   xmlTag
	\ matchgroup=xmlTag start=+<[^ /!?<>"']\@=+
	\ matchgroup=xmlTag end=+>+
	\ contains=xmlError,xmlTagName,xmlAttrib,vdlAttrib,xmlEqual,xmlString,@xmlStartTagHook

    syn match   xmlEndTag
	\ +</[^ /!?<>"']\+>+
	\ contains=xmlNamespace,xmlAttribPunct,@xmlTagHook

" VDL tag name
"
" PROVIDES: @vdlTagHook
"
syn match   vdlTagName	display	"vdl\<[\-]*[a-zA-Z_\-]*\>"

syn region   vdlTag
	\ matchgroup=vdlTag start=+<vdl+
	\ matchgroup=vdlTag end=+>+
	\ contains=vdlTagName,xmlAttrib,xmlEqual,xmlString

syn match   vdlEndTag	display	"</vdl[\-]*[a-zA-Z_\-]*>"
"    syn region   vdlEndTag display contained start=+</vdl+ end=+>+
"	\ contains=@vdlTagHook


" &entities;
syn match   xmlEntity                 "&[^; \t]*;" contains=xmlEntityPunct
syn match   xmlEntityPunct  contained "[&.;]"

    " no syntax folding:
    " - fold attribute removed
    "
    syn region  xmlComment
	\ start=+<!+
	\ end=+>+
	\ contains=xmlCommentStart,xmlCommentError
	\ extend


syn match xmlCommentStart   contained "<!" nextgroup=xmlCommentPart
syn keyword xmlTodo         contained TODO FIXME XXX
syn match   xmlCommentError contained "[^><!]"
syn region  xmlCommentPart
    \ start=+--+
    \ end=+--+
    \ contained
    \ contains=xmlTodo,@xmlCommentHook,@Spell


" CData sections
"
" PROVIDES: @xmlCdataHook
"
syn region    xmlCdata
    \ start=+<!\[CDATA\[+
    \ end=+]]>+
    \ contains=xmlCdataStart,xmlCdataEnd,@xmlCdataHook,@Spell
    \ keepend
    \ extend

" using the following line instead leads to corrupt folding at CDATA regions
" syn match    xmlCdata      +<!\[CDATA\[\_.\{-}]]>+  contains=xmlCdataStart,xmlCdataEnd,@xmlCdataHook
syn match    xmlCdataStart +<!\[CDATA\[+  contained contains=xmlCdataCdata
syn keyword  xmlCdataCdata CDATA          contained
syn match    xmlCdataEnd   +]]>+          contained


" Processing instructions
syn region  xmlProcessing matchgroup=xmlProcessingDelim start="<?" end="?>" contains=xmlAttrib,xmlEqual,xmlString

syn sync minlines=100


" The default highlighting.
hi def link xmlTodo		Todo
hi def link xmlTag		Function
hi def link xmlTagName		Function
hi def link xmlEndTag		Function
if !exists("g:xml_namespace_transparent")
    hi def link xmlNamespace	Tag
endif
hi def link xmlEntity		Statement
hi def link xmlEntityPunct	Type

hi def link xmlAttribPunct	Comment
hi def link xmlAttrib		cType

hi def link xmlString		String
hi def link xmlComment		Comment
hi def link xmlCommentStart	xmlComment
hi def link xmlCommentPart	Comment
hi def link xmlCommentError	Error
hi def link xmlError		Error

hi def link xmlProcessingDelim	Comment
hi def link xmlProcessing	Type

hi def link xmlCdata		String
hi def link xmlCdataCdata	Statement
hi def link xmlCdataStart	Type
hi def link xmlCdataEnd		Type

hi def link xmlDocTypeDecl	Function
hi def link xmlDocTypeKeyword	Statement
hi def link xmlInlineDTD	Function

hi def link vdlStatement	Statement
hi def link vdlTag	Statement
hi def link vdlEndTag	Statement
hi def link vdlAttrib		Statement

let b:current_syntax = "vdl"

let &cpo = s:vdl_cpo_save
unlet s:vdl_cpo_save

" vim: ts=8
