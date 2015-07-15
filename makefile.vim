:new 
:r! git ls-files LICENSE*txt */*mosel* skeletons
:%s/^\n//g
:%MkVimball! vimmosel .
:new 
:new vimmosel.vba
:so %
:new supertab.vmb
:so %
