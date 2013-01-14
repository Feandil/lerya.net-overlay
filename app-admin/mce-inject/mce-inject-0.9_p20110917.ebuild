# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit linux-info eutils toolchain-funcs vcs-snapshot

DESCRIPTION="A tool to inject Machine Check Exceptions"
HOMEPAGE="http://mcelog.org/"
SRC_URI="https://github.com/andikleen/${PN}/tarball/f087343b6954f51840adc8e039590ac43e3e549e -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="selinux"

RDEPEND="selinux? ( sec-policy/selinux-mcelog )"

CONFIG_CHECK="~X86_MCE_INJECT"

src_prepare() {
        epatch "${FILESDIR}"/${P}-destdir.patch
	tc-export CC
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc README
}
