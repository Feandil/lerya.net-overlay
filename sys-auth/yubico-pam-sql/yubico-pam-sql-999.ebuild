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

pkg_setup() {
        ebegin "Creating yubisql group and user"
        enewgroup yubisql
        enewuser yubisql -1 -1 /etc/yubisql yubisql
        eend ${?}
}

src_prepare() {
	cd "${S}"
	eautoreconf
}

src_install() {
	cd "${S}"
	emake install DESTDIR="${D}" PAMDIR="$(get_libdir)/security"
	find "${D}" -type f -name \*.a -delete
	find "${D}" -type f -name \*.la -delete

	fowners root:yubisql /usr/sbin/manage_OTP
	fperms  2550 /usr/sbin/manage_OTP

	fowners root:yubisql /usr/bin/check_OTP
	fperms  2555 /usr/bin/check_OTP

	mkdir -p ${D}/etc/yubisql
	fowners yubisql:yubisql /etc/yubisql
	fperms 2770 /etc/yubisql
}

pkg_config() {
	/usr/sbin/manage_OTP -s /etc/yubisql/db -c
	chown yubisql:yubisql /etc/yubisql/db
	chmod 660 /etc/yubisql/db
}
