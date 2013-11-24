# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-emulation/snes9x/snes9x-1.53.ebuild,v 1.12 2013/04/06 20:32:18 ulm Exp $

EAPI=2
inherit autotools eutils flag-o-matic multilib games

DESCRIPTION="Raspberry PI port of SNES9x"
HOMEPAGE="https://github.com/chep/snes9x-rpi"
SRC_URI="https://github.com/chep/${PN}/archive/v${PV}.tar.gz"

LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="alsa debug gtk joystick multilib netplay nls opengl oss png pulseaudio portaudio +xv +xrandr zlib"
RESTRICT="bindist"

RDEPEND="media-libs/libsdl
	media-libs/alsa-oss"

DEPEND="${RDEPEND}"

#S=${WORKDIR}/${P}

pkg_setup() {
	games_pkg_setup
}

src_configure() {
	echo "nothing to do here"
}

src_compile() {
	games_src_compile
}

src_install() {
	dogamesbin ${PN} || die

	#dohtml {.,..}/docs/*.html
	#dodoc ../docs/{snes9x.conf.default,{changes,control-inputs,controls,snapshots}.txt}

	#if use gtk; then
	#	emake -C ../gtk DESTDIR="${D}" install || die
	#	dodoc ../gtk/{AUTHORS,doc/README}
	#fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	#use gtk && gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	#use gtk && gnome2_icon_cache_update
}
