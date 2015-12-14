# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

RESTRICT="test" # connects to local DB and other nonsense

DESCRIPTION="A Python Object-Document-Mapper for working with MongoDB"
HOMEPAGE="https://github.com/MongoEngine/mongoengine/"
SRC_URI="https://github.com/MongoEngine/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=">=dev-python/pillow-2.0.0
>=dev-python/python-dateutil-2.4.0
dev-python/blinker"

DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/pymongo[${PYTHON_USEDEP}]
	"

python_test() {
	nosetests || die "Testing failed with ${EPYTHON}"
}
