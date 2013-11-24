# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/lince/lince-1.0.ebuild,v 1.1 2008/09/23 21:58:13 coldwind Exp $

DESCRIPTION="Application launcher for BlackBox (and others) that allows you to create application buttons in the slit/dock."
SRC_URI="http://bbdock.nethence.com/download/${P}.tar.gz"
HOMEPAGE="http://bbdock.nethence.com/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE="X"

RDEPEND="virtual/blackbox"
DEPEND="${RDEPEND}"

#S=${WORKDIR}/${MY_P}

src_compile() {
	econf
	emake || die "emake failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ChangeLog README NEWS
}
