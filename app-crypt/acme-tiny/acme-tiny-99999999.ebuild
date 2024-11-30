# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8
EGIT_REPO_URI="https://github.com/Feandil/acme-tiny.git"
PYTHON_COMPAT=(python{3_12,3_13})

inherit distutils-r1 git-r3

DESCRIPTION="A tiny script to issue and renew TLS certs from Let's Encrypt "
HOMEPAGE="https://github.com/Feandil/acme-tiny"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux"

RDEPEND="dev-libs/openssl
	www-servers/nginx
	selinux? ( sec-policy/selinux-acme-tiny )
	acct-user/acme-tiny"

PATCHES=( "${FILESDIR}/${P}-fix-binary-path.patch" )

# Tests require a local ACME server to be set up.
RESTRICT="test"

src_prepare() {
	distutils-r1_src_prepare
}

python_install() {
	python_doscript acme_tiny.py
}

python_install_all() {
	dodir /opt/acme-tiny
	fowners root:root /opt/acme-tiny

	exeinto /opt/acme-tiny
	doexe renew_cert.sh

	keepdir /opt/acme-tiny/certs
	fowners acme-tiny: /opt/acme-tiny/certs
	fperms 755 /opt/acme-tiny/certs

	keepdir /opt/acme-tiny/acme-challenges/
	fowners nginx:acme-tiny /opt/acme-tiny/acme-challenges/
	fperms 570 /opt/acme-tiny/acme-challenges/
}

pkg_config()
{
	if [ -e /opt/acme-tiny/account.key ] ; then
		einfo "You already have an account key, skipping"
	else
		einfo "Creating private key"
		(umask 77 && openssl genrsa 4096 > /opt/acme-tiny/account.key)
		chown acme-tiny: /opt/acme-tiny/account.key
		chmod 0400 /opt/acme-tiny/account.key
	fi
	if [ -e /opt/acme-tiny/certs/intermediate.pem ] ; then
		einfo "You already have the Let's Encrypt intermediate, skipping"
	else
		einfo "Downloading Let's Encrypt intermediate"
		wget -O /opt/acme-tiny/certs/intermediate.pem https://letsencrypt.org/certs/lets-encrypt-x3-cross-signed.pem
	fi
}
