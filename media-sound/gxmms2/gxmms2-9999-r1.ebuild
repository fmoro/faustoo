# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
# Nonofficial ebuild by Ycarus, additions by Oliver Schneider and Matthias Kuhn. For new version look here : http://gentoo.zugaina.org/

EAPI="2"

inherit eutils 

DESCRIPTION="A GTK+ 2.6 based XMMS2 client"
SRC_URI="http://wejp.k.vu/projects/xmms2/${PN}-HEAD.tar.gz"
#SRC_URI="http://git.xmms.se/?p=gxmms2.git;a=snapshot;h=HEAD;sf=tgz"
HOMEPAGE="http://wejp.k.vu/projects/xmms2/"
LICENSE="GPL-2"
SLOT="0"
RESTRICT="nomirror"
KEYWORDS="~amd64 ~ppc ~sparc x86 ~hppa ~mips ~ppc64 ~alpha ~ia64"
IUSE="gkrellm"

RESTRICT="fetch"

S="${WORKDIR}/${PN}"

RDEPEND=">=x11-libs/gtk+-2.6
	>=media-sound/xmms2-0.2.6
	gkrellm? ( app-admin/gkrellm )"

pkg_nofetch() {
	einfo "This ebuild only works with HEAD tarball of gxmms2."
	einfo "Please, download it from"
	einfo "http://git.xmms.se/?p=gxmms2.git;a=snapshot;h=HEAD;sf=tgz"
	einfo "and put it on DISTFILES directory named gxmms2-HEAD.tar.gz"
}
src_prepare() {
	epatch "${FILESDIR}"/xmms-0.7-xmmsc_playback_seek_ms.patch
}

src_compile() {
	sed -i -e "s/\/usr\/local\/bin/\/usr\/bin/g" Makefile

	if use gkrellm; then
		emake all || die "make failed"
	else
		emake gxmms2 || die "make failed"
	fi
}

src_install() {
	dodir /usr/bin
	exeinto /usr/bin
	doexe gxmms2

	if use gkrellm; then
		#CONF_LIBDIR="lib64" #dolib gkrellxmms2.so
		#dodir /usr/$(get_libdir)/gkrellm2/plugins
		CONF_LIBDIR=""
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins gkrellxmms2.so
	fi
}
