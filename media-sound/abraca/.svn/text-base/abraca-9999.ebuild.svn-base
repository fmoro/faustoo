# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit exteutils multilib git

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://abraca.xmms.se"

EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="doc debug"
KEYWORDS=""
RDEPEND=">=media-sound/xmms2-0.4
	>=x11-libs/gtk+-2.10.9
	>=dev-lang/vala-0.3.5"
DEPEND="${RDEPEND}
	dev-util/scons"

src_compile() {
	escons \
		$(scons_use_enable debug) \
		PREFIX=/usr \
		LIDBDIR="/usr/$(get_libdir)" \
		|| die "scons failed"
}

src_install() {
	escons DESTDIR="${D}" install || die
	dodoc AUTHORS README 
}
