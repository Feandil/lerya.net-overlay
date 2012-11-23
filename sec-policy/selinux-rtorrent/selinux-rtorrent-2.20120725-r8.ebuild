# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="rtorrent"
BASEPOL="2.20120725-r8"
POLICY_FILES="rtorrent.if rtorrent.fc rtorrent.te"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for rtorrent"

KEYWORDS="~amd64"

pkg_postinst() {
	# Use the postinst given by the selinux eclacc
	selinux-policy-2_pkg_postinst

	# DHT port already set in policy (r6)

	elog "As the ports your rtorrent uses are probably not standard, you need to set them manually"
	elog "Please use semanage to do so"
	elog "Example : semanage port -trtorrent_port_t -ptcp -a 6890-6999"
}
