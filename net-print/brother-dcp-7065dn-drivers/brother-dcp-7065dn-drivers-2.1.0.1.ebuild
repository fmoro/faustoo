EAPI=4

inherit rpm multilib

DESCRIPTION="Brother DCP-7065DN LPR+cupswrapper drivers"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#DCP-7065DN"
PV=${PV%.*}-${PV##*.} 
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/dcp7065dnlpr-${PV}.i386.rpm
		http://www.brother.com/pub/bsc/linux/dlf/cupswrapperDCP7065DN-2.0.4-2.i386.rpm"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""
RESTRICT="strip"

DEPEND="net-print/cups
		app-text/a2ps"
RDEPEND="${DEPEND}"

S="${WORKDIR}" # Portage will bitch about missing $S so lets pretend that we have vaild $S.

src_unpack() {
	rpm_unpack ${A}
}

src_install() {
	has_multilib_profile && ABI=x86

	dosbin "${WORKDIR}/usr/local/Brother/Printer/DCP7065DN/inf/brprintconflsr3"

	cp -r usr "${D}" || die

	mkdir -p ${D}/usr/libexec/cups/filter || die
	( cd ${D}/usr/libexec/cups/filter/ && ln -s ../../../../usr/local/Brother/Printer/DCP7065DN/lpd/filterDCP7065DN brlpdwrapperDCP7065DN ) || die
	mkdir -p ${D}/usr/share/cups/model || die
	( cd ${D}/usr/share/cups/model && ln -s ../../../../usr/local/Brother/Printer/DCP7065DN/cupswrapper/cupswrapperDCP7065DN-2.0.4 cupswrapperDCP7065DN-2.0.4.ppd ) || die
}

pkg_postinst () {
	ewarn "You really wanna read this."
	echo
	elog "For add your printer to cups, it is needed to run the wrapper:"
	elog "      /usr/local/Brother/Printer/DCP7065DN/cupswrapper/cupswrapperDCP7065DN-2.0.4"
	elog
	elog "You need to use brprintconflsr3 to change printer options"
	elog "For example, you should set paper type to A4 right after instalation"
	elog "or your prints will be misaligned!"
	elog
	elog "Set A4 Paper type:"
	elog "		brprintconflsr3 -pt A4"
	elog "Set 'Fast Normal' quality:"
	elog "		brprintconflsr3 -reso 300x300dpi"
	elog
	elog "For more options just execute brprintconf_dcpj315w as root"
	elog "You can check current settings in:"
	elog "		/usr/local/Brother/Printer/DCP7065DN/inf/brdcpj315wrc"
	elog "To add printer over WIFI add use LPD or SOCKET protocol, for example:"
	elog "      lpd://<host_or_ip>/BINARY_P1"
	elog "            - or -"
	elog "      socket://<host_or_ip>:9100"
}

# TODO: Write alternative to filterdcpj315w or patch it for the security manner.
