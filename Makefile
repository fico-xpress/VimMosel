all: dist

dist:
	@rm mosel.vmb 2> /dev/null || true
	@vim -c 'r! git ls-files compiler doc indent ftplugin plugin syntax' \
		-c '1,MkVimball! mosel .' \
		-c 'q!'

clean:
	@rm -R build 2> /dev/null || true
	@rm -R mosel.vba
	@rm -R *~

install: supertab.vmb mosel.vba
	vim $< -c 'so %' -c 'q'

uninstall:
	vim -c 'RmVimball supertab.vmb' -c 'q'
	vim -c 'RmVimball mosel.vba' -c 'q'

