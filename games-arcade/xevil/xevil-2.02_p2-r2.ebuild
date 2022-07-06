# Distributed under the terms of the GNU General Public License v2

EAPI=2
inherit eutils games

DEB_PATCH=7
MY_PV=${PV/_p/r}
DESCRIPTION="3rd person, side-view, fast-action, kill-them-before-they-kill-you game"
HOMEPAGE="http://www.xevil.com/"
SRC_URI="http://www.xevil.com/download/stable/xevilsrc${MY_PV}.zip
	mirror://debian/pool/main/x/xevil/xevil_${MY_PV}-${DEB_PATCH}.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="ppc x86 amd64"
IUSE=""

RDEPEND="x11-libs/libXpm
	media-fonts/font-adobe-75dpi
	media-fonts/font-adobe-100dpi"

DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}

src_prepare() {
	edos2unix readme.txt x11/*.{cpp,h} cmn/*.{cpp,h} makefile config.mk
	epatch "${WORKDIR}"/xevil_${MY_PV}-${DEB_PATCH}.diff
	sed -i \
		-e 's:-static::' \
		-e 's/CC="g++"/CC=$(CXX)/' \
		-e "s:CFLAGS=\":CFLAGS=\"${CXXFLAGS} :g" \
		-e 's:-lXpm:-lXpm -lpthread:g' \
		-e "s:LINK_FLAGS=\":LINK_FLAGS=\"${LDFLAGS} :" \
		config.mk || die "sed failed"
	epatch "${FILESDIR}"/${P}-glibc-2.10.patch
	epatch "${FILESDIR}"/${P}-x86_64.patch
	epatch "${FILESDIR}"/${P}-gcc7.patch
}

src_install() {
	dogamesbin x11/REDHAT_LINUX/xevil || die "dogamesbin failed"
	newgamesbin x11/REDHAT_LINUX/serverping xevil-serverping \
		|| die "newgamesbin failed"
	dodoc readme.txt
	prepgamesdirs
}
