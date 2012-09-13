# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="rtorrent"
BASEPOL="2.20120725-r4"
POLICY_FILES="rtorrent.if rtorrent.fc rtorrent.te"

inherit distutils eutils selinux-policy-2

DESCRIPTION="SELinux policy for rtorrent"

KEYWORDS="~amd64"

pkg_postinst() {
	# Use the postinst given by the selinux eclacc
	selinux-policy-2_pkg_postinst

	# Set the standard DHT port
	einfo "Setting the default UDP port (6811) for the DHT"
	einfo "Verifying the presence of an existing port..."
	if test -z "$(semanage port -l |grep rtorrent_udp_port_t)"
	then
		einfo "Port not found, adding it..."
		semanage port -trtorrent_udp_port_t -pudp -a 6881
		if [ $? -ne 0 ]
		then
			ewarn "An error occured when trying to set the UDP port"
			ewarn "Please use semanage to set it yourself"
			ewarn "Example : semanage port -trtorrent_udp_port_t -pudp -a 6881"
		else
			einfo "Success"
		fi
	else
		einfo "Port already defined, no need to reset it"
	fi

        einfo "Verifying the presence of an existing TCP port"
        if test -z "$(semanage port -l |grep rtorrent_udp_port_t)"
        then
		einfo "Not found"
		elog "As the ports your rtorrent uses are probably not standard, you need to set them manually"
		elog "Please use semanage to do so"
		elog "Example : semanage port -trtorrent_tcp_port_t -ptcp -a 6890-6999"
	else
		einfo "Port already defined"
	fi
}
