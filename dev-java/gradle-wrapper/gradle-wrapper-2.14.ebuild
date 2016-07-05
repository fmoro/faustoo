# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit unpacker java-pkg-2 java-pkg-simple

MY_PN=gradle
DESCRIPTION="gradle-wrapper of Gradle build automation"
HOMEPAGE="https://gradle.org/"
SRC_URI="https://services.gradle.org/distributions/${MY_PN}-${PV}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=virtual/jdk-1.5
	app-arch/zip"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"/${MY_PN}-${PV}

_keep_gradle_wrapper_sources_only() {
	rm -R subprojects/wrapper/src/{integTest,test}/ || die
	rm -R subprojects/cli/src/test/ || die

	mkdir -p "${T}"/KEEP/subprojects/{cli,wrapper}/src/ || die
	mv subprojects/cli/src/ "${T}"/KEEP/subprojects/cli/ || die
	mv subprojects/wrapper/src/ "${T}"/KEEP/subprojects/wrapper/ || die

	rm -R "${S}" || die
	mv "${T}"/KEEP "${S}" || die
}

_add_build_receipt_properties() {
	[[ -f ${PN}.jar ]] || die
	echo "versionNumber=${PV}" > "${T}"/build-receipt.properties
	zip --junk-paths ${PN}.jar "${T}"/build-receipt.properties || die
}

java_prepare() {
	_keep_gradle_wrapper_sources_only
}

src_compile() {
	java-pkg-simple_src_compile
	_add_build_receipt_properties
}
