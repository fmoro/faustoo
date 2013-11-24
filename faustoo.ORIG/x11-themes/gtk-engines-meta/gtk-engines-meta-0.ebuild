# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

DESCRIPTION="Metapackage for install all gtk-engines themes"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="gtk3 qt"

DEPEND="x11-themes/murrine-themes
	x11-themes/gtk-engines-aurora
	x11-themes/gtk-engines-candido
	x11-themes/gtk-engines-cleanice
	x11-themes/gtk-engines-dwerg
	x11-themes/gtk-engines-experience
	x11-themes/experience
	x11-themes/gtk-engines-flat
	x11-themes/gtk-engines-murrine
	x11-themes/gtk-engines-nimbus
	x11-themes/gtk-engines-nodoka
	qt? ( x11-themes/gtk-engines-qt )
	x11-themes/gtk-engines-qtcurve
	x11-themes/gtk-engines-qtpixmap
	x11-themes/gtk-engines-rezlooks
	x11-themes/gtk-engines-ubuntulooks
	x11-themes/gtk-engines-xfce
	gtk3? ( x11-themes/gtk-engines-unico )
"

RDEPEND=""

