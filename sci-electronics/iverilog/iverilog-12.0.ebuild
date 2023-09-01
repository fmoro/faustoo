# Copyright 2023 Gentoo Authors
# # Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_PV="${PV//./_}"

DESCRIPTION="A Verilog simulation and synthesis tool"
SRC_URI="https://github.com/steveicarus/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
HOMEPAGE="
	http://iverilog.icarus.com
	https://github.com/steveicarus/iverilog
"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="examples"

DEPEND="
	sys-libs/readline:=
	sys-libs/zlib
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/gperf
	sys-devel/bison
	sys-devel/flex
"

S="${WORKDIR}/${PN}-${MY_PV}"

src_prepare() {
	default

	# From upstreams autoconf.sh, to make it utilize the autotools eclass
	# Here translate the autoconf.sh, equivalent to the following code
	# > sh autoconf.sh

	# Autoconf in root ...
	eautoconf

	# Precompiling lexor_keyword.gperf
	gperf -o -i 7 -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf \
		> lexor_keyword.cc || die
	# Precompiling vhdlpp/lexor_keyword.gperf
	cd vhdlpp || die
	gperf -o -i 7 --ignore-case -C -k 1-4,6,9,\$ -H keyword_hash -N check_identifier -t ./lexor_keyword.gperf \
		> lexor_keyword.cc || die
}

src_install() {
	local DOCS=( *.txt )

	default

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
