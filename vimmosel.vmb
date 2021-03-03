" Vimball Archiver by Charles E. Campbell
UseVimball
finish
LICENSE.vimmosel.txt	[[[1
24
VimMosel -- Vim configuration files for the Mosel language
  version 1.0.0, July 15th, 2015

  Copyright (C) 2014-2015 Yves Colombani and Sebastien Lannez

  This software is provided 'as-is', without any express or implied
  warranty.  In no event will the authors be held liable for any damages
  arising from the use of this software.

  Permission is granted to anyone to use this software for any purpose,
  including commercial applications, and to alter it and redistribute it
  freely, subject to the following restrictions:

  1. The origin of this software must not be misrepresented; you must not
     claim that you wrote the original software. If you use this software
     in a product, an acknowledgment in the product documentation would be
     appreciated but is not required.
  2. Altered source versions must be plainly marked as such, and must not be
     misrepresented as being the original software.
  3. This notice may not be removed or altered from any source distribution.

  Yves Colombani              Sebastien Lannez
  yvescolombani@fico.com      sebastienlannez@gmail.com

autoload/mosel.vim	[[[1
35
" Vim autoload file for the Mosel language
" License:     LICENSE.vimmosel.txt
" Author:      Sebastien Lannez 
" Maintainer:  Sebastien Lannez
" Last Change: 12, September 2013

" this file uses line continuations
let s:cpo_sav = &cpo
set cpo-=C

func! Mosel#UpdateForwardDeclaration(line1, line2)
	" ***** Get list of public functions and procedures *****
	" Convert constraints (simple conditional + singleline)

	" Copy/paste whole buffer to cpliboard
	%y+
	new
	put

	" Only keep public procedure/function
	v/^\s*public procedure\|^\s*public function/d

	" Prefix with forward keyword
	%s/public/forward public/

	" Sort alphabetically
	%sort

	" Format the whole buffer
	%=

	" Yank everything
	%y+

endfunc
compiler/mosel.vim	[[[1
53
" Vim compiler file
"
" VimMosel -- Vim configuration files for the Mosel language
"  version 1.0.0, July 15th, 2015
"
"  Copyright (C) 2014-2015 Yves Colombani and Sebastien Lannez
"
"  This software is provided 'as-is', without any express or implied
"  warranty.  In no event will the authors be held liable for any damages
"  arising from the use of this software.
"
"  Permission is granted to anyone to use this software for any purpose,
"  including commercial applications, and to alter it and redistribute it
"  freely, subject to the following restrictions:
"
"  1. The origin of this software must not be misrepresented; you must not
"     claim that you wrote the original software. If you use this software
"     in a product, an acknowledgment in the product documentation would be
"     appreciated but is not required.
"  2. Altered source versions must be plainly marked as such, and must not be
"     misrepresented as being the original software.
"  3. This notice may not be removed or altered from any source distribution.
"
"  Yves Colombani              Sebastien Lannez
"  yvescolombani@fico.com      sebastienlannez@gmail.com
"
" Compiler:	Mosel
" Author:       Yves Colombani
" Maintainer:	Yves Colombani
" Last Change:	8, April 2002
"

if exists("current_compiler")
  finish
endif
let current_compiler = "mosel"

let s:mosel_cpo_save = &cpo
set cpo&vim

if exists("*Mosel_setcomp")
 call Mosel_setcomp("")
else
 set makeprg=$XPRESSDIR/mosel\ -s\ -c\ \'comp\ -g\ \"%\"\'
endif

setlocal errorformat=%.%#:\ %t\-%n\ %.%#\ (%l%\\,%c)\ %.%#\ `%f':\ %m,
                    \%.%#:\ %t\-%n\ %.%#\ %l\ %.%#\ `%f':\ %m,
                    \%.%#:\ %t\-%n\ %#:\ %m

let &cpo = s:mosel_cpo_save
unlet s:mosel_cpo_save

doc/mosel.txt	[[[1
408
*mosel.txt*  Plugin for developing Mosel scripts in Vim.

Author: Sebastien Lannez 
Last Change: September 12, 2013
License: LICENSE.vimmosel.txt

This plugin is licensed under the terms of the license defined
in the file LICENSE.vimmosel.txt and copied in its entirety
at the beginning of the file mosel.vim.

==============================================================================
Mosel                                       *mosel*

1. Introduction                             |mosel-intro|
2. Commands                                 |mosel-commands|
3. Functions                                |mosel-functions|
4. Tips & Tricks                            |mosel-tips|
5. Ascii tables                             |ascii-table|

For Vim version 7.0 or later.
This plugin only works if 'compatible' is not set.
{Vi does not have any of these features.}

==============================================================================
1. Introduction                             *mosel-intro*

Mosel is a language for mathematical programming.
My .vimrc addendum to properly work with VIM:
--- begin of code snippet -------------------
>
	"
	" My Mosel configuration
	"
	if !exists("autocommands_mosel")
		let autocommands_mosel = 1
		au BufNewFile *.mos	TSkeletonSetup template.mos
		au Bufenter *.mos 	compiler mosel
		au Bufenter *.vdl 	set filetype=xml
	endif
	let g:xml_syntax_folding = 1
	" Enable context aware completion
	let g:SuperTabDefaultCompletionType = "context"
	" No completion after spaces, comma, minus...
	let g:SuperTabNoCompleteAfter = [',', '\s', '-', '+', '>']
	" Show mosel functions
	let mosel_functions = 1
	" Fold using syntax
	set foldmethod=syntax

--- end of code snippet ----------------------

==============================================================================
2. Commands                                 *mosel-commands*

2.1 Mosel commands

<F5>  Compile the model in the current buffer
<F6>  Execute the model in the current buffer
<F7>  Profile the execution of the model in the current buffer
<F8>  List the symbols with Mosel examine

<F9>  Run model in the debugger

m<F8> List of public declarations (procedure and function) to QuickFix

]]    Jump to next procedure or function
]]    Jump to previous procedure or function
2.2 Versioning commands

<s-space> SnipMate forward expansion
<c-space> SnipMate backward expansion
<esc><space><space> List available snippets
    
2.2 Features

Word autocompletion can be done by pressing <tab> key. A
list of non word will then display.

Code snippets are automatically inserted after pressing <space> (also
soo <s-space>).
<c-r> gives a list of code snippets.

==============================================================================
3. Functions                               *mosel-functions*

3.1 MoselDeclaration
This routine will extract a list of the signature of all procedures and 
functions that are declared public. The list will be copied to the unnamed
register.

In the buffer containing the Mosel source code: >
	:MoselDeclaration

Then just paste with P or :"+gP
  

3.2 MoselFromAmpl
This routine will copy the current buffer to a new one, and apply a list of
rules to convert AMPL syntax to Mosel. The conversion is incomplete and will
not produce a valid AMPL file but can be used as a good starting point when
converting large models.

In the buffer containing the Mosel source code: >
	:MoselFromAmpl

Then edit the buffer.

==============================================================================
4. Tips and Tricks                         *mosel-tips*

4.1 Indent the whole buffer >
	gg=G

4.2 Indent the buffer from current cursor position to buffer top >
	=gg

4.3 Indent the buffer from current cursor position to buffer end >
	=G

4.4 Find and open file under cursor >
	<c-W> <c-F>

4.5 Convert string to text
	Original line:
		errorlog(EMYNUM,"This is a message("+a+")")
	Result line:
		errorlog(EMYNUM,text("This is a message(")+a+text(")"))
>
	:s/\("[^"]*"\)/text(\1)/g
	
==============================================================================

==============================================================================
5. Ascii table                             *ascii-table*

Ascii control characters

DEC	Symbol	HTML Number	Description
0	NUL	&#000;	Null char
1	SOH	&#001;	Start of Heading
2	STX	&#002;	Start of Text
3	ETX	&#003;	End of Text
4	EOT	&#004;	End of Transmission
5	ENQ	&#005;	Enquiry
6	ACK	&#006;	Acknowledgment
7	BEL	&#007;	Bell
8	BS	&#008;	Back Space
9	HT	&#009;	Horizontal Tab
10	LF	&#010;	Line Feed
11	VT	&#011;	Vertical Tab
12	FF	&#012;	Form Feed
13	CR	&#013;	Carriage Return
14	SO	&#014;	Shift Out / X-On
15	SI	&#015;	Shift In / X-Off
16	DLE	&#016;	Data Line Escape
17	DC1	&#017;	Device Control 1 (oft. XON)
18	DC2	&#018;	Device Control 2
19	DC3	&#019;	Device Control 3 (oft. XOFF)
20	DC4	&#020;	Device Control 4
21	NAK	&#021;	Negative Acknowledgement
22	SYN	&#022;	Synchronous Idle
23	ETB	&#023;	End of Transmit Block
24	CAN	&#024;	Cancel
25	EM	&#025;	End of Medium
26	SUB	&#026;	Substitute
27	ESC	&#027;	Escape
28	FS	&#028;	File Separator
29	GS	&#029;	Group Separator
30	RS	&#030;	Record Separator
31	US	&#031;	Unit Separator

Ascii printable characters

DEC	Symbol	HTML Number	Description
32	 	&#32;	Space
33	!	&#33;	Exclamation mark
34	"	&#34;	Double quotes (or speech marks)
35	#	&#35;	Number
36	$	&#36;	Dollar
37	%	&#37;	Procenttecken
38	&	&#38;	Ampersand
39	'	&#39;	Single quote
40	(	&#40;	Open parenthesis (or open bracket)
41	)	&#41;	Close parenthesis (or close bracket)
42	*	&#42;	Asterisk
43	+	&#43;	Plus
44	,	&#44;	Comma
45	-	&#45;	Hyphen
46	.	&#46;	Period, dot or full stop
47	/	&#47;	Slash or divide
48	0	&#48;	Zero
49	1	&#49;	One
50	2	&#50;	Two
51	3	&#51;	Three
52	4	&#52;	Four
53	5	&#53;	Five
54	6	&#54;	Six
55	7	&#55;	Seven
56	8	&#56;	Eight
57	9	&#57;	Nine
58	:	&#58;	Colon
59	;	&#59;	Semicolon
60	<	&#60;	Less than (or open angled bracket)
61	=	&#61;	Equals
62	>	&#62;	Greater than (or close angled bracket)
63	?	&#63;	Question mark
64	@	&#64;	At symbol
65	A	&#65;	Uppercase A
66	B	&#66;	Uppercase B
67	C	&#67;	Uppercase C
68	D	&#68;	Uppercase D
69	E	&#69;	Uppercase E
70	F	&#70;	Uppercase F
71	G	&#71;	Uppercase G
72	H	&#72;	Uppercase H
73	I	&#73;	Uppercase I
74	J	&#74;	Uppercase J
75	K	&#75;	Uppercase K
76	L	&#76;	Uppercase L
77	M	&#77;	Uppercase M
78	N	&#78;	Uppercase N
79	O	&#79;	Uppercase O
80	P	&#80;	Uppercase P
81	Q	&#81;	Uppercase Q
82	R	&#82;	Uppercase R
83	S	&#83;	Uppercase S
84	T	&#84;	Uppercase T
85	U	&#85;	Uppercase U
86	V	&#86;	Uppercase V
87	W	&#87;	Uppercase W
88	X	&#88;	Uppercase X
89	Y	&#89;	Uppercase Y
90	Z	&#90;	Uppercase Z
91	[	&#91;	Opening bracket
92	\	&#92;	Backslash
93	]	&#93;	Closing bracket
94	^	&#94;	Caret - circumflex
95	_	&#95;	Underscore
96	`	&#96;	Grave accent
97	a	&#97;	Lowercase a
98	b	&#98;	Lowercase b
99	c	&#99;	Lowercase c
100	d	&#100;	Lowercase d
101	e	&#101;	Lowercase e
102	f	&#102;	Lowercase f
103	g	&#103;	Lowercase g
104	h	&#104;	Lowercase h
105	i	&#105;	Lowercase i
106	j	&#106;	Lowercase j
107	k	&#107;	Lowercase k
108	l	&#108;	Lowercase l
109	m	&#109;	Lowercase m
110	n	&#110;	Lowercase n
111	o	&#111;	Lowercase o
112	p	&#112;	Lowercase p
113	q	&#113;	Lowercase q
114	r	&#114;	Lowercase r
115	s	&#115;	Lowercase s
116	t	&#116;	Lowercase t
117	u	&#117;	Lowercase u
118	v	&#118;	Lowercase v
119	w	&#119;	Lowercase w
120	x	&#120;	Lowercase x
121	y	&#121;	Lowercase y
122	z	&#122;	Lowercase z
123	{	&#123;	Opening brace
124	|	&#124;	Vertical bar
125	}	&#125;	Closing brace
126	~	&#126;	Equivalency sign - tilde
127		&#127;	Delete

The extended ASCII codes (character code 128-255)

DEC	Symbol	HTML Number	Description
128		&#128;	Euro sign
129	 	 	 
130		&#130;	Single low-9 quotation mark
131		&#131;	Latin small letter f with hook
132		&#132;	Double low-9 quotation mark
133		&#133;	Horizontal ellipsis
134		&#134;	Dagger
135		&#135;	Double dagger
136		&#136;	Modifier letter circumflex accent
137		&#137;	Per mille sign
138		&#138;	Latin capital letter S with caron
139		&#139;	Single left-pointing angle quotation
140		&#140;	Latin capital ligature OE
141	 	 	 
142		&#142;	Latin captial letter Z with caron
143	 	 	 
144	 	 	 
145		&#145;	Left single quotation mark
146		&#146;	Right single quotation mark
147		&#147;	Left double quotation mark
148		&#148;	Right double quotation mark
149		&#149;	Bullet
150		&#150;	En dash
151		&#151;	Em dash
152		&#152;	Small tilde
153		&#153;	Trade mark sign
154		&#154;	Latin small letter S with caron
155		&#155;	Single right-pointing angle quotation mark
156		&#156;	Latin small ligature oe
157	 	 	 
158		&#158;	Latin small letter z with caron
159		&#159;	Latin capital letter Y with diaeresis
160	 	&#160;	Non-breaking space
161	¡	&#161;	Inverted exclamation mark
162	¢	&#162;	Cent sign
163	£	&#163;	Pound sign
164	¤	&#164;	Currency sign
165	¥	&#165;	Yen sign
166	¦	&#166;	Pipe, Broken vertical bar
167	§	&#167;	Section sign
168	¨	&#168;	Spacing diaeresis - umlaut
169	©	&#169;	Copyright sign
170	ª	&#170;	Feminine ordinal indicator
171	«	&#171;	Left double angle quotes
172	¬	&#172;	Not sign
173		&#173;	Soft hyphen
174	®	&#174;	Registered trade mark sign
175	¯	&#175;	Spacing macron - overline
176	°	&#176;	Degree sign
177	±	&#177;	Plus-or-minus sign
178	²	&#178;	Superscript two - squared
179	³	&#179;	Superscript three - cubed
180	´	&#180;	Acute accent - spacing acute
181	µ	&#181;	Micro sign
182	¶	&#182;	Pilcrow sign - paragraph sign
183	·	&#183;	Middle dot - Georgian comma
184	¸	&#184;	Spacing cedilla
185	¹	&#185;	Superscript one
186	º	&#186;	Masculine ordinal indicator
187	»	&#187;	Right double angle quotes
188	¼	&#188;	Fraction one quarter
189	½	&#189;	Fraction one half
190	¾	&#190;	Fraction three quarters
191	¿	&#191;	Inverted question mark
192	À	&#192;	Latin capital letter A with grave
193	Á	&#193;	Latin capital letter A with acute
194	Â	&#194;	Latin capital letter A with circumflex
195	Ã	&#195;	Latin capital letter A with tilde
196	Ä	&#196;	Latin capital letter A with diaeresis
197	Å	&#197;	Latin capital letter A with ring above
198	Æ	&#198;	Latin capital letter AE
199	Ç	&#199;	Latin capital letter C with cedilla
200	È	&#200;	Latin capital letter E with grave
201	É	&#201;	Latin capital letter E with acute
202	Ê	&#202;	Latin capital letter E with circumflex
203	Ë	&#203;	Latin capital letter E with diaeresis
204	Ì	&#204;	Latin capital letter I with grave
205	Í	&#205;	Latin capital letter I with acute
206	Î	&#206;	Latin capital letter I with circumflex
207	Ï	&#207;	Latin capital letter I with diaeresis
208	Ð	&#208;	Latin capital letter ETH
209	Ñ	&#209;	Latin capital letter N with tilde
210	Ò	&#210;	Latin capital letter O with grave
211	Ó	&#211;	Latin capital letter O with acute
212	Ô	&#212;	Latin capital letter O with circumflex
213	Õ	&#213;	Latin capital letter O with tilde
214	Ö	&#214;	Latin capital letter O with diaeresis
215	×	&#215;	Multiplication sign
216	Ø	&#216;	Latin capital letter O with slash
217	Ù	&#217;	Latin capital letter U with grave
218	Ú	&#218;	Latin capital letter U with acute
219	Û	&#219;	Latin capital letter U with circumflex
220	Ü	&#220;	Latin capital letter U with diaeresis
221	Ý	&#221;	Latin capital letter Y with acute
222	Þ	&#222;	Latin capital letter THORN
223	ß	&#223;	Latin small letter sharp s - ess-zed
224	à	&#224;	Latin small letter a with grave
225	á	&#225;	Latin small letter a with acute
226	â	&#226;	Latin small letter a with circumflex
227	ã	&#227;	Latin small letter a with tilde
228	ä	&#228;	Latin small letter a with diaeresis
229	å	&#229;	Latin small letter a with ring above
230	æ	&#230;	Latin small letter ae
231	ç	&#231;	Latin small letter c with cedilla
232	è	&#232;	Latin small letter e with grave
233	é	&#233;	Latin small letter e with acute
234	ê	&#234;	Latin small letter e with circumflex
235	ë	&#235;	Latin small letter e with diaeresis
236	ì	&#236;	Latin small letter i with grave
237	í	&#237;	Latin small letter i with acute
238	î	&#238;	Latin small letter i with circumflex
239	ï	&#239;	Latin small letter i with diaeresis
240	ð	&#240;	Latin small letter eth
241	ñ	&#241;	Latin small letter n with tilde
242	ò	&#242;	Latin small letter o with grave
243	ó	&#243;	Latin small letter o with acute
244	ô	&#244;	Latin small letter o with circumflex
245	õ	&#245;	Latin small letter o with tilde
246	ö	&#246;	Latin small letter o with diaeresis
247	÷	&#247;	Division sign
248	ø	&#248;	Latin small letter o with slash
249	ù	&#249;	Latin small letter u with grave
250	ú	&#250;	Latin small letter u with acute
251	û	&#251;	Latin small letter u with circumflex
252	ü	&#252;	Latin small letter u with diaeresis
253	ý	&#253;	Latin small letter y with acute
254	þ	&#254;	Latin small letter thorn
255	ÿ	&#255;	Latin small letter y with diaeresis

==============================================================================


 vim:tw=78:ts=8:ft=help:norl:

ftplugin/mosel.vim	[[[1
394
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
let b:context=''

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
    if b:context == "solution"
      let &mp=g:mosel_cmd." make "
    elseif b:context == "decision-optimizer"
      let &mp=g:mosel_cmd." compile ".g:mosel_compopt." -o ". $MOSEL_OUT ."/".expand("%:p:t:r").".bim \"".expand("%")."\""
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
      if b:context == ""
        execute "!".g:mosel_cmd." execute " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif b:context == 'decision-optimizer'
        execute "!".g:mosel_cmd." execute " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif b:context == "3.4"
        execute "!".g:mosel_cmd." -s -c \"exe ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c exe ".g:mosel_compopt." \"".expand("%")."\""
      endif
    endif
  endfunc

  " Compile then profile a mos file
  fun! s:mosprof(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if b:context == "3.4"
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
      if b:context == ""
        execute "!".g:mosel_cmd." debug " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif b:context == "3.4"
        execute "!".g:mosel_cmd." -s -c \"debug ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"debug ".g:mosel_compopt." \"".expand("%")."\" ".b:context." \""
      endif
    endif
  endfunc
  " Execute all commands in the file
  fun! s:mostest(p)
    if &filetype != "mosel"
      echo "Not a Mosel file"
    else
      update
      if b:context == ""
        execute "!".g:mosel_cmd." execute " .g:mosel_compopt. " \"" .expand("%"). "\" " .g:mosel_runparams 
      elseif b:context == "3.4"
        execute "!".g:mosel_cmd." -s -c \"exe ".g:mosel_compopt." '".%."' ".g:mosel_runparams." \""
      elseif b:context == "decision-optimizer"
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"exe ".g:mosel_compopt." \"".expand("%")."\""
      else
        execute "!cd ".b:mosel_runpath."; mosel -s -c \"exe ".g:mosel_compopt." \"".expand("%")."\" ".b:context." \""
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
map <F10> :call <SID>moscompexe()<CR><CR>

" Advanced command used for Xpress development
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
indent/mosel.vim	[[[1
137
" Vim indent file
" License:          LICENSE.vimmosel.txt
" Language:         Mosel Script
" Maintainer:       sebastien Lannez
" Latest Revision:  6, January 2010
"

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

  let pnum = prevnonblank(lnum - 1) " previous line
  let nnum = nextnonblank(lnum + 1) " next line

  let pline = getline(pnum)
  let pind = indent(pnum)

  let ind = indent(lnum)
  let line = getline(lnum)

  let synid = synIDattr(synID(lnum,  -1, 0), "name")
  let synid1 = synIDattr(synID(lnum, 1, 0), "name")
  let synid2 = synIDattr(synID(nnum, 1, 0), "name")

  " Indent with syntax information
  if synid =~ 'moselHeader'
    " No indentation in header
    return ind
  elseif synid =~ 'moselComment'
    if synid1 =~ 'moselComment' 
      " No indentation for whole line comment
      return ind
    endif
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
      if s:is_continuation_line(pline)
        return ind
      else
        let ind += s:indent_value('default')
      endif
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
    " Indentation of the latest non continutation line
    let ind = indent(s:find_continued_lnum(pnum))
  endif

  let pine = line
  let line = getline(v:lnum)
  if line =~ '^\s*\%(until\|else\|elif\|end-.*\)\>' || line =~ '^\s*}'
    let ind -= s:indent_value('default')
  endif
    
  return ind
endfunction

function! s:is_continuation_line(line)
  return a:line =~ '\%(^\|\<and\>\|\<or\>\|+\|-\|,\|\*\|\/\|(\|{\|=\|>\|<\)\s*$'
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
32
" Vim global plugin file
" License:      LICENSE.vimmosel.txt
" Language:	Mosel
" Maintainer:	Sebastien Lannez
" Contributor:	Yves Colombani
" Last Change:	13, September 2013

if exists('g:loaded_mosel_plugin')
  finish
endif
let g:loaded_mosel_plugin = 'vim7.3_v6'

" Define the file type "mosel"
augroup filetype
 au! BufRead,BufNewFile *.mos set filetype=mosel
 au BufEnter *.mos compiler mosel
augroup END

" Enable automatic file type detection
filetype plugin on

" Define the :moselDeclaration command when:
" - 'compatible' is not set
" - this plugin was not already loaded
" - user commands are available.
if !&cp && !exists(":MoselDeclaration") && has("user_commands")
  command -range=% MoselDeclaration :call Mosel#UpdateForwardDeclaration(<line1>, <line2>)
endif

" Make sure any patches will probably use consistent indent
"   vim: ts=8 sw=2 sts=2 noet

skeletons/template.mos	[[[1
56
(!*******************************************************
  <+projectname+>
  ===============

  file <+filename+>
  -------------------------------------------------------
  <+one line description+>

  <+detailed description+>

  Changelog
  ---------
  0.0.1 Initial

  Examples
  --------
  <+command line command examples+>
    mosel <+model+> <+list of arguments+>

  
  (c) 2014 Fair Isaac Corporation
      author: S. Lannez, Feb. 2014

*******************************************************!)
model mymodel
  version 0.0.1
  options noimplicit

  uses "mmxprs"
  uses "mmsystem"

  parameters
    PARAM=0 	
  end-parameters


  (! Begin of forward declarations !)
  public procedure myproc
  (! End of forward declarations !)

  public declarations
    a: real	  
  end-declarations

  public procedure myproc
    ;  
  end-procedure

  !*** Application ***!

  ! do something

end-model

! Command style for Mosel models
! vim: et:ts=2:sw=2:sts=2:ft=mosel:foldlevel=1:
syntax/mosel.vim	[[[1
346
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
syn keyword moselStatement	if then else elif forall repeat until while do end- case of
syn keyword moselStatement	break next with
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

syn region moselIf matchgroup=moselStatement
      \ start=/\<if\>/ end=/\<end-if\>/
      \ contained transparent fold

syn region moselCase matchgroup=moselStatement
      \ start=/\<case\>/ end=/\<end-case\>/
      \ contained transparent fold

syn region moselRepeat matchgroup=moselStatement
      \ start=/\<repeat\>/ end=/\<until\>/ 
      \ contained transparent fold

syn region moselWith matchgroup=moselStatement
      \ start=/\<with\>/ end=/\<end-do\>/ 
      \ contained transparent fold

syn region moselDo matchgroup=moselStatement
      \ start=/\<do\>/ end=/\<end-do\>/ 
      \ contained transparent fold

" Enable manual folding
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
