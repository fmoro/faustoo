# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils python git-2 autotools

EGIT_BRANCH="master"

if use pvr; then
	EGIT_REPO_URI="git://github.com/tkurbad/xbmc-rbp.git"
else
	EGIT_REPO_URI="git://github.com/xbmc/xbmc-rbp.git"
fi

DESCRIPTION="XBMC is a free and open source media-player and entertainment hub"
HOMEPAGE="http://xbmc.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="airplay alsa avahi bluetooth bluray css debug external-ffmpeg joystick
	midi +nfs profile +pvr +rsxs rtmp +samba webserver"

COMMON_DEPEND="!media-tv/xbmc-rbp
	app-arch/bzip2
	app-arch/unzip
	app-arch/zip
	airplay? ( app-pda/libplist )
	alsa? ( media-libs/alsa-lib )
	bluetooth? ( net-wireless/bluez )
	>=dev-lang/python-2.4
	dev-libs/boost
	dev-libs/fribidi
	dev-libs/libcdio[-minimal]
	dev-libs/libpcre[cxx]
	>=dev-libs/lzo-2.04
	dev-libs/tinyxml
	dev-libs/yajl
	>=dev-python/pysqlite-2
	dev-python/simplejson
	media-libs/bcm2835-libs
	media-libs/flac
	media-libs/freetype
	media-libs/jasper
	media-libs/jbigkit
	virtual/jpeg
	>=media-libs/libass-0.9.7
	bluray? ( media-libs/libbluray )
	css? ( media-libs/libdvdcss )
	external-ffmpeg? ( >=virtual/ffmpeg-0.10 )
	media-libs/libmad
	media-libs/libmodplug
	media-libs/libmpeg2
	media-libs/libogg
	media-libs/libpng
	media-libs/libsamplerate
	media-libs/libvorbis
	media-libs/sdl-image
	media-libs/tiff
	media-sound/wavpack
	rtmp? ( media-video/rtmpdump )
	avahi? ( net-dns/avahi )
	webserver? ( net-libs/libmicrohttpd )
	net-misc/curl
	nfs? ( net-fs/libnfs )
	samba? ( >=net-fs/samba-3.4.6[smbclient] )
	sys-apps/dbus
	sys-libs/zlib
	virtual/mysql"
RDEPEND="${COMMON_DEPEND}"
DEPEND="${COMMON_DEPEND}
	dev-util/gperf
	dev-util/cmake"

pkg_setup() {
	enewgroup xbmc
	enewuser xbmc -1 -1 /var/xbmc xbmc,audio,usb,video
}

src_unpack() {
	git-2_src_unpack
	cd "${S}"
	rm -f configure

	# Fix case sensitivity
	mv media/Fonts/{a,A}rial.ttf || die
	mv media/{S,s}plash.png || die
}

src_prepare() {
	# Patch configure.in to (eventually) support alsa ... on Raspberry PI
	epatch "${FILESDIR}/${P}-configure.patch"
	use alsa && epatch "${FILESDIR}/${P}-enable_alsa.patch"

	local bcm_includes
	bcm_includes="bcm_host.h"
	bcm_includes+=" EGL GLES GLES2"
	bcm_includes+=" IL interface KHR"
	bcm_includes+=" vcinclude VG"
	for bcm_include in ${bcm_includes}; do
		ln -s "/opt/vc/include/${bcm_include}" "${S}/${bcm_include}"
	done

	# Disable bluetooth (not working since net-wireless/bluez-4.7)
	use bluetooth || \
		sed -i "/^AC_CHECK_LIB(\[bluetooth\],/d" ${S}/configure.in 

	# some dirs ship generated autotools, some dont
	local d
	for d in \
		. \
		lib/{libdvd/lib*/,cpluff,libapetag,libid3tag/libid3tag} \
		xbmc/screensavers/rsxs-* \
		xbmc/visualizations/Goom/goom2k4-0
	do
		[[ -e ${d}/configure ]] && continue
		pushd ${d} >/dev/null
		einfo "Generating autotools in ${d}"
		eautoreconf
		popd >/dev/null
	done

	sed -i \
		-e 's/ -DSQUISH_USE_SSE=2 -msse2//g' \
		lib/libsquish/Makefile.in || die

	# Fix XBMC's final version string showing as "exported"
	# instead of the SVN revision number.
	export HAVE_GIT=no GIT_REV=${EGIT_VERSION:-exported}

	# Avoid lsb-release dependency
	sed -i \
		-e 's:lsb_release -d:cat /etc/gentoo-release:' \
		xbmc/utils/SystemInfo.cpp || die

	# avoid long delays when powerkit isn't running #348580
	sed -i \
		-e '/dbus_connection_send_with_reply_and_block/s:-1:3000:' \
		xbmc/linux/*.cpp || die

	epatch_user #293109

	# Tweak autotool timestamps to avoid regeneration
	find . -type f -print0 | xargs -0 touch -r configure
}

src_configure() {
	# Disable documentation generation
	export ac_cv_path_LATEX=no
	# Avoid help2man
	export HELP2MAN=$(type -P help2man || echo true)

	econf \
		--with-platform=raspberry-pi \
		--disable-gl \
		--enable-gles \
		--disable-x11 \
		--disable-sdl \
		--docdir=/usr/share/doc/${PF} \
		--disable-ccache \
		--enable-optimizations \
		--enable-external-libraries \
		--disable-goom \
		--disable-hal \
		--disable-pulse \
		--disable-vaapi \
		--disable-vdpau \
		--disable-xrandr \
		$(use_enable airplay) \
		$(use_enable alsa) \
		$(use_enable avahi) \
		$(use_enable bluray libbluray) \
		$(use_enable css dvdcss) \
		$(use_enable debug) \
		$(use_enable external-ffmpeg) \
		$(use_enable joystick) \
		$(use_enable midi mid) \
		$(use_enable nfs) \
		$(use_enable profile profiling) \
		$(use_enable rsxs) \
		$(use_enable rtmp) \
		$(use_enable samba) \
		$(use_enable webserver)
}

src_install() {
	emake install DESTDIR="${D}" || die
	prepalldocs

	insinto "$(python_get_sitedir)" #309885
	doins tools/EventClients/lib/python/xbmcclient.py || die
	newbin "tools/EventClients/Clients/XBMC Send/xbmc-send.py" xbmc-send || die

	newinitd "${FILESDIR}/xbmc.initd" xbmc
	newconfd "${FILESDIR}/xbmc.confd" xbmc
}

pkg_postinst() {
	elog "Visit http://wiki.xbmc.org/?title=XBMC_Online_Manual"
}
