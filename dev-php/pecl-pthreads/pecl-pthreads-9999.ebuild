# Distributed under the terms of the GNU General Public License v2

EAPI=4

PHP_EXT_NAME="pthreads"
PHP_EXT_PECL_PKG="pthreads"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.API"

USE_PHP="php5-3 php5-4 php5-5"

#inherit php-ext-pecl-r2 git-2

inherit git-2 php-ext-source-r2

DESCRIPTION="PHP front-end to POSIX threads library"

EGIT_REPO_URI="git://github.com/krakjoe/pthreads.git"
#EGIT_BRANCH="master"

LICENSE="PHP-3.01"
SLOT="0"
#KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-lang/php-5.3[threads]"
RDEPEND="${DEPEND}"

my_conf="--enable-pthreads"

src_unpack() {
	git-2_src_unpack

	local slot orig_s="$S"
	for slot in $(php_get_slots); do
		cp -r "${orig_s}" "${WORKDIR}/${slot}"
	done
}

src_prepare() {
	git-2_src_prepare
	local slot orig_s="$S"
	for slot in $(php_get_slots); do
		php_init_slot_env ${slot}
		phpize && aclocal && libtoolize --force && autoheader && autoconf
	done
}

