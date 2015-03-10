:new 
:r! git ls-files */*mosel* skeletons
:%s/^\n//g
:%MkVimball! mosel .
:new 
:new mosel.vba
:so %
:new supertab.vmb
:so %
