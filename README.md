Mosel vim plugin
================

A compilation of usefull plugins for developing with
Mosel.

Content
=======
. Supertab allows for auto-completion based on currently open buffers
. Snippets allows for code snippet insertion
. Mosel integrates vim with the mosel command line tools for
  compiling and executing Mosel model.

Source:
 . Supertab: http://www.vim.org/scripts/script.php?script_id=1643
 . snipMate: http://www.vim.org/scripts/script.php?script_id=2540

Install All
===========
Simply enter the following command:
> make

Equivalent to:
> make clean && make dist && make install

Install Mosel-Vim
=================
Simply enter the following command:
> vim -c 'so mosel.vba' -c 'q'

Install Supertab
================
Simply enter the following command:
> vim -c 'so supertab.vmb' -c 'q'

Remove plugins
==============
Simply enter the following command:
> make unistall

