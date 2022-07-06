# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="mongodb"
USE_PHP="php7-4 php8-0 php8-1"
DOCS="README.md"

inherit php-ext-pecl-r3

DESCRIPTION="MongoDB driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"
