# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Ultimate Packer for eXecutables (free version using UCL compression and not NRV)"
HOMEPAGE="https://upx.github.io/"
SRC_URI="https://github.com/upx/upx/releases/download/v${PV}/${P}-src.tar.xz"

LICENSE="GPL-2+ UPX-exception" # Read the exception before applying any patches
SLOT="0"
KEYWORDS="*"

RDEPEND="!app-arch/upx-bin"
BDEPEND="app-arch/xz-utils[extra-filters]"

S="${WORKDIR}/${P}-src"

src_test() {
	# Don't run tests in parallel, #878977
	cmake_src_test -j1
}
