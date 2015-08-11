# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"

inherit distutils

DESCRIPTION="MongoEngine is a Python Object-Document Mapper for working with MongoDB."
HOMEPAGE="https://github.com/MongoEngine/mongoengine https://pypi.python.org/pypi/mongoengine"
SRC_URI="https://github.com/MongoEngine/mongoengine/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="*"
IUSE="doc"

RDEPEND="$(python_abi_depend ">=dev-python/pymongo-2.5")"
DEPEND="${RDEPEND}
	$(python_abi_depend dev-python/setuptools)
	doc? ( $(python_abi_depend dev-python/sphinx) )"

src_prepare() {
	distutils_src_prepare
	sed -e "/^sys.path.insert(0, os.path.abspath('..'))$/d" -i docs/conf.py
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		PYTHONPATH="../build-$(PYTHON -f --ABI)/lib" emake html
		popd > /dev/null
	fi
}

src_install() {
	distutils_src_install

	if use doc; then
		dohtml -r docs/_build/html/
	fi
}
