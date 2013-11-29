Mosel vim plugin
================

A compilation of usefull plugins for developing with
Mosel.

Content
=======
* Supertab allows for auto-completion based on currently open buffers
* Snippets allows for code snippet insertion
* Vim tools to develop Mosel application

Source:
* Supertab: http://www.vim.org/scripts/script.php?script_id=1643
* snipMate: http://www.vim.org/scripts/script.php?script_id=2540

Install All
===========
Open Vim and simply source the file makefile.vim:
> so makefile.vim

Install Mosel-Vim
=================
Simply enter the following command:
> vim -c 'so mosel.vba' -c 'q'

Install SnipMate
================
Simply enter the following command:
> vim -c 'so snipmate.vba' -c 'q'

Install Supertab
================
Simply enter the following command:
> vim -c 'so supertab.vmb' -c 'q'

Remove plugins
==============
> vim -v 'RmVimball supertab.vmb' -c 'q'
> vim -v 'RmVimball snipmate.vba' -c 'q'
> vim -v 'RmVimball mosel.vba' -c 'q'

Vim usefull command
===================
F5: Compile model in current buffer
F6: Execute model in current buffer
F7: Profile execution of model in current buffer
F8: List symbols of the current buffer
]] -> next procedure/function
[[ -> previous procedure/function
gf -> open file (works with 'uses')

