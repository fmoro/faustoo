# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit multilib rpm

SRC_REV="2" # Revision used by upstream.

DESCRIPTION="Image Scan! for Linux network plugin"
HOMEPAGE="http://download.ebz.epson.net"

RESTRICT="fetch strip"
SRC_URI="
	amd64? ( http://linux.avasys.jp/drivers/scanner-plugins/${PN}/${PV}/${P}-${SRC_REV}.x86_64.rpm )
	x86?   ( http://linux.avasys.jp/drivers/scanner-plugins/${PN}/${PV}/${P}-${SRC_REV}.i386.rpm )"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

QA_PRESTRIPPED="usr/libexec/iscan/network"

RDEPEND="media-gfx/iscan"
DEPEND="${RDEPEND}"

S="${WORKDIR}/usr"

src_install() {
	# Install plugin:
	exeinto /usr/$(get_libdir)/iscan
	doexe $(get_libdir)/iscan/network

	# Install documentation:
	dodoc share/doc/"${PF}"/{NEWS,README}
}
