EAPI="3"

inherit autotools rpm

MY_PN="${PN}"
MY_P="${MY_PN}-201110w-1.0.0-1lsb3.2"

DESCRIPTION="Testing ebuild for epson-inkjet-printer."
HOMEPAGE="https://forums.gentoo.org/viewtopic-t-908358-highlight-.html"
SRC_URI="http://linux.avasys.jp/drivers/lsb/epson-inkjet/stable/SRPMS/${MY_P}.src.rpm"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

DEPEND="net-print/cups"
RDEPEND="${DEPEND}"

S=${WORKDIR}/epson-inkjet-printer-filter-1.0.0/

src_unpack() {
	rpm_src_unpack
}

src_prepare() {
#        ewarn "–––––––––––––––––––––––––––––––––––––––––––––––––" 
#        ewarn "The configure file is not set to be an executable" 
#        ewarn "or not set with the rights for executing it which" 
#        ewarn "causes emake to fail so as a dirty 'fix', setting" 
#        ewarn "rights to 700 here." 
#        ewarn "–––––––––––––––––––––––––––––––––––––––––––––––––" 
#        chmod 700 ${WORKDIR}/epson-inkjet-printer-filter-1.0.0/configure 
	sed -i -e 's:/opt/lsb/:/usr/:g' configure.ac || die
	eautoreconf
	chmod 777 configure
}

src_compile() {
	emake -j1 || die
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

