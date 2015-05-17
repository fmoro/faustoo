# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_TESTS_FAILURES_TOLERANT_ABIS="3.1 *-jython"
DISTUTILS_SRC_TEST="setup.py"

inherit distutils

DESCRIPTION="Python driver for MongoDB"
HOMEPAGE="https://github.com/mongodb/mongo-python-driver https://pypi.python.org/pypi/pymongo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="*"
IUSE="doc test"

RDEPEND=""
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )
	test? (
		dev-db/mongodb
		$(python_abi_depend -i "2.6 3.1" dev-python/unittest2)
	)"

PYTHON_MODULES="bson gridfs pymongo"

src_prepare() {
	distutils_src_prepare
	sed -e "/^sys.path\[0:0\] =/d" -i doc/conf.py

	# Fix Sphinx theme.
	sed \
		-e "s/^html_theme = \"pydoctheme\"/html_theme = \"alabaster\"/" \
		-e "/^html_theme_options =/d" \
		-i doc/conf.py

	# Fix compatibility with Python 3.1.
	# int.from_bytes() and int.to_bytes() were introduced in Python 3.2.
	sed -e "69s/if PY3:/if __import__('sys').version_info[:2] >= (3, 2):/" -i pymongo/auth.py
	sed -e "s/if sys.version_info\[:2\] == (2, 6):/if sys.version_info[:2] == (2, 6) or sys.version_info[:2] == (3, 1):/" -i test/__init__.py

	# Avoid rebuilding of extension modules in src_test().
	sed -e "s/^from distutils.command.build_ext import build_ext$/from setuptools.command.build_ext import build_ext/" -i setup.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		python_execute PYTHONPATH="$(ls -d build-$(PYTHON -f --ABI)/lib*):." sphinx-build doc html || die "Generation of documentation failed"
	fi
}

distutils_src_test_pre_hook() {
	mkdir -p "${T}/tests-${PYTHON_ABI}/mongo.db"
	python_execute mongod --dbpath "${T}/tests-${PYTHON_ABI}/mongo.db" --fork --logpath "${T}/tests-${PYTHON_ABI}/mongo.log" --smallfiles --unixSocketPrefix "${T}/tests-${PYTHON_ABI}"
}

distutils_src_test_post_hook() {
	killall -u "$(id -nu)" mongod
	rm -fr "${T}/tests-${PYTHON_ABI}/mongo.db"
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r html/
	fi
}
