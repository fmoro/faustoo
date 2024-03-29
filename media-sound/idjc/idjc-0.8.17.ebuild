# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 )
inherit autotools-utils python-single-r1

RESTRICT="mirror"
DESCRIPTION="Internet DJ Console has two media players, jingles player, crossfader, VoIP and streaming"
HOMEPAGE="http://idjc.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"

IUSE="doc ffmpeg flac mad mpg123 nls opus speex twolame"

RDEPEND="media-sound/jack-audio-connection-kit
	dev-python/eyeD3[${PYTHON_USEDEP}]
	dev-python/pygtk[${PYTHON_USEDEP}]
	media-libs/libsamplerate
	media-libs/libsndfile
	media-libs/libvorbis
	media-libs/mutagen[${PYTHON_USEDEP}]
	>=media-libs/libshout-idjc-2.4.1
	dev-libs/glib:2
	ffmpeg? ( virtual/ffmpeg )
	flac? ( media-libs/flac )
	mad? ( media-sound/lame )
	mpg123? ( media-sound/mpg123 )
	nls? ( sys-devel/gettext )
	opus? ( media-libs/opus )
	speex? ( media-libs/speex )
	twolame? ( media-sound/twolame )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	local myeconfargs=(
		$(use_enable ffmpeg libav)
		$(use_enable flac)
		$(use_enable mad lame)
		$(use_enable mpg123)
		$(use_enable nls)
		$(use_enable opus)
		$(use_enable speex)
		$(use_enable twolame)
	)
	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=( doc/ )
	autotools-utils_src_install
}
