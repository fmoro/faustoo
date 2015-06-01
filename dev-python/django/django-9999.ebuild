# Copyright owners: Gentoo Foundation
#                   Arfrever Frehtes Taifersar Arahesis
# Distributed under the terms of the GNU General Public License v2

EAPI="5-progress"
PYTHON_ABI_TYPE="multiple"
PYTHON_BDEPEND="test? ( <<[{*-cpython *-pypy}sqlite]>> )"
PYTHON_DEPEND="<<[{*-cpython *-pypy}sqlite?]>>"
PYTHON_RESTRICTED_ABIS="2.6 3.1"
PYTHON_TESTS_RESTRICTED_ABIS="*-jython"
WEBAPP_NO_AUTO_INSTALL="yes"

inherit bash-completion-r1 distutils git-2 webapp

DESCRIPTION="High-level Python web framework"
HOMEPAGE="https://www.djangoproject.com/ https://github.com/django/django https://pypi.python.org/pypi/Django"
SRC_URI=""
EGIT_REPO_URI="https://github.com/django/django"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc sqlite test"

RDEPEND="$(python_abi_depend -e "*-jython" dev-python/imaging)
	$(python_abi_depend dev-python/setuptools)"
DEPEND="${RDEPEND}
	doc? ( $(python_abi_depend dev-python/sphinx) )"

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	python_pkg_setup
	webapp_pkg_setup
}

src_prepare() {
	distutils_src_prepare

	# Disable invalid warning.
	sed -e "s/overlay_warning = True/overlay_warning = False/" -i setup.py

	# Fix bash completion file.
	sed \
		-e "/^complete -F _django_completion /s/ manage.py / /" \
		-e "/^_python_django_completion()$/,/^complete -F _python_django_completion /d" \
		-i extras/django_bash_completion
}

src_compile() {
	distutils_src_compile

	if use doc; then
		einfo "Generation of documentation"
		pushd docs > /dev/null
		emake html
		popd > /dev/null
	fi
}

src_test() {
	testing() {
		# Tests have non-standard assumptions about PYTHONPATH and work not with usual "build-${PYTHON_ABI}/lib".
		python_execute PYTHONPATH="." "$(PYTHON)" tests/runtests.py --settings=test_sqlite -v1
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install

	newbashcomp extras/django_bash_completion django-admin
	bashcomp_alias django-admin django-admin.py

	if use doc; then
		dohtml -r docs/_build/html/
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r django/contrib/admin/static/admin/*

	webapp_src_install
}

pkg_postinst() {
	distutils_pkg_postinst

	elog "A copy of the admin media is available to webapp-config for installation in a webroot,"
	elog "as well as the traditional location in Python's site-packages directory for easy development."
	webapp_pkg_postinst
}
