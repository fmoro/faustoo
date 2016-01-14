# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Python client for Google Cloud Messaging for Android (GCM)"
HOMEPAGE="http://blog.namis.me/python-gcm/"
SRC_URI="https://github.com/geeknam/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"


LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"
