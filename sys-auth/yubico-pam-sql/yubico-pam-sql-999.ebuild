# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit eutils autotools git-2 multilib
EGIT_REPO_URI="git://github.com/Feandil/yubisql_pam.git"

DESCRIPTION="YubiSQL_PAM: PAM module for Yubikeys, using a SQL local database"
HOMEPAGE="https://github.com/Feandil/yubisql_pam"
SRC_URI=""

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE=""

DEPEND="sys-libs/pam
        >dev-db/sqlite-3
        dev-libs/openssl"
RDEPEND="${DEPEND}"

src_prepare() {
	cd "${S}"
	eautoreconf
}

src_install() {
	cd "${S}"
	emake install DESTDIR="${D}" PAMDIR="$(get_libdir)/security"
	find "${D}" -type f -name \*.a -delete
	find "${D}" -type f -name \*.la -delete
}
