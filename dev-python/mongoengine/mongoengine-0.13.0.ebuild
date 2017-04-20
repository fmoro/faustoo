# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{3,4,5,6}} )

inherit distutils-r1

RESTRICT="test" # connects to local DB and other nonsense

DESCRIPTION="A Python Object-Document-Mapper for working with MongoDB"
HOMEPAGE="https://github.com/MongoEngine/mongoengine/"
SRC_URI="https://github.com/MongoEngine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-python/pillow
>=dev-python/python-dateutil-2.4.0
dev-python/blinker"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	sed -i -e 's/tests/tests*/g' setup.py || die "Failed to fix test removal thingy"
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
