# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# Header: $

inherit eutils

DESCRIPTION="A GTK-based client for the XMMS2 music player which makes managing your music a breeze"
HOMEPAGE="http://abraca.github.io/Abraca/"
SRC_URI="https://github.com/Abraca/Abraca/archive/${PV}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
IUSE="doc"
KEYWORDS="~x86 ~amd64"
RDEPEND=">=dev-libs/glib-2.40
	>=x11-libs/gtk+-3.12
	>=dev-libs/libgee-0.10.5
	>=media-sound/xmms2-0.8
	dev-lang/vala"
DEPEND="${RDEPEND}"
S="${WORKDIR}/${PN}"

src_compile() {
	cd ${S}-${PV}
	#sed -i -e "s:/usr/local:${D}/usr:g" scons || die
	./scons PREFIX="${D}" || die "Configure failed"
	#emake || die
}

src_install() {
	cd ${S}-${PV}
	./scons install || die
	#make DESTDIR="${D}" install || die
	dodoc README
}

src_postinst() {
	cd ${S}-${PV}
	./scons -c
}
