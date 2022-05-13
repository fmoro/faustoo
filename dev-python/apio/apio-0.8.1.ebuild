# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3+ pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Open source ecosystem for open FPGA boards"
HOMEPAGE="https://github.com/FPGAwars/apio"
# SRC_URI="https://github.com/FPGAwars/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc"

DEPEND="
	dev-python/pyproject2setuppy
	dev-python/click
	dev-python/semantic_version
	dev-python/requests
	dev-python/colorama
	dev-python/pyserial
	>=dev-python/wheel-0.37.0
	dev-util/scons
	"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}"

src_configure() {
	cp "${FILESDIR}/setup.py" "${S}"
}
