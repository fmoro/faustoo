# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

# silly captcha test trying to access things over the network
#RESTRICT="test"

inherit distutils-r1

#MY_PN=""
#MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python interface for a malware identification and classification tool"
HOMEPAGE="https://github.com/VirusTotal/yara-python"
#SRC_URI="https://github.com/virustotal/yara-python/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPLv3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	app-forensics/yara
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
