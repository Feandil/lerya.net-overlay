# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/nagios-plugins/nagios-plugins-1.4.16-r3.ebuild,v 1.3 2014/08/03 16:25:19 tgall Exp $

EAPI=8

PATCHSET=2

inherit autotools multilib

DESCRIPTION="Additionnal plugins for Icinga, Naemon, Nagios, Shinken, Sensu, and other monitoring applications"
HOMEPAGE="https://github.com/MonitoringPlug/monitoringplug/"
SRC_URI="https://github.com/MonitoringPlug/monitoringplug/archive/monitoringplug-0.17.0-rc.1.tar.gz -> monitoringplug-0.17.0_rc1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="cups curl dns fcgi gnutls -ipmi libvirt -mysql -postgres json ldap smb selinux"

DEPEND="cups? ( net-print/cups )
	curl? ( net-misc/curl )
	dns?  ( net-libs/ldns )
	fcgi? ( dev-libs/fcgi )
	gnutls? ( net-libs/gnutls )
	ipmi? ( sys-libs/openipmi )
	libvirt? ( app-emulation/libvirt )
	mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql-base )
	json? ( dev-libs/json-c )
	ldap? ( net-nds/openldap )
	smb? ( net-fs/samba )"


# tests try to ssh into the box itself
RESTRICT="test"

RDEPEND="${DEPEND}"

S="${WORKDIR}/monitoringplug-monitoringplug-0.17.0-rc.1"

src_prepare() {
	epatch "${FILESDIR}/monitoringplug-0.17.0_rc1-fcgi_ping_close.patch"
	epatch "${FILESDIR}/monitoringplug-0.17.0_rc1-dnssec_trace-add_resolver.patch"
	eapply_user
	eautoreconf
}

src_configure() {
	local myconf
	myconf+="
		--without-oping
		--without-redis
		--without-selinux
		--without-termios
		--without-varnish"

	if ! use postgres; then
		sed 's/pgsql//' -i Makefile.am
	fi

	if ! use curl; then
		sed 's/curl//' -i Makefile.am
	fi

	if ! use dns; then
		sed 's/dns//' -i Makefile.am
	fi

	if ! use selinux ; then
		sed 's/selinux//' -i Makefile.am
	fi

	sed 's/dummy//' -i Makefile.am
	sed '/check_dhcp_LDADD/d;s/check_dhcp//' -i base/Makefile.am

	econf \
		$(use_with mysql) \
		$(use_with gnutls) \
		$(use_with ipmi) \
		$(use_with json) \
		$(use_with ldap) \
		$(use_with libvirt) \
		$(use_with smb smbclient)
#		--libexecdir=/usr/$(get_libdir)/nagios/plugins \
}

src_compile() {
	default
}


src_install() {
	default
}

pkg_postinst() {
	elog "This ebuild has a number of USE flags which determines what nagios is able to monitor."
	elog "Depending on what you want to monitor with nagios, some or all of these USE"
	elog "flags need to be set for nagios to function correctly."
}
