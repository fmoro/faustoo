# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
USE_RUBY="ruby19 ruby20 ruby21"

RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC=""

inherit ruby-fakegem

DESCRIPTION="A distributed application deployment system"
HOMEPAGE="http://capify.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/capistrano-3.1
	>=dev-ruby/capistrano-composer-0.0.3
	>=dev-ruby/capistrano-file-permissions-0.1.0"
