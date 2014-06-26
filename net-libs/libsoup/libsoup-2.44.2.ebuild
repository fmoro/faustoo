# Distributed under the terms of the GNU General Public License v2

EAPI="5"
GCONF_DEBUG="yes"
GNOME2_LA_PUNT="yes"
PYTHON_COMPAT=( python{2_6,2_7} )

inherit gnome2 multilib-minimal python-any-r1

DESCRIPTION="An HTTP library implementation in C"
HOMEPAGE="https://wiki.gnome.org/LibSoup"

LICENSE="LGPL-2+"
SLOT="2.4"
IUSE="debug +introspection samba ssl test"
KEYWORDS="*"

RDEPEND="
	>=dev-libs/glib-2.36.0:2[${MULTILIB_USEDEP}]
	>=dev-libs/libxml2-2:2[${MULTILIB_USEDEP}]
	dev-db/sqlite:3[${MULTILIB_USEDEP}]
	>=net-libs/glib-networking-2.30.0[ssl?,${MULTILIB_USEDEP}]
	introspection? ( >=dev-libs/gobject-introspection-0.9.5 )
	samba? ( net-fs/samba )
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	>=dev-util/intltool-0.35
	>=dev-util/gtk-doc-am-1.10
	sys-devel/gettext
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]
"
RDEPEND="${RDEPEND}
	abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20140508-r8
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32(-)]
	)
"
src_prepare() {
	if ! use test; then
		# don't waste time building tests (bug #226271)
		sed 's/^\(SUBDIRS =.*\)tests\(.*\)$/\1\2/' -i Makefile.am Makefile.in \
			|| die "sed failed"
	fi

	gnome2_src_prepare
}

multilib_src_configure() {
	# FIXME: we need addpredict to workaround bug #324779 until
	# root cause (bug #249496) is solved
	addpredict /usr/share/snmp/mibs/.index

	# Disable apache tests until they are usable on Gentoo, bug #326957
	ECONF_SOURCE=${S} \
	gnome2_src_configure \
		--disable-static \
		--disable-tls-check \
		--without-gnome \
		--without-apache-httpd \
		$(multilib_native_use_enable introspection) \
		$(use_with samba ntlm-auth '${EPREFIX}'/usr/bin/ntlm_auth)

	if multilib_is_native_abi; then
		# fix gtk-doc
		ln -s "${S}"/docs/reference/html docs/reference/html || die
	fi
}

multilib_src_install() {
	gnome2_src_install
}
