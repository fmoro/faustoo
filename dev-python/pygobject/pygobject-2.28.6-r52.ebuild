# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
GCONF_DEBUG="no"
GNOME2_LA_PUNT="yes"
PYTHON_MULTIPLE_ABIS="1"
PYTHON_RESTRICTED_ABIS="2.5 *-jython *-pypy-*"

# XXX: Is the alternatives stuff needed anymore?
inherit alternatives autotools eutils gnome2 multilib python virtualx

DESCRIPTION="GLib's GObject library bindings for Python"
HOMEPAGE="http://www.pygtk.org/"

LICENSE="LGPL-2.1+"
SLOT="2"
KEYWORDS="*"
IUSE="examples libffi test"
# FIXME: tests require introspection support, but we can't enable introspection,
# or we get file collisions with slot 3 :/
RESTRICT="test"

COMMON_DEPEND=">=dev-libs/glib-2.24.0:2
	libffi? ( virtual/libffi )"
DEPEND="${COMMON_DEPEND}
	dev-util/gtk-doc-am
	test? (
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc )
	virtual/pkgconfig"
RDEPEND="${COMMON_DEPEND}
	!<dev-python/pygtk-2.13"

pkg_setup() {
	DOCS="AUTHORS ChangeLog* NEWS README"
	# --disable-introspection and --disable-cairo because we use pygobject:3
	# for introspection support
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-introspection
		--disable-cairo
		$(use_with libffi ffi)"
	python_pkg_setup
}

src_prepare() {
	# Fix FHS compliance, see upstream bug #535524
	epatch "${FILESDIR}/${PN}-2.28.3-fix-codegen-location.patch"

	# Do not build tests if unneeded, bug #226345
	epatch "${FILESDIR}/${PN}-2.28.3-make_check.patch"

	# Use Python 2 in pygobject-codegen-2.0.
	epatch "${FILESDIR}/${PN}-2.28.3-support_multiple_python_versions.patch"

	# Disable tests that fail
	epatch "${FILESDIR}/${PN}-2.28.3-disable-failing-tests.patch"

	# Fix warning spam
	epatch "${FILESDIR}/${P}-set_qdata.patch"
	epatch "${FILESDIR}/${P}-gio-types-2.32.patch"

	# Support Python 3.
	epatch "${FILESDIR}/${P}-python-3.patch"
	epatch "${FILESDIR}/${P}-python-3-codegen.patch"
	sed -e "s/print datetime.date.today()/print(datetime.date.today())/" -i docs/Makefile.am

	python_clean_py-compile_files

	eautoreconf
	gnome2_src_prepare

	python_copy_sources
}

src_configure() {
	configuration() {
		PYTHON="$(PYTHON)" gnome2_src_configure
	}
	python_execute_function -s configuration
}

src_compile() {
	python_execute_function -d -s
}

src_test() {
	unset DBUS_SESSION_BUS_ADDRESS

	testing() {
		XDG_CACHE_HOME="${T}/${PYTHON_ABI}"
		Xemake check PYTHON=$(PYTHON -a)
	}
	python_execute_function -s testing
}

src_install() {
	installation() {
		GNOME2_DESTDIR="${T}/images/${PYTHON_ABI}/" gnome2_src_install
		mv "${T}/images/${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)/pygtk.py"{,-2.0}
		mv "${T}/images/${PYTHON_ABI}${EPREFIX}$(python_get_sitedir)/pygtk.pth"{,-2.0}

		if [[ "${PYTHON_ABI}" == 3.* ]]; then
			rm -f "${T}/images/${PYTHON_ABI}${EPREFIX}/usr/$(get_libdir)/pkgconfig/pygobject-2.0.pc"
		fi
	}
	python_execute_function -s installation
	python_merge_intermediate_installation_images "${T}/images"

	python_clean_installation_image

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples
	fi
}

pkg_postinst() {
	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.py" pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.pth" pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks

	python_mod_optimize glib gobject gtk-2.0 pygtk.py
}

pkg_postrm() {
	python_mod_cleanup glib gobject gtk-2.0 pygtk.py

	create_symlinks() {
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.py" pygtk.py-[0-9].[0-9]
		alternatives_auto_makesym "$(python_get_sitedir)/pygtk.pth" pygtk.pth-[0-9].[0-9]
	}
	python_execute_function create_symlinks
}
