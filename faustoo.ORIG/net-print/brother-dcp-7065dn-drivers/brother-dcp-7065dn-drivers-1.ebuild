EAPI=4

inherit rpm multilib

DESCRIPTION="Brother DCP-J315W LPR+cupswrapper drivers"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_prn.html#DCP-7065DN"
SRC_URI="http://www.brother.com/pub/bsc/linux/dlf/dcp7065dnlpr-2.1.0-1.i386.rpm
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
	elog "You need to use brprintconf_dcpj315w to change printer options"
	elog "For example, you should set paper type to A4 right after instalation"
	elog "or your prints will be misaligned!"
	elog
	elog "Set A4 Paper type:"
	elog "		brprintconf_dcpj315w -pt A4"
	elog "Set 'Fast Normal' quality:"
	elog "		brprintconf_dcpj315w -reso 300x300dpi"
	elog
	elog "For more options just execute brprintconf_dcpj315w as root"
	elog "You can check current settings in:"
	elog "		/usr/local/Brother/Printer/dcpj315w/inf/brdcpj315wrc"
}

# TODO: Write alternative to filterdcpj315w or patch it for the security manner.
# TODO: Write something about config printer over WIFI.
