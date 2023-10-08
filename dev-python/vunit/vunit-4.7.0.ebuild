# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3+ )

inherit distutils-r1

RESTRICT="test" # broken

DESCRIPTION="Unit testing framework for VHDL/SystemVerilog"
HOMEPAGE="https://github.com/VUnit/vunit"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}-hdl/${PN}_hdl-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MPL-2.0 Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/colorama[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=("${FILESDIR}/${P}-setup.py-Dontinstallthetests.patch")

S="${WORKDIR}/${PN}_hdl-${PV}"

python_install_all() {
	distutils-r1_python_install_all
}
