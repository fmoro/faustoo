# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

# silly captcha test trying to access things over the network
#RESTRICT="test"

inherit distutils-r1

MY_PN="Flask-DebugToolbar"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Toolbar overlay to Flask applications containing useful information for debugging"
HOMEPAGE="http://flask-debugtoolbar.readthedocs.org"
SRC_URI="mirror://pypi/${MY_P:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/flask-0.8[${PYTHON_USEDEP}]
	dev-python/blinker[${PYTHON_USEDEP}]
	dev-python/itsdangerous[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]"

RDEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

python_compile_all() {
	use doc && emake -C docs html
}

#python_test() {
#	nosetests || die "Tests failed under ${EPYTHON}"
#}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
