# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/mcelog/mcelog-1.0_pre3_p20120918.ebuild,v 1.1 2012/10/24 16:17:09 hasufell Exp $

EAPI=5

inherit linux-info eutils toolchain-funcs vcs-snapshot

DESCRIPTION="A tool to log and decode Machine Check Exceptions"
HOMEPAGE="http://mcelog.org/"
SRC_URI="https://github.com/andikleen/${PN}/tarball/0f5d0238ca7fb963a687a3c50c96c5f37a599c6b -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux -install-tests"

RDEPEND="selinux? ( sec-policy/selinux-mcelog )
	install-tests? ( app-admin/mce-inject )"

CONFIG_CHECK="~X86_MCE"

# Tests are not run when installing (too dangerous + sandboxing issues), thus are installed
RESTRICT="test"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-0.8_pre1-timestamp-${PN}.patch \
		"${FILESDIR}"/${P}-build.patch \
		"${FILESDIR}"/${P}-warnings.patch \
		"${FILESDIR}"/${P}-remove_doc_warning.patch \
		"${FILESDIR}"/${P}-post_install_tests.patch
	sed -e "/PATH/d" -e "s/\([[:blank:]]*\).*\/input\/GEN/\1..\/input\/GEN/" -e "/B=/d" -i tests/*/inject
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install

	insinto /etc/logrotate.d/
	newins ${PN}.logrotate ${PN}

	newinitd "${FILESDIR}"/${PN}.init ${PN}

	dodoc CHANGES README TODO *.pdf

	if use install-tests; then
		emake -C tests DESTDIR="${D}" install
		insinto /usr/share/${PN}/tests/
		doins tests/Makefile
	fi
}
