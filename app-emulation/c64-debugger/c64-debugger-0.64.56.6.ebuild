# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 desktop

DESCRIPTION="Commodore 64 code and memory debugger"
HOMEPAGE="https://sourceforge.net/projects/c64-debugger/"
EGIT_REPO_URI="https://git.code.sf.net/p/c64-debugger/code"
EGIT_COMMIT="3f63aeb8c70becb18fc0314c8aefeb3c95436729"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="x11-libs/gtk+
app-arch/upx"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/${P}"

src_compile() {
	cd MTEngine
	emake || die
}

src_install() {
	dodoc MTEngine/Assets/README.txt

	dobin MTEngine/c64debugger
	newicon MTEngine/Assets/icons\ C64\ Debugger/Images.xcassets/AppIcon.appiconset/icon128.png c64debugger.png
	domenu ${FILESDIR}/c64debugger.desktop
}
