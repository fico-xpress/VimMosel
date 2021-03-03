Mosel vim plugin
================

A compilation of usefull plugins for developing with
Mosel. The 'mosel.vba' vimball enables syntax highlighting and folding.
We also recommend two very usefull packages: SnipMate and Supertab which
can be used to add code snippet pasting and autocompletion.

Content
=======
* Supertab allows for auto-completion based on currently opened buffers
* Snippets allows for code snippet insertion
* Vim tools to develop Mosel application

Source:
* Supertab: http://www.vim.org/scripts/script.php?script_id=1643
* snipMate: http://www.vim.org/scripts/script.php?script_id=2540

Installing Mosel-Vim
====================
The plugin can be installed using the provided vimball archive or by cloning the current repository.
We suggeest you use the repository cloning option if your vim version is at least 8. 
This method will allow you to quickly pick any update from the repository.

## Using git (vim 8)
Vim 8 has native package management support.
You have to create a specific directory structure and vim will automatically load the corresponding packages.

```
$ mkdir -p ~/.vim/pack/fico
$ git clone --depth 1 https://github.com/fico-xpress/mosel-vim-plugin.git ~/.vim/pack/fico/start/vimmosel
```

## Using vimball
You can install the VimMosel plugins by downloading the vimmosel.vmb archive and then issuing the following commands:

> vim -c 'so mosel.vmb' -c 'q'

The vimball archive being a text based archive you can also simply load the file in the VIM buffer and source it:
> :so %

Quickstart
==========
The following commands can be used once the VimMosel plugin is loaded:

* F5: Compile model in current buffer
* F6: Execute model in current buffer
* F7: Profile execution of model in current buffer
* F8: List symbols of the module under the cursor

* ]] -> next procedure/function
* [[ -> previous procedure/function
* gf -> open file (works with 'uses')


Building the installer
======================
If you want to build the VimMosel vimball after you have done some modifications then simply source the VIM script makefile.vim. It will package up all files into vimmosel.vba and supertab.vmb. You will then have to manually save the vimmosel.vba and supertab.vmb files:
> so makefile.vim

Removing the plugin
===================

## git clone installation
Simply delete the `~/.vim/pack/fico/start/vimmosel` directory.

## vim ball installation
> vim -v 'RmVimball mosel.vmb' -c 'q'


