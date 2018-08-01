# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PHP_EXT_NAME="mongodb"
USE_PHP="php5-6 php7-0 php7-1 php7-2"
DOCS="README.md"

inherit php-ext-pecl-r3

DESCRIPTION="MongoDB driver for PHP"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-lang/php"
RDEPEND="${DEPEND}"
