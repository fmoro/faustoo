# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

#RESTRICT="test" # broken

DESCRIPTION="Flask support for MongoDB and with WTF model forms"
HOMEPAGE="https://pypi.python.org/pypi/mtools/"
SRC_URI="https://github.com/geeknam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

#python_test() {
#	nosetests || die "Testing failed with ${EPYTHON}"
#}

#python_install_all() {
#	distutils-r1_python_install_all
#}
