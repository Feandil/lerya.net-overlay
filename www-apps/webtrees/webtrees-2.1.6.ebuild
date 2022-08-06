# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/owncloud/owncloud-7.0.2.ebuild,v 1.1 2014/08/29 12:14:32 voyageur Exp $

EAPI=6

inherit eutils webapp

DESCRIPTION="Web based family history software"
HOMEPAGE="http://www.webtrees.net/index.php/en/"
SRC_URI="https://github.com/fisharebest/${PN}/releases/download/${PV}/${P}.zip"
S="${WORKDIR}/webtrees"
LICENSE="GPL-2"

KEYWORDS="~amd64 ~arm ~x86"
IUSE="+gd +simplexml +xml"

DEPEND=""
RDEPEND="dev-lang/php[gd?,iconv,mysql,pdo,simplexml?,xml?]"
need_httpd_cgi

pkg_setup() {
	webapp_pkg_setup
}

src_install() {
	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/data

	webapp_src_install
}
