# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins/nagios-plugins-1.4.16-r3.ebuild,v 1.3 2014/08/03 16:25:19 tgall Exp $

EAPI=4

PATCHSET=2

inherit autotools eutils multilib user versionator

DESCRIPTION="Standard plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications"
HOMEPAGE="https://www.monitoring-plugins.org/"
SRC_URI="https://github.com/monitoring-plugins/monitoring-plugins/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86"
IUSE="+ssl bdi samba mysql postgres ldap snmp nagios-dns nagios-ntp nagios-ping nagios-ssh nagios-game ups ipv6 radius +suid jabber gnutls sudo smart"

DEPEND="ldap? ( >=net-nds/openldap-2.0.25 )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	ssl? (
		!gnutls? ( >=dev-libs/openssl-0.9.6g )
		gnutls? ( net-libs/gnutls )
	)
	radius? ( >=net-dialup/radiusclient-0.3.2 )"

# tests try to ssh into the box itself
RESTRICT="test"

RDEPEND="${DEPEND}
	>=dev-lang/perl-5.6.1-r7
	bdi? ( dev-db/libdbi )
	samba? ( >=net-fs/samba-2.2.5-r1 )
	snmp? (
		>=dev-perl/Net-SNMP-4.0.1-r1
		net-analyzer/net-snmp
	)
	mysql? ( dev-perl/DBI
			 dev-perl/DBD-mysql )
	nagios-dns? ( >=net-dns/bind-tools-9.2.2_rc1 )
	nagios-ntp? ( >=net-misc/ntp-4.1.1a )
	nagios-ping? ( >=net-analyzer/fping-2.4_beta2-r1 )
	nagios-ssh? ( >=net-misc/openssh-3.5_p1 )
	ups? ( >=sys-power/nut-1.4 )
	nagios-game? ( >=games-util/qstat-2.6 )
	jabber? ( >=dev-perl/Net-Jabber-2.0 )
	sudo? ( >=app-admin/sudo-1.8.5 )
	smart? ( sys-apps/smartmontools )"

REQUIRED_USE="smart? ( sudo )"

pkg_setup() {
	enewgroup nagios
	enewuser nagios -1 /bin/bash /var/nagios/home nagios
}

src_prepare() {
	epatch "${FILESDIR}/monitoring-plugins-2.0_configure-bump-gettext-version.patch"
	epatch "${FILESDIR}/monitoring-plugins-2.0_configure-use-pg_config-to-find-where-to-find-Postgr.patch"

	eautoreconf
}

src_configure() {
	local myconf
	if use ssl; then
		myconf+="
			$(use_with !gnutls openssl /usr)
			$(use_with gnutls gnutls /usr)"
	else
		myconf+=" --without-openssl --without-gnutls"
	fi

	econf \
		$(use_with mysql) \
		$(use_with ipv6) \
		$(use_with ldap) \
		$(use_with radius) \
		$(use_with postgres pgsql /usr) \
		${myconf} \
		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
		--sysconfdir=/etc/nagios
}

src_compile() {
	default

	make THANKS ChangeLog
}

DOCS=( ACKNOWLEDGEMENTS AUTHORS CODING ChangeLog FAQ NEWS README REQUIREMENTS SUPPORT THANKS )

src_install() {
	default

	local nagiosplugindir=/usr/$(get_libdir)/nagios/plugins

	if use sudo; then
		cat - > "${T}"/50${PN} <<EOF
# we add /bin/false so that we don't risk causing syntax errors if all USE flags
# are off as we'd end up with an empty set
Cmnd_Alias NAGIOS_PLUGINS_CMDS = /bin/false $(use smart && echo ", /usr/sbin/smartctl")
User_Alias NAGIOS_PLUGINS_USERS = nagios, icinga

NAGIOS_PLUGINS_USERS ALL=(root) NOPASSWD: NAGIOS_PLUGINS_CMDS
EOF

		insinto /etc/sudoers.d
		doins "${T}"/50${PN}
	fi

	# enforce permissions/owners (seem to trigger only in some case)
	chown -R root:nagios "${D}${nagiosplugindir}" || die
	chmod -R o-rwx "${D}${nagiosplugindir}" || die

	use suid && fperms 04710 ${nagiosplugindir}/check_{icmp,ide_smart,dhcp}
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags which determines what nagios is able to monitor."
	elog "Depending on what you want to monitor with nagios, some or all of these USE"
	elog "flags need to be set for nagios to function correctly."
}
