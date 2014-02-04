# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/lince/lince-0.99.4.ebuild,v 1.2 2008/06/19 14:21:51 coldwind Exp $

EAPI="1"

if [[ ${PV} = 9999 ]] ; then
	inherit subversion
	#ESVN_REPO_URI=https://lincetorrent.svn.sourceforge.net/svnroot/lincetorrent
	ESVN_REPO_URI=https://svn.code.sf.net/p/lincetorrent/code/
else
	MY_P="Lince-${PV}"
	S=${WORKDIR}/${MY_P}
	SRC_URI="mirror://sourceforge/lincetorrent/${MY_P}.tar.gz"
fi

DESCRIPTION="a light, powerfull and full feature gtkmm bittorrent client"
HOMEPAGE="http://lincetorrent.sourceforge.net"

RDEPEND="dev-cpp/gtkmm:3.0
	x11-libs/cairo
	net-libs/rb_libtorrent
	dev-libs/libxml2
	sys-devel/gettext"
DEPEND="${RDEPEND}
	dev-util/intltool"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

src_compile() {
	cd trunk
	#epatch ${FILESDIR}/${PN}-install_engines.patch
	sh build.sh
	econf --without-libnotify
	emake || die
}

src_install () {
	cd trunk
	emake DESTDIR="${D}" install || die
}
