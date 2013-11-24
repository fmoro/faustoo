# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils python

DESCRIPTION="Abraca is a GTK2 client for the XMMS2 music player."
HOMEPAGE="http://nooms.de/projects/abraca/#requirements"
SRC_URI="http://nooms.de/media/abraca/abraca-${PV}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc source"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=dev-lang/python-2.4.3
	>=gnome-base/libglade-2.6.0
	|| (
		>=media-sound/xmms2-0.2.8_rc2
		>=media-sound/xmms2-git-20070325 )
	>=x11-libs/gtk+-2.10.9"
DEPEND="source? ( app-arch/zip )
	${RDEPEND}"

src_unpack () {
	unpack ${A}
}

src_compile() {
	${S}/waf --prefix=/usr configure || die "Configure failed"
	${S}/waf || die "Build failed"
}

src_install() {
	${S}/waf --destdir=${D} install || die "install failed"
	dodoc AUTHORS COPYING INSTALL README TODO

	make_desktop_entry abraca "Abraca" " " "gtk+;AudioVideo" "/usr/share/abraca" "Multimedia"
}
