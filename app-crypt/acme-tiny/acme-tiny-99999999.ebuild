# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
EGIT_REPO_URI="git://github.com/Feandil/acme-tiny.git"
PYTHON_COMPAT=(python{2_7,3_4,3_5})

inherit user git-r3 python-r1 eutils

DESCRIPTION="A tiny script to issue and renew TLS certs from Let's Encrypt "
HOMEPAGE="https://github.com/Feandil/acme-tiny"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="selinux"

DEPEND="dev-libs/libressl
	www-servers/nginx
	selinux? ( sec-policy/selinux-acme-tiny )"

pkg_setup() {
        ebegin "Creating acme-tiny group and user"
        enewgroup acme-tiny
        enewuser acme-tiny -1 -1 /opt/acme-tiny acme-tiny
        eend ${?}
}

src_prepare() {
	epatch "${FILESDIR}/${P}-fix-binary-path.patch"
	default
}

src_install() {
	dodir /opt/acme-tiny
	fowners root:root /opt/acme-tiny

	exeinto /opt/acme-tiny
	doexe renew_cert.sh

	dodir /opt/acme-tiny/certs
	fowners acme-tiny: /opt/acme-tiny/certs
	fperms 755 /opt/acme-tiny/certs

	dodir /opt/acme-tiny/acme-challenges/
	fowners nginx:acme-tiny /opt/acme-tiny/acme-challenges/
	fperms 570 /opt/acme-tiny/acme-challenges/

	python_foreach_impl python_doscript acme_tiny.py
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
