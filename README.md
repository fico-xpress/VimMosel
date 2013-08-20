Mosel vim plugin
================

A compilation of usefull plugins for developing with
Mosel.

Content
=======
. Supertab allows for auto-completion based on currently open buffers
. Mosel integrates vim with the mosel command line tools for
  compiling and executing Mosel model.

Install All
===========
Simply enter the following command:
> make install

Install Mosel-Vim
=================
> vim -c 'so mosel.vba' -c 'q'

Install Supertab
================
> vim -c 'so supertab.vmb' -c 'q'

Remove plugins
==============
> vim -v 'RmVimball supertab.vmb' -c 'q'
> vim -v 'RmVimball mosel.vmb' -c 'q'
