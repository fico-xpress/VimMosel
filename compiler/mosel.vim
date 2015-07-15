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

