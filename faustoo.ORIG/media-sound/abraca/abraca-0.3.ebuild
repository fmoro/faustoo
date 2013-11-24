# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://abraca.xmms.se"
SRC_URI="http://abraca.xmms.se/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~x86 ~amd64"
RDEPEND="|| (
		>=media-sound/xmms2-0.2.8_rc2
		>=media-sound/xmms2-git-20070325 )
	>=x11-libs/gtk+-2.10.9
	dev-lang/vala"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}"

src_compile() {
	sed -i -e "s:/usr/local:${D}/usr:g" configure || die
	./configure || die "Configure failed"
	emake || die
}

src_install() {
	make DESTDIR="${D}" install || die
	dodoc README
}
