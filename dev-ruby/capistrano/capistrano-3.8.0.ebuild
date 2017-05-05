# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
USE_RUBY="ruby21 ruby22 ruby23"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md"

inherit ruby-fakegem

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capistranorb.com/"

LICENSE="MIT"
SLOT="3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/airbrussh-1.0.0
	>=dev-ruby/sshkit-1.9:0
	>=dev-ruby/rake-10.0.0
	dev-ruby/i18n:*
	!!<dev-ruby/capistrano-2.15.5-r2"
ruby_add_bdepend "
	test? (	dev-ruby/mocha:0.12 )"

pkg_postinst() {
	einfo "Capistrano 3.1 has some breaking changes. Please check the CHANGELOG: http://goo.gl/SxB0lr"
	einfo "If you're upgrading Capistrano from 2.x, we recommend to read the upgrade guide: http://goo.gl/4536kB"
	einfo "The 'deploy:restart' hook for passenger applications is now in a separate gem called capistrano-passenger.  Just add it to your Gemfile and require it in your Capfile."
}