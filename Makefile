all: dist

dist: mosel.vba snipmate.vba

mosel.vba:
	@rm -f mosel.vba
	@vim -c 'r! git ls-files compiler/mosel* doc/mosel* ftplugin/mosel* indent/mosel* plugin/mosel* syntax/mosel*' \
		-c '1,MkVimball! mosel .' \
		-c 'q!'

snipmate.vba:
	@rm -f snipmate.vba
	@vim -c 'r! git ls-files after/plugin/snip* autoload/snip* doc/snip* ftplugin/*snip* plugin/snip* snippets/* syntax/snip*' \
		-c '1,MkVimball! snipmate .' \
		-c 'q!'

clean:
	@rm -R build 2> /dev/null || true
	@rm -R mosel.vba snipmate.vba
	@rm -R *~

install: supertab.vmb mosel.vba snipmate.vba
	vim supertab.vmb -c 'so \%' -c 'q!'
	vim mosel.vba -c 'so \%' -c 'q!'
	vim snipmate.vba -c 'so \%' -c 'q!'


uninstall:
	vim -c 'RmVimball supertab.vmb' -c 'q'
	vim -c 'RmVimball mosel.vba' -c 'q'
	vim -c 'RmVimball snipmate.vba' -c 'q'

