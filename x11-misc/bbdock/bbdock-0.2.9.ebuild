# Distributed under the terms of the GNU General Public License v2

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
