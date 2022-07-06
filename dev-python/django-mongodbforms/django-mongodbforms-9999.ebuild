# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2+ )

inherit distutils-r1 git-2

DESCRIPTION="A flexible and capable API layer for django utilising serialisers"
HOMEPAGE="https://github.com/jschrewe/django-mongodbforms"
#SRC_URI="https://github.com/jschrewe/${PN}/archive/${PV}.tar.gz"
#EGIT_REPO_URI="https://github.com/jschrewe/django-mongodbforms"
EGIT_REPO_URI="https://github.com/fmoro/django-mongodbforms"

KEYWORDS="~amd64 ~x86"
IUSE="bip doc digest xml oauth test yaml"

LICENSE="BSD"
SLOT="0"

RDEPEND=">=dev-python/django-1.4[${PYTHON_USEDEP}]
	>=dev-python/mongoengine-0.8.3[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_compile_all() {
	use doc && emake -C docs html
}

src_test() {
	DISTUTILS_NO_PARALLEL_BUILD=1 distutils-r1_src_test
}

python_test() {
	PYTHONPATH=.:tests ./tests/run_all_tests.sh || die
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	distutils-r1_python_install_all
}
