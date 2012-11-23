# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $
EAPI="4"

IUSE=""
MODS="rss2email"
BASEPOL="2.20120725-r8"
POLICY_FILES="rss2email.if rss2email.fc rss2email.te"

inherit selinux-policy-2

DESCRIPTION="SELinux policy for rss2email"

KEYWORDS="~amd64"
