XDG_CONFIG_HOME=tmp/xdg/config/
XDG_STATE_HOME=tmp/xdg/local/state/
XDG_DATA_HOME=tmp/xdg/local/share/

TESTS_INIT=tests/minimal_init.lua
TESTS_DIR=tests/

.PHONY: test

test:
	@nvim-test \
		--headless \
		--noplugin \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"
