# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/django-tastypie/django-tastypie-0.9.15.ebuild,v 1.4 2013/06/06 09:32:46 idella4 Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_3,3_4,3_5} )

inherit distutils-r1 git-2

DESCRIPTION="MongoEngine support for Django framework"
HOMEPAGE="https://github.com/MongoEngine/django-mongoengine"
#SRC_URI="https://github.com/MongoEngine/${PN}/archive/${PV}.tar.gz"
EGIT_REPO_URI="https://github.com/MongoEngine/django-mongoengine.git"

KEYWORDS="~amd64 ~x86"
IUSE="doc +test"

LICENSE="BSD"
SLOT="0"

#RDEPEND="$(python_abi_depend ">=dev-python/django-1.5")
#	$(python_abi_depend ">=dev-python/mongoengine-0.8.3")"
#DEPEND="${RDEPEND}
#	$(python_abi_depend dev-python/setuptools)
#	doc? ( $(python_abi_depend dev-python/sphinx) )
#	test? ( $(python_abi_depend dev-python/nose)
#		$(python_abi_depend dev-python/coverage) )"
RDEPEND=">=dev-python/django-1.5[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.8.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	test? ( dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/tests-installation.patch )

python_compile_all() {
	#use doc && emake -C docs html
	if use doc; then
		"${PYTHON}" setup.py build_sphinx || die "couldn't build docs"
	fi
}

#src_test() {
#	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
#}

python_test() {
	#PYTHONPATH=.:tests ./tests/run_all_tests.sh || die
	nosetests || die "Tests fail with ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
