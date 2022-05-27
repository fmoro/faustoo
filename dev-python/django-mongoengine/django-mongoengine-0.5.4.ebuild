# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2+ )

inherit distutils-r1

DESCRIPTION="MongoEngine support for Django framework"
HOMEPAGE="https://github.com/MongoEngine/django-mongoengine"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="doc test"

LICENSE="BSD"
SLOT="0"

RDEPEND="dev-python/django[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.14.0[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/nose[${PYTHON_USEDEP}]
	dev-python/coverage[${PYTHON_USEDEP}]"

PATCHES=( "${FILESDIR}"/tests-installation.patch )

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}

