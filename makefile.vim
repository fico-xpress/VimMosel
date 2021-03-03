:new 
:r! git ls-files LICENSE*txt */*mosel* skeletons
:%s/^\n//g
:%MkVimball! vimmosel .
:q!
