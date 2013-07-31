SHELL=/bin/bash

all: dist

dist:
	@rm mosel.vmb 2> /dev/null || true
	@vim -c 'r! git ls-files compiler doc indent ftplugin plugin syntax' \
		-c '$$,$$d _' -c '%MkVimball mosel .' -c 'q!'

clean:
	@rm -R build 2> /dev/null || true
	@rm -R *~

install: supertab.vmb mosel.vmb
	vim $< -c 'so %' -c 'q'

uninstall:
	vim -c 'RmVimball supertab.vmb' -c 'q'
	vim -c 'RmVimball mosel.vmb' -c 'q'

