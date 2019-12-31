#!/bin/sh
set -e

tmpdir=$(mktemp -d)

cleanup() {
    code=$?
    rm -rf $tmpdir
    exit $code
}
trap cleanup EXIT

set -x

export GHQ_ROOT=$tmpdir

: testing 'ghq get'
ghq get motemen/ghq
ghq get www.mercurial-scm.org/repo/hello
ghq get https://launchpad.net/terminator
ghq get --vcs fossil https://www.sqlite.org/src
ghq get --shallow --vcs=git-svn https://svn.apache.org/repos/asf/httpd/httpd
ghq get https://svn.apache.org/repos/asf/subversion
ghq get --shallow hub.darcs.net/byorgey/split

test -d $tmpdir/github.com/motemen/ghq/.git
test -d $tmpdir/www.mercurial-scm.org/repo/hello/.hg
test -d $tmpdir/launchpad.net/terminator/.bzr
test -f $tmpdir/www.sqlite.org/src/.fslckout
test -d $tmpdir/svn.apache.org/repos/asf/httpd/httpd/.git/svn
test -d $tmpdir/svn.apache.org/repos/asf/subversion/.svn
test -d $tmpdir/hub.darcs.net/byorgey/split/_darcs

: testing 'ghq list'
cat <<EOF | sort > $tmpdir/expect
github.com/motemen/ghq
www.mercurial-scm.org/repo/hello
launchpad.net/terminator
www.sqlite.org/src
svn.apache.org/repos/asf/httpd/httpd
svn.apache.org/repos/asf/subversion
hub.darcs.net/byorgey/split
EOF
ghq list | sort > $tmpdir/got
diff -u $tmpdir/expect $tmpdir/got

: testing 'input | ghq get -u'
ghq list | ghq get -u

: testing 'ghq create'
test "$(ghq create Songmu/hoge)" = "$tmpdir/github.com/Songmu/hoge"
test -d $tmpdir/github.com/Songmu/hoge/.git
