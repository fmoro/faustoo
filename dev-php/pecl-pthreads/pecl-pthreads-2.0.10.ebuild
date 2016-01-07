# Distributed under the terms of the GNU General Public License v2

EAPI=4

PHP_EXT_NAME="pthreads"
PHP_EXT_PECL_PKG="pthreads"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.API"

USE_PHP="php5-3 php5-4 php5-5"

inherit php-ext-pecl-r2

DESCRIPTION="PHP front-end to POSIX threads library"

HOMEPAGE="https://pecl.php.net/package/pthreads"

LICENSE="PHP-3.01"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~arm ~ppc ~ppc64"
IUSE=""

DEPEND=">=dev-lang/php-5.3[threads]"
RDEPEND="${DEPEND}"

my_conf="--enable-pthreads"
