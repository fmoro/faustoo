# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6
USE_RUBY="ruby25 ruby26 ruby27"

inherit versionator

if [ $(get_version_component_range 4) -eq 0 ]; then
	RUBY_FAKEGEM_VERSION="$(get_version_component_range 1-3).$(get_version_component_range 4)"
fi
RUBY_FAKEGEM_TASK_DOC=""
RUBY_FAKEGEM_EXTRADOC=""

inherit ruby-fakegem

DESCRIPTION="Symfony 2 (standard edition) specific tasks for Capistrano v3 (inspired by capifony)"
HOMEPAGE="https://github.com/capistrano/symfony/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_rdepend "
	>=dev-ruby/capistrano-3.1
	>=dev-ruby/capistrano-composer-0.0.3
	>=dev-ruby/capistrano-file-permissions-1.0.0"
