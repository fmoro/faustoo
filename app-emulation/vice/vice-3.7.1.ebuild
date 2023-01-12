# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools xdg

DESCRIPTION="The Versatile Commodore Emulator"
HOMEPAGE="http://vice-emu.sourceforge.io/"
SRC_URI="mirror://sourceforge/vice-emu/releases/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="alsa cpuhistory debug doc ethernet ffmpeg flac gif +gtk headless ipv6 lame mpg123 ogg oss +opengl openmp parport pci png portaudio pulseaudio sdl sdlsound zlib"
REQUIRED_USE="|| ( gtk headless sdl ) gtk? ( zlib )"

RDEPEND="
	virtual/libintl
	alsa? ( media-libs/alsa-lib )
	ethernet? (
		>=net-libs/libpcap-0.9.8
		>=net-libs/libnet-1.1.2.1:1.1
	)
	ffmpeg? ( media-video/ffmpeg:= )
	flac? ( media-libs/flac )
	gif? ( media-libs/giflib:= )
	gtk? (
		dev-libs/atk
		dev-libs/glib:2
		media-libs/fontconfig:1.0
		sys-libs/readline:0=
		x11-libs/cairo
		x11-libs/gdk-pixbuf:2
		x11-libs/gtk+:3[X]
		x11-libs/libX11
		x11-libs/pango
		opengl? (
			media-libs/glew:0=
			virtual/opengl
		)
	)
	lame? ( media-sound/lame )
	mpg123? ( media-sound/mpg123 )
	ogg? (
		media-libs/libogg
		media-libs/libvorbis
	)
	parport? ( sys-libs/libieee1284 )
	pci? ( sys-apps/pciutils )
	png? ( media-libs/libpng:0= )
	portaudio? ( media-libs/portaudio )
	pulseaudio? ( media-sound/pulseaudio )
	sdl? (
		media-libs/libsdl2[video]
		media-libs/sdl2-image
		sys-libs/readline:0=
	)
	sdlsound? ( media-libs/libsdl2[sound] )
	zlib? ( sys-libs/zlib )
"

DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"
BDEPEND="
	app-arch/unzip
	app-text/dos2unix
	dev-embedded/xa
	dev-lang/perl
	sys-apps/texinfo
	sys-devel/flex
	sys-devel/gettext
	virtual/pkgconfig
	virtual/yacc
	doc? ( virtual/texi2dvi )
	gtk? ( x11-misc/xdg-utils )
"

src_prepare() {
	default

	# Strip the predefined C(XX)FLAGS.
	sed -i -r 's:(VICE_C(XX)?FLAGS=)"[^$]+":\1:' configure || die
}

src_configure() {
	# Some dependencies lack configure options so prevent them becoming
	# automagic by using configure cache variables.
	use pci || export ac_cv_header_pci_pci_h=no

	# Ensure we use giflib, not ungif.
	export ac_cv_lib_ungif_EGifPutLine=no

	econf \
		--program-transform-name="${xform}" \
		--disable-arch \
		$(use_enable cpuhistory) \
		$(use_enable debug) \
		$(use_enable debug debug-gtk3ui) \
		$(use_enable gtk desktop-files) \
		$(use_enable ffmpeg) \
		$(use_enable headless headlessui) \
		--enable-html-docs \
		$(use_enable ethernet) \
		$(use_enable opengl hwscale) \
		$(use_enable ipv6) \
		$(use_enable lame) \
		$(use_enabile openmp) \
		$(use_enable parport libieee1284) \
		$(use_enable gtk gtk3ui) \
		$(use_enable doc pdf-docs) \
		$(use_enable portaudio) \
		--disable-sdl1ui \
		$(use_enable sdl sdl2ui) \
		--disable-shared-ffmpeg \
		--disable-static-ffmpeg \
		$(use_with alsa) \
		$(use_with flac) \
		$(use_with gif) \
		$(use_with mpg123) \
		$(use_with oss) \
		$(use_with png) \
		$(use_with pulseaudio pulse) \
		$(use_with sdlsound) \
		$(use_with ogg vorbis) \
		$(use_with zlib)
}

src_install() {
	# Get xdg-desktop-menu to play nicely while doing the install.
	dodir /etc/xdg/menus /usr/share/{applications,desktop-directories}
	XDG_UTILS_INSTALL_MODE=system \
	XDG_DATA_DIRS="${ED}"/usr/share \
	XDG_CONFIG_DIRS="${ED}"/etc/xdg \
		default
	rm -f "${ED}"/usr/share/applications/*.cache || die

	# VICE extras
	docinto html
	dodoc doc/html/*.{html,css}
	dodoc -r doc/html/images

	insinto /usr/share/vim/vimfiles/ftdetect
	doins doc/vim/ftdetect/*.vim

	insinto /usr/share/vim/vimfiles/syntax
	doins doc/vim/syntax/*.vim
}
