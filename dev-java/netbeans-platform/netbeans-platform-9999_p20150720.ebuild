# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Netbeans Platform"
HOMEPAGE="http://netbeans.org/features/platform/"
SLOT="9999"
SOURCE_URL="http://bits.netbeans.org/download/trunk/nightly/2015-07-20_00-01-56/zip/netbeans-trunk-nightly-201507200001-src.zip"
SRC_URI="${SOURCE_URL}
	http://dev.gentoo.org/~fordfrog/distfiles/netbeans-9999-r14-build.xml.patch.bz2
	http://hg.netbeans.org/binaries/2F7553F50B0D14ED811B849C282DA8C1FFC32AAE-asm-all-5.0.1.jar
	http://hg.netbeans.org/binaries/1BA97A9FFD4A1DFF3E75B76CD3AE3D0EFF8493B7-felix-4.2.1.jar
	http://hg.netbeans.org/binaries/941A8BE4506C65F0A9001C08812FB7DA1E505E21-junit-4.12-javadoc.jar
	http://hg.netbeans.org/binaries/B250509C67194E89C3A27F96933DB7EB0E027E56-ko4j.jar
	http://hg.netbeans.org/binaries/E556F74DF0942B304F94D9F82CAA8102FED6356E-net-java-html.jar
	http://hg.netbeans.org/binaries/C74AC1ED160379872826FDC4A3C0CA924A3A0A83-net-java-html-boot.jar
	http://hg.netbeans.org/binaries/03FE10857B0689B1F98B8D96DE87E80DF5D87A69-net-java-html-boot-fx.jar
	http://hg.netbeans.org/binaries/31C9329E78A222E38CB86716ACFCEF81EF0BA1FD-net-java-html-boot-script.jar
	http://hg.netbeans.org/binaries/24ED356FF3C72665CB5FB972B428824FABBC1987-net-java-html-geo.jar
	http://hg.netbeans.org/binaries/432EDFB05C0F44E6ADAC4B1F3E08C67D1F52FB4B-net-java-html-json.jar
	http://hg.netbeans.org/binaries/A7B6C3470DB8821A3587CE04844FF504A7C62354-net-java-html-sound.jar
	http://hg.netbeans.org/binaries/B27F1304F18FEDE876F940AEFA6C9EB5632619D7-org.eclipse.osgi_3.9.1.v20140110-1610.jar
	http://hg.netbeans.org/binaries/1C7FE319052EF49126CF07D0DB6953CB7007229E-swing-layout-1.0.4-doc.zip
	http://hg.netbeans.org/binaries/AF022CBCACD8CBFCF946816441D1E7568D817745-testng-6.8.1-javadoc.zip"
LICENSE="|| ( CDDL GPL-2-with-linking-exception )"
KEYWORDS="~amd64 ~x86"
IUSE=""
S="${WORKDIR}"

CDEPEND="dev-java/hamcrest-core:1.3
	dev-java/javahelp:0
	>=dev-java/jna-3.4:0
	dev-java/junit:4[source]
	>=dev-java/osgi-core-api-5:0
	dev-java/osgi-compendium:0
	dev-java/swing-layout:1[source]
	dev-java/testng:0"
# oracle-jdk-bin is needed because other jdks do not contain file jre/lib/ext/jfxrt.jar
# the error:
#  [parseprojectxml] Distilling /var/tmp/portage/dev-java/netbeans-platform-9999_p20140922/work/nbbuild/build/public-package-jars/org-netbeans-libs-javafx.jar from [/var/tmp/portage/dev-java/netbeans-platform-9999_p20140922/work/nbbuild/netbeans/platform/modules/org-netbeans-libs-javafx.jar, /opt/icedtea-bin-7.2.4.7/jre/lib/ext/jfxrt.jar]
#  [parseprojectxml] Classpath entry /opt/icedtea-bin-7.2.4.7/jre/lib/ext/jfxrt.jar does not exist; skipping
#  [nbmerge] Failed to build target: all-api.html4j

DEPEND="dev-java/oracle-jdk-bin:1.7
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

INSTALL_DIR="/usr/share/${PN}-${SLOT}"

EANT_BUILD_XML="nbbuild/build.xml"
EANT_BUILD_TARGET="rebuild-cluster"
EANT_EXTRA_ARGS="-Drebuild.cluster.name=nb.cluster.platform -Dext.binaries.downloaded=true -Djava.awt.headless=true -Dpermit.jdk8.builds=true"
EANT_FILTER_COMPILER="ecj-3.3 ecj-3.4 ecj-3.5 ecj-3.6 ecj-3.7"
JAVA_PKG_BSFIX="off"
JAVA_PKG_WANT_BUILD_VM="oracle-jdk-bin-1.7"
JAVA_PKG_WANT_SOURCE="1.7"
JAVA_PKG_WANT_TARGET="1.7"

src_unpack() {
	unpack $(basename ${SOURCE_URL})

	einfo "Deleting bundled jars..."
	find -name "*.jar" -type f -delete

	unpack netbeans-9999-r14-build.xml.patch.bz2

	pushd "${S}" >/dev/null || die
	ln -s "${DISTDIR}"/2F7553F50B0D14ED811B849C282DA8C1FFC32AAE-asm-all-5.0.1.jar libs.asm/external/asm-all-5.0.1.jar || die
	ln -s "${DISTDIR}"/1BA97A9FFD4A1DFF3E75B76CD3AE3D0EFF8493B7-felix-4.2.1.jar libs.felix/external/felix-4.2.1.jar || die
	ln -s "${DISTDIR}"/941A8BE4506C65F0A9001C08812FB7DA1E505E21-junit-4.12-javadoc.jar junitlib/external/junit-4.12-javadoc.jar || die
	ln -s "${DISTDIR}"/B250509C67194E89C3A27F96933DB7EB0E027E56-ko4j.jar o.n.html.ko4j/external/ko4j.jar || die
	ln -s "${DISTDIR}"/E556F74DF0942B304F94D9F82CAA8102FED6356E-net-java-html.jar net.java.html/external/net-java-html.jar || die
	ln -s "${DISTDIR}"/C74AC1ED160379872826FDC4A3C0CA924A3A0A83-net-java-html-boot.jar net.java.html.boot/external/net-java-html-boot.jar || die
	ln -s "${DISTDIR}"/03FE10857B0689B1F98B8D96DE87E80DF5D87A69-net-java-html-boot-fx.jar net.java.html.boot.fx/external/net-java-html-boot-fx.jar || die
	ln -s "${DISTDIR}"/31C9329E78A222E38CB86716ACFCEF81EF0BA1FD-net-java-html-boot-script.jar net.java.html.boot.script/external/net-java-html-boot-script.jar || die
	ln -s "${DISTDIR}"/24ED356FF3C72665CB5FB972B428824FABBC1987-net-java-html-geo.jar net.java.html.geo/external/net-java-html-geo.jar || die
	ln -s "${DISTDIR}"/432EDFB05C0F44E6ADAC4B1F3E08C67D1F52FB4B-net-java-html-json.jar net.java.html.json/external/net-java-html-json.jar || die
	ln -s "${DISTDIR}"/A7B6C3470DB8821A3587CE04844FF504A7C62354-net-java-html-sound.jar net.java.html.sound/external/net-java-html-sound.jar || die
	ln -s "${DISTDIR}"/B27F1304F18FEDE876F940AEFA6C9EB5632619D7-org.eclipse.osgi_3.9.1.v20140110-1610.jar netbinox/external/org.eclipse.osgi_3.9.1.v20140110-1610.jar || die
	ln -s "${DISTDIR}"/1C7FE319052EF49126CF07D0DB6953CB7007229E-swing-layout-1.0.4-doc.zip o.jdesktop.layout/external/swing-layout-1.0.4-doc.zip || die
	ln -s "${DISTDIR}"/AF022CBCACD8CBFCF946816441D1E7568D817745-testng-6.8.1-javadoc.zip libs.testng/external/testng-6.8.1-javadoc.zip || die
	popd >/dev/null || die
}

src_prepare() {
	einfo "Deleting bundled class files..."
	find -name "*.class" -type f | xargs rm -vf

	# upstream jna jar contains bundled binary libraries so we disable that feature
	epatch netbeans-9999-r14-build.xml.patch

	# Support for custom patches
	if [ -n "${NETBEANS9999_PATCHES_DIR}" -a -d "${NETBEANS9999_PATCHES_DIR}" ] ; then
		local files=`find "${NETBEANS9999_PATCHES_DIR}" -type f`

		if [ -n "${files}" ] ; then
			einfo "Applying custom patches:"

			for file in ${files} ; do
				epatch "${file}"
			done
		fi
	fi

	einfo "Symlinking external libraries..."
	java-pkg_jar-from --into libs.junit4/external hamcrest-core-1.3 hamcrest-core.jar hamcrest-core-1.3.jar
	java-pkg_jar-from --into libs.jna.platform/external jna platform.jar jna-platform-4.1.0.jar
	java-pkg_jar-from --into javahelp/external javahelp jhall.jar jhall-2.0_05.jar
	java-pkg_jar-from --into libs.jna/external jna jna.jar jna-4.1.0.jar
	java-pkg_jar-from --into libs.junit4/external junit-4 junit.jar junit-4.12.jar
	ln -s /usr/share/junit-4/sources/junit-src.zip junitlib/external/junit-4.12-sources.jar || die
	java-pkg_jar-from --into libs.osgi/external osgi-core-api osgi-core-api.jar osgi.core-5.0.0.jar
	java-pkg_jar-from --into libs.osgi/external osgi-compendium osgi-compendium.jar osgi.cmpn-4.2.jar
	java-pkg_jar-from --into o.jdesktop.layout/external swing-layout-1 swing-layout.jar swing-layout-1.0.4.jar
	ln -s /usr/share/swing-layout-1/sources/swing-layout-src.zip o.jdesktop.layout/external/swing-layout-1.0.4-src.zip || die
	java-pkg_jar-from --into libs.testng/external testng testng.jar testng-6.8.1-dist.jar

	java-pkg-2_src_prepare
}

src_compile() {
	unset DISPLAY
	eant -f ${EANT_BUILD_XML} ${EANT_EXTRA_ARGS} ${EANT_BUILD_TARGET} || die "Compilation failed"
}

src_install() {
	pushd nbbuild/netbeans/platform >/dev/null || die

	java-pkg_dojar lib/*.jar
	grep -E "/platform$" ../moduleCluster.properties > "${D}"/${INSTALL_DIR}/moduleCluster.properties || die

	insinto ${INSTALL_DIR}
	doins -r *
	rm "${D}"/${INSTALL_DIR}/docs/junit-4.12-sources.jar || die
	dosym /usr/share/junit-4/sources/junit-src.zip ${INSTALL_DIR}/docs/junit-4.12-sources.jar
	rm "${D}"/${INSTALL_DIR}/docs/swing-layout-1.0.4-src.zip || die
	dosym /usr/share/swing-layout-1/sources/swing-layout-src.zip ${INSTALL_DIR}/docs/swing-layout-1.0.4-src.zip
	find "${D}"/${INSTALL_DIR} -name "*.exe" -delete
	find "${D}"/${INSTALL_DIR} -name "*.dll" -delete
	rm -fr "${D}"/modules/lib || die

	popd >/dev/null || die

	fperms 775 ${INSTALL_DIR}/lib/nbexec
	dosym ${INSTALL_DIR}/lib/nbexec /usr/bin/nbexec-${SLOT}

	local instdir=${INSTALL_DIR}/modules/ext
	pushd "${D}"/${instdir} >/dev/null || die
	rm hamcrest-core-1.3.jar && dosym /usr/share/hamcrest-core-1.3/lib/hamcrest-core.jar ${instdir}/hamcrest-core-1.3.jar || die
	rm jhall-2.0_05.jar && dosym /usr/share/javahelp/lib/jhall.jar ${instdir}/jhall-2.0_05.jar || die
	rm jna-4.1.0.jar && dosym /usr/share/jna/lib/jna.jar ${instdir}/jna-4.1.0.jar || die
	rm jna-platform-4.1.0.jar && dosym /usr/share/jna/lib/platform.jar ${instdir}/jna-platform-4.1.0.jar || die
	rm junit-4.12.jar && dosym /usr/share/junit-4/lib/junit.jar ${instdir}/junit-4.12.jar || die
	rm osgi.cmpn-4.2.jar && dosym /usr/share/osgi-compendium/lib/osgi-compendium.jar ${instdir}/osgi.cmpn-4.2.jar || die
	rm osgi.core-5.0.0.jar && dosym /usr/share/osgi-core-api/lib/osgi-core-api.jar ${instdir}/osgi.core-5.0.0.jar || die
	rm swing-layout-1.0.4.jar && dosym /usr/share/swing-layout-1/lib/swing-layout.jar ${instdir}/swing-layout-1.0.4.jar || die
	rm testng-6.8.1-dist.jar && dosym /usr/share/testng/lib/testng.jar ${instdir}/testng-6.8.1-dist.jar || die
	popd >/dev/null || die

	dosym ${INSTALL_DIR} /usr/share/netbeans-nb-${SLOT}/platform
}
