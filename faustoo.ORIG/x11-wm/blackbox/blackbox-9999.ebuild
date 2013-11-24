# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/blackbox/blackbox-0.70.1.ebuild,v 1.9 2009/05/05 06:04:15 fauli Exp $

inherit eutils
inherit cvs
DESCRIPTION="A small, fast, full-featured window manager for X"
HOMEPAGE="http://blackboxwm.sourceforge.net/"

ECVS_SERVER="blackboxwm.cvs.sourceforge.net:/cvsroot/blackboxwm"
ECVS_USER="anonymous"
ECVS_PASS=""
ECVS_MODULE="blackbox"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="nls truetype debug patch"

RDEPEND="x11-libs/libXft
	x11-libs/libXt
	nls? ( sys-devel/gettext )
	truetype? ( media-libs/freetype )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-apps/sed-4
	x11-proto/xextproto"

PROVIDE="virtual/blackbox"

S="${WORKDIR}/${PN}"

src_unpack() {
	cvs_src_unpack || die "cvs_src_unpack enigmail failed"
	#unpack ${A}
	cd ${S}
	#epatch "${FILESDIR}/${PN}-0.70.1-gcc-4.3.patch"
	if has_version ">=x11-libs/libX11-1.4.0"; then
		sed -i -e "s/_XUTIL_H_/_X11&/" lib/Util.hh || die #348556
	fi
	if use patch; then
		# Add [include-sub] function.
		# http://sourceforge.net/tracker/index.php?func=detail&aid=2499535&group_id=40696&atid=428682
		epatch "${FILESDIR}/${PN}-0.70.1-include_subdir.patch"
	fi
	sh mk.sh
	eautoreconf
}

src_compile() {
	econf \
		--sysconfdir=/etc/X11/${PN} \
		$(use_enable debug) \
		$(use_enable nls) \
		$(use_enable truetype xft) \
		|| die "econf failed"
	emake || die "emake failed"
}

src_install() {
	dodir /etc/X11/Sessions
	echo "/usr/bin/blackbox" > "${D}/etc/X11/Sessions/${PN}"
	fperms a+x /etc/X11/Sessions/${PN}

	insinto /usr/share/xsessions
	doins "${FILESDIR}/${PN}.desktop"

	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc AUTHORS ChangeLog* COMPLIANCE README* TODO
}
