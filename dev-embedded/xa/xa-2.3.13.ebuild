# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="xa is Andre Fachat's open-source 6502 cross assembler"
HOMEPAGE="https://www.floodgap.com/retrotech/xa/"
SRC_URI="https://www.floodgap.com/retrotech/xa/dists/${P}.tar.gz"

LICENSE="GPL-v2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_install() {
	echo "${D}"
	emake DESTDIR="${D}/usr" install
	dodoc README.1st ChangeLog
}
