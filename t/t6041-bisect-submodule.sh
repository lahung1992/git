#!/bin/sh

test_description='bisect can handle submodules'

. ./test-lib.sh
. "$TEST_DIRECTORY"/lib-submodule-update.sh

git_bisect_before () {
	git status -su >expect &&
	ls -1pR * >>expect &&
	tar cf "$TRASH_DIRECTORY/tmp.tar" * &&
	GOOD=$(git rev-parse --verify HEAD)
}

git_bisect_after () {
	echo "foo" >bar &&
	git add bar &&
	git commit -m "bisect bad" &&
	BAD=$(git rev-parse --verify HEAD) &&
	git reset --hard HEAD^^ &&
	git submodule update &&
	git bisect start &&
	git bisect good $GOOD &&
	rm -rf * &&
	tar xf "$TRASH_DIRECTORY/tmp.tar" &&
	git status -su >actual &&
	ls -1pR * >>actual &&
	test_cmp expect actual &&
	git bisect bad $BAD
}

test_submodule_switch_func "checkout \$arg" "git_bisect_before" "git_bisect_after"

test_done
