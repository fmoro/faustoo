# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop

MY_PN="C64-65XE-Debugger"

DESCRIPTION="Commodore 64 and Atari XL/XE code and memory debugger"
HOMEPAGE="https://sourceforge.net/projects/c64-debugger/"
SRC_URI="
	x86? ( mirror://sourceforge/c64-debugger/${MY_PN}-v${PV}-linux-i386.tar.gz )
	amd64? ( mirror://sourceforge/c64-debugger/${MY_PN}-v${PV}-linux-x64.tar.gz )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	x11-libs/gtk+
"
BDEPEND=""

S="${WORKDIR}/${MY_PN}"

src_install() {
	dodoc README.txt

	dobin 65xedebugger
	newicon 65XEDebugger-icon.png 65xedebugger.png
	domenu ${FILESDIR}/65xedebugger.desktop

	dobin c64debugger
	newicon C64Debugger-icon.png c64debugger.png
	domenu ${FILESDIR}/c64debugger.desktop
}

pkg_postinst() {
	einfo "Current c64 debugger version try to load xcb-util library from"
	einfo "/usr/lib64/libxcb-util.so.0, but current symlink is"
	einfo "/usr/lib64/libxcb-util.so.1, so to make it work you just have to"
	einfo "create the symlink executing as root the command"
	einfo "ln -s libxcb-util.so.1.0.0 /usr/lib64/libxcb-util.so.0"
}
