EAPI=4

inherit versionator rpm

DESCRIPTION="Scanner driver"
HOMEPAGE="http://welcome.solutions.brother.com/bsc/public_s/id/linux/en/download_scn.html#brscan4"
MY_PV="$(replace_version_separator 3 -)"
SRC_URI="
	amd64? ( http://www.brother.com/pub/bsc/linux/dlf/$PN-${MY_PV}.x86_64.rpm )
	x86? ( http://www.brother.com/pub/bsc/linux/dlf/$PN-${MY_PV}.i386.rpm )
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="media-gfx/sane-backends[usb]"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	rpm_unpack "${A}" || die
}

src_install() {
	cp -r etc "${D}" || die
	cp -r opt "${D}" || die
	cp -r usr "${D}" || die

	# Preserve config, brsaneconfig3 will create the file for us.
	rm "${D}/opt/brother/scanner/brscan4/brsanenetdevice4.cfg"
	mkdir -p "${D}/usr/bin"
	ln -s ../../opt/brother/scanner/brscan4/brsaneconfig4 brsaneconfig4
	#mkdir -p "${D}/etc/sane.d/dll.d"
	#echo "brother4" >"${D}/etc/sane.d/dll.d/brscan4.conf"
}

pkg_postinst() {
	"${ROOT}/opt/brother/scanner/brscan4/setupSaneScan4" -i
	echo
	einfo "In order to use scanner you need to add it first with setupSaneScan4."
	einfo "Example with DCP-7065DN over network:"
	einfo "   /opt/brother/scanner/brscan4/brsaneconfig4 -a name=Scanner_Home_DCP-7065DN model=DCP-7065DN ip=192.168.0.199"
	einfo "   chmod 644 /opt/brother/scanner/brscan4/brsanenetdevice4.cfg"

}

pkg_prerm() {
	"${ROOT}/opt/brother/scanner/brscan4/setupSaneScan4" -e
}
