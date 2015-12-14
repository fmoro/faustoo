# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-tastypie/django-tastypie-0.9.15.ebuild,v 1.4 2013/06/06 09:32:46 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="A flexible and capable API layer for django utilising serialisers"
HOMEPAGE="https://github.com/wlanslovenija/django-tastypie-mongoengine"
SRC_URI="https://github.com/wlanslovenija/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="bip doc digest xml oauth test yaml"

LICENSE="BSD"
SLOT="0"

RDEPEND=">=dev-python/django-1.5[${PYTHON_USEDEP}]
	>=dev-python/django-tastypie-0.9.12[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.8.0"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C docs html
}

src_test() {
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}

python_test() {
	PYTHONPATH=.:tests ./tests/run_all_tests.sh || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
