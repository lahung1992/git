#!/bin/sh

test_description='git apply handling submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh

create_diff () {
	git diff --ignore-submodules=dirty "..$1" >diff
}

test_submodule_switch_func "apply --index diff" "create_diff"

test_submodule_switch_func "apply --3way diff" "create_diff"

test_done
