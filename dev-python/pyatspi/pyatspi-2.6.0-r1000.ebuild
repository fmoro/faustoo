# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
GCONF_DEBUG="no"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="*-jython *-pypy-*"

inherit eutils gnome2 python

DESCRIPTION="Python binding to at-spi library"
HOMEPAGE="http://live.gnome.org/Accessibility"

# Note: only some of the tests are GPL-licensed, everything else is LGPL
LICENSE="LGPL-2 GPL-2+"
SLOT="0"
KEYWORDS="~*"
IUSE="" # test

# test suite is obsolete (at-spi-1.x era) and unpassable
RESTRICT="test"

COMMON_DEPEND="$(python_abi_depend dev-python/dbus-python)
	$(python_abi_depend ">=dev-python/pygobject-2.90.1:3")
"
RDEPEND="${COMMON_DEPEND}
	>=sys-apps/dbus-1
	>=app-accessibility/at-spi2-core-${PV}[introspection]
	!<gnome-extra/at-spi-1.32.0-r1
"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

src_prepare() {
	# https://bugzilla.gnome.org/show_bug.cgi?id=689957
	epatch "${FILESDIR}/${PN}-2.6.0-examples-python3.patch"

	gnome2_src_prepare

	python_clean_py-compile_files
	python_copy_sources
}

src_configure() {
	G2CONF="${G2CONF} --disable-tests"
	python_execute_function -s gnome2_src_configure
}

src_compile() {
	python_execute_function -s gnome2_src_compile
}

src_install() {
	installation() {
		GNOME2_DESTDIR="${T}/images/${PYTHON_ABI}/" gnome2_src_install
	}
	python_execute_function -s installation
	python_merge_intermediate_installation_images "${T}/images"

	python_clean_installation_image
}

pkg_postinst() {
	gnome2_pkg_postinst
	python_mod_optimize pyatspi
}

pkg_postrm() {
	gnome2_pkg_postrm
	python_mod_cleanup pyatspi
}
