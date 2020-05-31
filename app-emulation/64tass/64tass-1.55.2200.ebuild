# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="64tass is cross assembler targeting the 65xx series of micro processors"
HOMEPAGE="http://tass64.sourceforge.net/"
SRC_URI="mirror://sourceforge/tass64/source/${P}-src.zip -> ${P}.zip"

LICENSE="GLP-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}-src"

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install || die "emake install failed"
}
