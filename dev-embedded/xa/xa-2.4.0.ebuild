# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="xa is Andre Fachat's open-source 6502 cross assembler"
HOMEPAGE="https://www.floodgap.com/retrotech/xa/"
SRC_URI="https://www.floodgap.com/retrotech/xa/dists/${P}.tar.gz"

LICENSE="GPL-v2"
SLOT="0"
KEYWORDS="*"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

PATCHES=(
	"${FILESDIR}"/${PN}-2.4.0-make.patch
)

src_configure() {
	tc-export CC
}

src_test() {
	emake -j1 test
}

src_install() {
	emake DESTDIR="${D}/usr" install
	einstalldocs
}
