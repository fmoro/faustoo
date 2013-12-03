# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

inherit eutils git-2 multilib

DESCRIPTION="GTK2 based XMMS2 client written in C"
HOMEPAGE="http://wejp.k.vu/projects/xmms2/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="gkrellm"

DEPEND="media-sound/xmms2
	x11-libs/gtk+:2
	gkrellm? ( app-admin/gkrellm:2 )"
RDEPEND="${DEPEND}"

EGIT_REPO_URI="git://git.xmms.se/xmms2/${PN}.git"

#EGIT_PATCHES=( "${FILESDIR}/9999-XMMS-API-update.patch" )

src_compile() {
	emake gxmms2 || die
	if use gkrellm; then
		emake gkrellxmms2 || die
	fi
}

src_install() {
	dobin ${PN}
	if use gkrellm; then
		insinto /usr/$(get_libdir)/gkrellm2/plugins
		doins gkrellxmms2.so
	fi
	dodoc README
	newicon gxmms2src/gxmms2_mini.xpm gxmms2.xpm
	make_desktop_entry gxmms2 GXMMS2
}
