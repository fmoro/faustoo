# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit autotools rpm

SRC_REV="1"   # Revision used by upstream.
LSB_REV="3.2" # Revision of Linux Standard Base.

DESCRIPTION="Epson Inkjet Printer Driver (ESC/P-R); supports various printers."
HOMEPAGE="http://avasys.jp/eng/linux_driver/download/lsb/epson-inkjet/escpr/"
SRC_URI="http://linux.avasys.jp/drivers/lsb/epson-inkjet/escpr/src/${P}-${SRC_REV}lsb${LSB_REV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

# XXX: These are the supported languages, but there is no way to enable/disable
#      them in the package via configure or remove the unrequired languages
#      from the PPD files.
LANGS="de en es fr it ja ko nl pt zh_CN zh_TW"
for X in ${LANGS} ; do
	IUSE="${IUSE} linguas_${X}"
done

RDEPEND="net-print/cups"
DEPEND="${REPEND}
	app-arch/gzip"

#src_unpack() {
#	rpm_src_unpack
#}

src_prepare() {
	# Modify Linux Standard Base (LSB) paths:
	sed -i -e 's:/opt/lsb/:/usr/:g' configure.ac || die
	# Fix installation path for PPD files:
	sed -i -e 's:\(CUPS_PPD_DIR=.*`\)$:\1/model:' configure.ac || die
	# Modify installation path for PPD files:
	sed -i -e 's:\(CUPS_PPD_DIR=.*/model\)$:\1/'${PN}':' configure.ac || die
	eautoreconf
}

src_compile() {
	emake -j1
}

src_install() {
	emake DESTDIR="${D}" install

	# Compress the PPD files:
	mkdir "${D}"/usr/share/ppd/epson
	mv "${D}"/usr/share/ppd/*.ppd "${D}"/usr/share/ppd/epson/
	for ppd in "${D}"/usr/share/ppd/epson/*; do
		gzip "${ppd}" || die
	done
	#mv "${D}"/usr/share/ppd/*.gz "${D}"/usr/share/ppd/epson
	# Install documentation:
	dodoc README AUTHORS NEWS
	if use linguas_ja; then
		nonfatal dodoc README.ja
	fi
}

pkg_postinst() {
	echo
	ewarn 'You may need to manually update PPD files installed in /etc/cups/ppd'
	ewarn "with a newer copy from /usr/share/cups/model/${PN}"
	echo
	elog 'Note that the only options that can currently be configured are ink,'
	elog 'paper size, and print quality.  You may find that another driver is'
	elog 'more suitable if you need to be able to configure options such as'
	elog 'duplexing or resolution.'
	echo
}
