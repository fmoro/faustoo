
# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit autotools

DESCRIPTION="Internet DJ Console"
HOMEPAGE="http://web.bethere.co.uk/idjc/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mp4"
RDEPEND=">=dev-python/pygtk-2.6.1
	>=dev-python/eyeD3-0.6.4
	>=media-sound/lame-3.96.1"

DEPEND=">=media-sound/jack-audio-connection-kit-0.99.0-r1
	>=media-libs/libshout-2.1
	>=media-sound/vorbis-tools-1.0.1
	>=media-libs/xine-lib-1.1.2-r2
	>=media-libs/flac-1.1.2-r3
	>=media-libs/libsamplerate-0.1.1-r1
	mp4? ( media-libs/faad2 )
	media-video/ffmpeg
	media-libs/mutagen
	${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	if has_version \>=media-video/ffmpeg-0.4.9_p20080326 ; then
		for x in $(find . -name "*.[ch]" -print0 | xargs -0 grep -l "#include <ffmpeg/avcodec.h>" ); do
		    sed -i -e "/avcodec\.h/s:ffmpeg:libavcodec:" $x;
		done
		for x in $(find . -name "*.[ch]" -print0 | xargs -0 grep -l "#include <ffmpeg/avformat.h>" ); do
		    sed -i -e "/avformat\.h/s:ffmpeg:libavformat:" $x;
		done
	fi

	eautoreconf
}

src_install() {
	make DESTDIR="${D}" install || die "make install failed"
}

pkg_postinst() {
	einfo "In order to run idjc you first need to have a JACK sound server running."
	einfo "With all audio apps closed and sound servers on idle type the following:"
	einfo "jackd -d alsa -r 44100 -p 2048"
	einfo "Alternatively to have JACK start automatically when launching idjc:"
	einfo "echo \"/usr/bin/jackd -d alsa -r 44100 -p 2048\" >~/.jackdrc"
}

