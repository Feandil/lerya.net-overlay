# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="yubisql_pam"
BASEPOL="2.20120725-r7"
POLICY_FILES="yubisql_pam.if yubisql_pam.fc yubisql_pam.te"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for yubisql_pam"

KEYWORDS="~amd64"
