# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python{2_7,3_5,3_6,3_7} pypy )

inherit distutils-r1 prefix

SRC_URI="https://dev.gentoo.org/~twitch153/${PN}/${P}.tar.bz2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86"

DESCRIPTION="Gentoo's installer for web-based applications"
HOMEPAGE="https://sourceforge.net/projects/webapp-config/"

LICENSE="GPL-2"
SLOT="0"
IUSE="selinux +portage"

DEPEND="app-text/xmlto
selinux? ( sec-policy/selinux-apache )
sys-apps/gentoo-functions"
RDEPEND="
	portage? ( sys-apps/portage[${PYTHON_USEDEP}] )"

python_prepare_all() {
	epatch "${FILESDIR}/webapp-config-1.55-manage-recursive-server-owned-files-independently.patch" || die "Patch failed"
	epatch "${FILESDIR}/webapp-config-1.55-add-SELinux-support.patch" || die "Patch failed"
	if use selinux; then
		sed -i -e "s/'g_selinux'         : 'no',/'g_selinux'         : 'yes',/" ${WORKDIR}/${P}/WebappConfig/config.py || die "Unable to activate selinux by default"
	fi

	distutils-r1_python_prepare_all
	eprefixify WebappConfig/eprefix.py config/webapp-config
}

python_compile_all() {
	emake -C doc/
}

python_install() {
	# According to this discussion:
	# http://mail.python.org/pipermail/distutils-sig/2004-February/003713.html
	# distutils does not provide for specifying two different script install
	# locations. Since we only install one script here the following should
	# be ok
	distutils-r1_python_install --install-scripts="${EPREFIX}/usr/sbin"
}

python_install_all() {
	distutils-r1_python_install_all

	insinto /etc/vhosts
	doins config/webapp-config

	keepdir /usr/share/webapps
	keepdir /var/db/webapps

	dodoc AUTHORS
	doman doc/*.[58]
	dohtml doc/*.[58].html
}

python_test() {
	PYTHONPATH="." "${PYTHON}" WebappConfig/tests/external.py \
		|| die "Testing failed with ${EPYTHON}"
}

pkg_postinst() {
	elog "Now that you have upgraded webapp-config, you **must** update your"
	elog "config files in /etc/vhosts/webapp-config before you emerge any"
	elog "packages that use webapp-config."
}
