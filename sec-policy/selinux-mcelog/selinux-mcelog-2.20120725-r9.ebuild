# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="mcelog"
BASEPOL="2.20120725-r9"
POLICY_FILES="mcelog.if mcelog.fc mcelog.te"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for mcelog"

KEYWORDS="~amd64"
