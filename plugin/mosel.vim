" Vim global plugin file
" Language:	Mosel
" Maintainer:	Sebastien Lannez <sebastienlannez@fico.com>
" Contributor:	Yves Colombani
" Last Change:	13, September 2013

if exists('g:loaded_mosel_plugin')
  finish
endif
let g:loaded_mosel_plugin = 'vim7.3_v6'

" Define the file type "mosel"
augroup filetype
 au! BufRead,BufNewFile *.mos set filetype=mosel
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

