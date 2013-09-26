:new 
:r! git ls-files */*mosel*
:%s/^\n//g
:%MkVimball! mosel .
:new 
:r! git ls-files */*snip* snippets/*
:%s/^\n//g
:%MkVimball! snipmate .
:new 
:r! git ls-files */*haskell*
:%s/^\n//g
:%MkVimball! haskell .
:new mosel.vba
:so %
:new snipmate.vba
:so %
:new haskell.vba
:so %
:new supertab.vmb
:so %

