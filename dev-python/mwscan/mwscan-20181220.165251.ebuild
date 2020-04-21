# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2+ )

# silly captcha test trying to access things over the network
#RESTRICT="test"

inherit distutils-r1

#MY_PN=""
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="A Yara wrapper to identify malware, with support for incremental scans, extension filtering and efficient hash whitelisting"
HOMEPAGE="https://github.com/gwillem/magento-malware-scanner"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/yara-python[${PYTHON_USEDEP}]
	test? ( dev-python/coverage[${PYTHON_USEDEP}] )"

RDEPEND="${RDEPEND}"

#S="${WORKDIR}/${MY_P}"

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
