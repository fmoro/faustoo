# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EGIT_REPO_URI="git://github.com/jeffdameth/ecomp.git"
inherit git libtool flag-o-matic

DESCRIPTION="e17 window manager with compiz"
HOMEPAGE="http://code.google.com/p/itask-module/wiki/Stuff
http://web.enlightenment.org/"

LICENSE="BSD"
SLOT="0"
IUSE="local pam nls doc -patches"

RDEPEND=">=x11-wm/enlightenment-9999-r1"

DEPEND="${RDEPEND}
	x11-proto/xproto
	sys-devel/libtool"

src_unpack() {
	git_src_unpack
	if use patches; then
		# The following are some patches that I personally use. These run fine
		# on my system. You can uncomment them if you want. Don't forget to do
		# ebuild /usr/local/portage/x11-wm/ecomp/ecomp-9999.ebuild digest after
		# uncommenting these lines
		# 
		# Change to the source directory before doing any patching. This line
		# *must* be uncommented if you uncomment any lines further below
		cd $S
		#
		# There is a patch for compiz which reduces artifacts and text
		# corruptions seen with *nvidia* cards. The original patch is from
		# http://gitweb.compiz-fusion.org/?p=fusion/plugins/workarounds;a=commit;h=46960f12a9d213e5f0e841557e2ed2f7ea18cc79
		# Personally, I have not seen much text corruption with this patch
		# applied.  I will test this patch for a couple of days, then ask the
		# ecomorph maintainer to consider adding it as an option which can be
		# toggled from the eco config dialog (I don't know enough C to do this).
		# Uncomment the following line: 
		epatch ${FILESDIR}/nvidia.patch || die "patch failed"
	fi
}

src_compile() {
	# We need to filter the --as-needed LDFLAG since it breaks ecomp on runtime
	filter-ldflags "-Wl,--as-needed"
	filter-ldflags "-Wl,-O1"
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
	use local && MY_ECONF="$MY_ECONF --prefix=/usr/local"
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
