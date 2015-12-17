# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/symfony/symfony-1.4.17.ebuild,v 1.1 2012/03/09 22:13:43 mabi Exp $

EAPI=4

DESCRIPTION="Virtual for Symfony"
HOMEPAGE="http://www.symfony.com"
#SRC_URI="http://symfony.com/download?v=Symfony_Standard_${PV}.tgz"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apache apc dev less mongodb mysql nginx"

#REQUIRED_USE="^^ ( apache nginx )"
RDEPEND="dev-lang/php[intl,cli,ctype,mysql,pdo,session,simplexml,tokenizer,xml]
		apc? ( dev-php/pecl-apc )
		apache? ( www-servers/apache )
		nginx? ( www-servers/nginx )
		mongodb? ( dev-db/mongodb dev-php/pecl-mongo )
		mysql? ( dev-db/mysql )
		less? ( net-libs/nodejs )
		dev? ( dev-ruby/capistrano-symfony )" #dev-php/phpunit )"

pkg_postinst() {
	if has_version '=dev-lang/php-5*[-posix]';then
		einfo ""
		einfo "To enable color output on the symfony command line"
		einfo "add USE=\"posix\" to dev-lang/php"
		einfo ""
	fi
}
