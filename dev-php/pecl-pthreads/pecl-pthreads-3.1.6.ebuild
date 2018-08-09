# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="pthreads"
PHP_EXT_PECL_PKG="pthreads"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md"

USE_PHP="php7-0"

inherit php-ext-pecl-r3

DESCRIPTION="PHP front-end to POSIX threads library"

HOMEPAGE="https://pecl.php.net/package/pthreads"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
IUSE=""

DEPEND="dev-lang/php:7.0[threads]"
RDEPEND="${DEPEND}"

my_conf="--enable-pthreads"
