# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/swi-prolog/swi-prolog-5.6.64.ebuild,v 1.13 2009/05/26 18:45:22 keri Exp $

inherit eutils flag-o-matic java-pkg-opt-2

MY_PV="${PV//./_}"
MY_PV="${MY_PV/_/.}"

DESCRIPTION="free, small, and standard compliant Prolog compiler"
HOMEPAGE="http://eclipseclp.org/"
SRC_URI="http://eclipseclp.org/Distribution/${MY_PV}/src/eclipse_src.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="X"

#RDEPEND="!media-libs/ploticus
#	sys-libs/ncurses
#	zlib? ( sys-libs/zlib )
#	odbc? ( dev-db/unixODBC )
#	berkdb? ( sys-libs/db )
#	readline? ( sys-libs/readline )
#	gmp? ( dev-libs/gmp )
#	ssl? ( dev-libs/openssl )
#	java? ( >=virtual/jdk-1.4
#		test? ( =dev-java/junit-3.8* ) )
#	X? (
#		media-libs/jpeg
#		x11-libs/libX11
#		x11-libs/libXft
#		x11-libs/libXpm
#		x11-libs/libXt
#		x11-libs/libICE
#		x11-libs/libSM )"

#DEPEND="${RDEPEND}
#	X? ( x11-proto/xproto )"

S="${WORKDIR}/Eclipse_${MY_PV}"

ARCH=""
#src_unpack() {
#	unpack ${A}
#	cd "${S}"
#
#	EPATCH_FORCE=yes
#	EPATCH_SUFFIX=patch
#	epatch "${WORKDIR}"/${PV}
#}

src_compile() {
	einfo "Building Eclipse-clp"

	#append-flags -fno-strict-aliasing
	#use hardened && append-flags -fno-unit-at-a-time
	#use debug && append-flags -DO_DEBUG

	#cd "${S}"/src
	#econf \
	#	--libdir=/usr/$(get_libdir) \
	#	$(use_enable gmp) \
	#	$(use_enable readline) \
	#	$(use_enable !static shared) \
	#	--enable-custom-flags COFLAGS="${CFLAGS}" \
	#	|| die "econf failed"
	if use amd64; then
		ARCH=x86_64_linux
	elif use x86; then
		ARCH=i386_linux
	fi
	CONFIG_SITE=config.$ARCH
	#./configure --prefix "${D}" || die "econf failed"
	econf --prefix "${D}" || die "econf failed"
	epatch "${FILESDIR}/${PN}-eclipsedir.patch"
	#make DESTDIR="${D}" -f Makefile.$ARCH || die "emake failed"
}

src_install() {
	if use doc; then
		make -f Makefile.$ARCH install_documents || die "install src failed"
	fi
	make DESTDIR="${D}" -f Makefile.$ARCH install || die "install src failed"

	#dodoc ChangeLog INSTALL PORTING README VERSION
}
