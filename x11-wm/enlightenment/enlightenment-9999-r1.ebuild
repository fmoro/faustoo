# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://github.com/jeffdameth/ecomorph-e17.git"
inherit git libtool flag-o-matic

DESCRIPTION="e17 window manager with compiz"
HOMEPAGE="http://code.google.com/p/itask-module/wiki/Stuff
http://web.enlightenment.org/"

LICENSE="BSD"
SLOT="0.17"
IUSE="pam exchange -patches"

RDEPEND=">=x11-libs/ecore-9999
	>=media-libs/edje-9999
	>=dev-libs/eet-9999
	>=dev-libs/efreet-9999
	>=dev-libs/embryo-9999
	>=dev-libs/eina-9999
	>=x11-libs/evas-9999
	>=x11-libs/e_dbus-9999
	pam? ( sys-libs/pam )
	exchange? ( >=app-misc/exchange-9999 )"
DEPEND="${RDEPEND}
	!x11-plugins/e_modules-systray
	x11-proto/xproto
	sys-devel/libtool"

pkg_setup() {
	if ! built_with_use x11-libs/evas png ; then
		eerror "Re-emerge evas with USE=png"
		die "Re-emerge evas with USE=png"
	fi
}

# the stupid gettextize script prevents non-interactive mode, so we hax it
gettext_modify() {
	use nls || return 0
	cp $(type -P gettextize) "${T}"/ || die "could not copy gettextize"
	sed -i \
		-e 's:read dummy < /dev/tty::' \
		"${T}"/gettextize
}

src_unpack() {
	git_src_unpack
	gettext_modify
	[[ -s gendoc ]] && chmod a+rx gendoc

	if use patches; then
		# The following are some patches that I personally use. These run fine
		# on my system. You can uncomment them if you want. Don't forget to do
		# ebuild /usr/local/portage/x11-wm/ecomp/ecomp-9999.ebuild digest
		# after uncommenting these lines
		# 
		# Change to the source directory before doing any patching. This line
		# *must* be uncommented if you uncomment any lines further below
		cd $S
		#
		# The following allows you to specify whether you want direct or
		# indirect rendering. If you run ecomorph as
		# INDIRECT="yes" ecomorph.sh
		# then you will get indirect rendering. Uncomment the following line:
		sed -i -e '/^INDIRECT=/s/"no"/\${INDIRECT:-no}/' data/script/ecomorph.sh
		#
		# The following line allows you to pass arguments to
		# enlightenment_start.sh
		sed -i -e '/^enlightenment_start /s/$/ "\$@"/' \
			data/script/enlightenment_start.sh
	fi
}

src_compile() {
	# Try getting rid of segfaults and some non-functionalities
	filter-ldflags "-Wl,--as-needed"
	filter-ldflags "-Wl,-O1"

	export MY_ECONF="
		$(use_enable exchange conf-theme)
	"
	# gstreamer sucks, work around it doing stupid stuff
	export GST_REGISTRY="${S}/registry.xml"

	if [[ ! -e configure ]] ; then
		env \
			PATH="${T}:${PATH}" \
			NOCONFIGURE=yes \
			USER=blah \
			./autogen.sh \
			|| die "autogen failed"
		# symlinked files will cause sandbox violation
		local x
		for x in config.{guess,sub} ; do
			[[ ! -L ${x} ]] && continue
			rm -f ${x}
			touch ${x}
		done
	else
		eautoreconf
	fi
	epunt_cxx
	elibtoolize
	econf ${MY_ECONF} || die "econf failed"
	emake || die "emake failed"
	use doc && [[ -x ./gendoc ]] && { ./gendoc || die "gendoc failed" ; }
}


src_install() {
	emake install DESTDIR="${D}" || die
	find "${D}" '(' -name CVS -o -name .svn -o -name .git ')' -type d -exec rm -rf '{}' \; 2>/dev/null
	dodoc AUTHORS ChangeLog NEWS README TODO
	use doc && [[ -d doc ]] && dohtml -r doc/*
}
