# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/lince/lince-1.1_beta.ebuild,v 1.1 2009/06/29 12:36:02 yngwin Exp $

EAPI="4-python"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.7 *-jython *-pypy-*"
inherit eutils

DESCRIPTION="A light, powerful and full-featured gtkmm bittorrent client"
SRC_URI="mirror://sourceforge/lincetorrent/${P}.tar.gz"
#RESTRICT="fetch"
HOMEPAGE="http://lincetorrent.sourceforge.net"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="dbus libnotify"

RDEPEND="dev-cpp/gtkmm:3.0
	dev-cpp/cairomm
	>=dev-cpp/glibmm-2.16
	<net-libs/rb_libtorrent-0.16.0
	dev-libs/boost
	dev-libs/libxml2
	dev-lang/python:2.7
	sys-devel/gettext
	dbus? ( dev-libs/dbus-glib )
	libnotify? ( x11-libs/libnotify )"
DEPEND="${RDEPEND}
	dev-util/intltool"

#src_prepare() {
#	epatch "${FILESDIR}/${P}-libtorrent.patch"
	#boost_ver=$(best_version "=dev-libs/boost-1.41")
	#export BOOST_INCLUDEDIR="/usr/include/boost-${boost_ver}"
	#export BOOST_LIBRARYDIR="/usr/$(get_libdir)/boost-${boost_ver}"
#}

src_compile() {
	econf $(use_with dbus) $(use_with libnotify)
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
}
